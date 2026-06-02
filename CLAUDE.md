# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

Waste2Taste: mobile app for pantry management and waste-reducing recipe generation. Four independently deployable pieces:

- **Flutter frontend** — `waste2taste_flutter/` (Material 3, Riverpod, GoRouter, ML Kit) — **active frontend**
- **Expo frontend** — `app/`, `components/`, `context/`, `data/` — legacy, kept for reference
- **Node.js API gateway** — `backend/api/` (Hono, TypeScript, Cloud Run)
- **Python ML service** — `backend/ml/` (FastAPI, internal-only Cloud Run)
- **Web mockup** — `index.html` + `style.css` + `script.js` (standalone prototype)

---

## Commands

### Flutter frontend (`waste2taste_flutter/`)
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # regenerate freezed/.g.dart
flutter analyze           # static analysis (must be clean)
flutter test              # widget tests
flutter run -d android    # run on Android emulator/device
flutter run -d iphone     # run on iOS simulator
```

Pass `--dart-define=API_URL=http://10.0.2.2:8080` for Android emulator local dev (maps to host's localhost).

### Expo frontend (root) — legacy
```bash
npm install
npx expo start          # Metro bundler — press w (web), i (iOS), a (Android)
npm run typecheck       # tsc --noEmit
```

### Node.js API (`backend/api/`)
```bash
npm install
npm run dev             # tsx watch (hot reload)
npm test                # vitest run (all tests, no real Supabase needed)
npm run seed            # seed ingredients + recipes from data/catalog.ts
npm run build           # tsc → dist/
```

Single test file: `npm test -- tests/pantry.test.ts`

### Python ML service (`backend/ml/`)
```bash
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8001
pytest                  # run all tests
pytest tests/test_detect.py   # single test file
```

### Full stack (Docker)
```bash
docker compose up       # api on :8080, ml on :8001
```

---

## Architecture

### Data flow for key features

**Pantry → Recipe Recommend:**
1. `GET /recipes/recommend` (API) reads user's `pantry_items` from Supabase
2. Proxies `POST /recommend` to the ML service with pantry ingredient IDs
3. ML service scores recipes from in-memory HuggingFace DataFrame, returns top 10 with `match_pct`

**Ingredient Scan (Flutter — on-device):**
1. Flutter ML Kit `ImageLabeler` processes photo on-device (no network, confidenceThreshold: 0.70)
2. Labels fuzzy-matched against `ingredient_aliases.dart` via `string_similarity` (threshold: 0.80)
3. Matched catalog IDs added to pantry via `pantryProvider.addIngredients()`

**Ingredient Scan (Expo legacy — cloud):**
1. Mobile sends `POST /ml/detect` with base64 JPEG
2. API proxies to `POST /detect` on ML service
3. ML service calls Google Vision API, fuzzy-matches labels to `INGREDIENT_ALIASES`, returns catalog IDs

The ML service is **never directly reachable** from the internet — only via the API gateway through VPC.

### Supabase: two clients, two purposes

`backend/api/src/lib/supabase.ts` — service-role singleton (`SUPABASE_SERVICE_ROLE_KEY`), bypasses RLS, used for all DB queries in route handlers.

`backend/api/src/middleware/auth.ts` / `backend/api/src/routes/auth.ts` — anon-key client (`SUPABASE_ANON_KEY`), used only for auth operations (`signUp`, `signInWithPassword`, `getUser`). Auth middleware calls `getUser(token)` to verify JWTs and set `userId`/`userEmail` on the Hono context.

Do not use the service-role client for auth operations or vice versa.

### `data/catalog.ts` is the single source of truth

The ingredient and recipe data in `data/catalog.ts` is used by:
- The Expo frontend directly (hardcoded display)
- `backend/api/scripts/seed.ts` to populate Supabase `ingredients` and `recipes` tables

Any new ingredients or recipes must be added there first, then re-seeded.

### ML service startup

`backend/ml/main.py` uses FastAPI `lifespan` to load `junwatu/indonesian-recipes` from HuggingFace once at container start (~3–5s cold start). The DataFrame is cached in a module-level `_df` in `services/dataset.py`. All `/recommend` calls use this cache — no DB or network calls at inference time.

### Flutter frontend state

Riverpod `AsyncNotifierProvider` manages all state. All providers are wired to the backend API:
- `authProvider` — JWT stored in `flutter_secure_storage`, bootstraps on startup
- `pantryProvider` — optimistic updates with rollback on error
- `recipesProvider` / `recommendationsProvider` — auto-recompute when pantry changes
- `historyProvider` — logs cooked meals to API

### Expo frontend state (legacy, not wired to backend)

`context/PantryContext.tsx` manages pantry state in-memory. Kept for reference only.

### Database RLS

`pantry_items` and `cooked_meals` have Row Level Security enabled. The service-role client bypasses RLS — be careful not to introduce routes that accidentally expose one user's data to another by using the service-role client without an explicit `user_id` filter.

---

## Environment variables

Copy `.env.example` (if present) or set manually. Required for `backend/api`:
- `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `SUPABASE_ANON_KEY`
- `ML_SERVICE_URL` (e.g. `http://localhost:8001` for local dev)

Required for `backend/ml`:
- `GOOGLE_APPLICATION_CREDENTIALS` (path to GCP service account JSON)
- `HUGGINGFACE_TOKEN` (if dataset becomes gated)

`backend/api/vitest.config.ts` injects dummy env values for tests — no real Supabase or ML service needed to run the test suite.

---

## Docs

- `docs/backend/api-integrations.md` — all API routes, auth flow, ML service details
- `docs/backend/database.md` — schema, RLS policies, indexes, migration order
- `backend/DEPLOY.md` — Cloud Run deployment guide
- `docs/superpowers/specs/2026-06-01-backend-design.md` — approved backend architecture spec
- `docs/superpowers/specs/2026-06-02-flutter-migration-design.md` — Flutter migration design spec
