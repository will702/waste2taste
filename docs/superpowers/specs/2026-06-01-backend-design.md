# Backend Design — Waste2Taste

**Date:** 2026-06-01  
**Status:** Approved  
**Scope:** Full backend — authentication, database, pantry/recipe API, ingredient detection ML, recipe recommender

---

## Context

Waste2Taste is a React Native / Expo mobile app for pantry management and waste-reducing recipe generation. The frontend is complete but entirely frontend-only — all data is hardcoded, auth screens are UI placeholders, and the scan feature has no logic.

This design covers building the complete backend from scratch to make the app functional: persisting user data, authenticating users, detecting ingredients from camera images, and recommending recipes from a user's pantry.

---

## System Architecture

```
Mobile App (Expo React Native)
base URL: https://api.waste2taste.com
          │
          │ HTTPS + JWT Bearer token
          ▼
┌──────────────────────────────────────┐
│  Node.js API Gateway  (Cloud Run)    │
│  Framework: Hono  Port: 8080         │
│  ├── JWT auth middleware             │
│  ├── /auth/*    → Supabase Auth SDK  │
│  ├── /pantry/*  → Supabase Postgres  │
│  ├── /recipes/* → Supabase Postgres  │
│  ├── /history/* → Supabase Postgres  │
│  └── /ml/*      → Python ML service  │
└──────────┬───────────────┬───────────┘
           │               │ Internal HTTP (Cloud Run VPC)
           ▼               ▼
┌─────────────────┐  ┌──────────────────────────────────┐
│ Supabase        │  │ Python ML Service (Cloud Run)     │
│ - Postgres      │  │ Framework: FastAPI + Uvicorn      │
│ - Auth (JWT)    │  │ ├── POST /detect                  │
│ - Row-level sec │  │ │    └── Google Vision API        │
└─────────────────┘  │ └── POST /recommend               │
                     │      └── HF Dataset (in-memory)  │
                     └──────────────────────────────────┘
```

**Key constraint:** The Python ML service has `ingress=internal-only` on Cloud Run — it is never directly reachable from the internet, only from the Node.js API service.

---

## Node.js API Service

**Framework:** Hono (TypeScript, lightweight, Cloud Run optimized)  
**Runtime:** Node.js 20 LTS

### Auth Flow

1. `POST /auth/register` → `supabase.auth.signUp({ email, password })` → returns `{ access_token, refresh_token, user }`
2. `POST /auth/login` → `supabase.auth.signInWithPassword()` → returns tokens
3. All protected routes require `Authorization: Bearer <access_token>`
4. JWT middleware: `supabase.auth.getUser(token)` → extracts `user_id`, attaches to request context
5. Tokens are JWTs signed by Supabase — no custom token handling needed

### API Routes

| Method | Route | Auth | Description |
|--------|-------|------|-------------|
| POST | `/auth/register` | No | Create account |
| POST | `/auth/login` | No | Sign in, returns JWT |
| POST | `/auth/logout` | Yes | Invalidate session |
| GET | `/auth/me` | Yes | Current user profile |
| GET | `/pantry` | Yes | User's pantry items |
| POST | `/pantry` | Yes | Add ingredient(s) |
| PATCH | `/pantry/:ingredientId` | Yes | Update quantity |
| DELETE | `/pantry/:ingredientId` | Yes | Remove ingredient |
| GET | `/ingredients` | Yes | Full ingredient catalog |
| GET | `/recipes` | Yes | All recipes |
| GET | `/recipes/recommend` | Yes | ML-ranked by pantry match |
| GET | `/recipes/:id` | Yes | Single recipe detail |
| POST | `/history` | Yes | Log cooked meal |
| GET | `/history` | Yes | User cooking history |
| POST | `/ml/detect` | Yes | Ingredient detection from image |
| POST | `/ml/recommend` | Yes | Recipe recommendation |

---

## Database Schema (Supabase Postgres)

```sql
-- Ingredient catalog (seeded from catalog.ts + HF dataset preprocessing)
CREATE TABLE ingredients (
  id        TEXT PRIMARY KEY,     -- e.g. "rice", "egg"
  name      TEXT NOT NULL,
  category  TEXT NOT NULL,        -- grain | protein | produce | pantry
  unit      TEXT NOT NULL,
  color     TEXT,
  accent    TEXT
);

-- User pantry — RLS: users see only their own rows
CREATE TABLE pantry_items (
  id             UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id        UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  ingredient_id  TEXT REFERENCES ingredients(id),
  quantity       INTEGER NOT NULL DEFAULT 1,
  updated_at     TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, ingredient_id)
);

-- Recipe catalog (seeded from catalog.ts + Indonesian HF dataset)
CREATE TABLE recipes (
  id           TEXT PRIMARY KEY,
  title        TEXT NOT NULL,
  subtitle     TEXT,
  time_minutes INTEGER,
  servings     INTEGER,
  difficulty   TEXT,              -- easy | medium | hard
  hero_color   TEXT,
  accent_color TEXT,
  waste_note   TEXT,
  source       TEXT DEFAULT 'catalog'  -- 'catalog' | 'huggingface'
);

-- Recipe ↔ ingredient join table
CREATE TABLE recipe_ingredients (
  recipe_id     TEXT REFERENCES recipes(id),
  ingredient_id TEXT REFERENCES ingredients(id),
  quantity      TEXT,
  required      BOOLEAN DEFAULT true,
  PRIMARY KEY (recipe_id, ingredient_id)
);

-- Cooking history — RLS: users see only their own rows
CREATE TABLE cooked_meals (
  id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id    UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  recipe_id  TEXT REFERENCES recipes(id),
  cooked_at  TIMESTAMPTZ DEFAULT now(),
  saved      BOOLEAN DEFAULT false,
  notes      TEXT
);
```

Row-level security policies on `pantry_items` and `cooked_meals`:
```sql
CREATE POLICY "Users access own pantry" ON pantry_items
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users access own history" ON cooked_meals
  FOR ALL USING (auth.uid() = user_id);
```

---

## Python ML Service

**Framework:** FastAPI + Uvicorn  
**Python:** 3.11

### Ingredient Detection — `POST /detect`

```
Request:  { "image_b64": "<base64-encoded JPEG>" }
Response: { "detected_ingredients": ["rice", "egg", "tomato"] }
```

Flow:
1. Decode base64 image
2. Call Google Vision API `label_detection` (max 20 labels)
3. Filter labels with confidence > 0.70
4. Normalize label text: lowercase, strip whitespace
5. Fuzzy-match each label against ingredient catalog using RapidFuzz (`token_sort_ratio`)
6. Return ingredient IDs where fuzzy score > 80

Key dependencies: `google-cloud-vision`, `rapidfuzz`

### Recipe Recommender — `POST /recommend`

```
Request:  { "pantry": ["rice", "egg", "soy-sauce"] }
Response: {
  "recipes": [
    { "id": "nasi-goreng", "title": "Nasi Goreng", "match_pct": 85, "missing": ["garlic", "shallot"] }
  ]
}
```

Flow:
1. **At startup:** Load `junwatu/indonesian-recipes` from HuggingFace datasets → Pandas DataFrame, cache in module-level variable
2. **Preprocess (startup):** Normalize ingredient strings in each recipe (lowercase, strip, split on commas/semicolons)
3. **On request:**
   a. For each recipe: `score = |pantry ∩ recipe_ingredients| / |recipe_ingredients|`
   b. Filter: score ≥ 0.50
   c. Sort by score descending, return top 10
   d. For each result: compute `missing = recipe_ingredients - pantry`

Key dependencies: `datasets` (HuggingFace), `pandas`, `rapidfuzz`

**Cold start:** Dataset loads once at container start (~3-5 seconds). All subsequent requests use cached DataFrame.

---

## Project Structure

```
waste2taste/
├── app/                        # (existing Expo frontend — unchanged)
├── backend/
│   ├── api/                    # Node.js Hono API gateway
│   │   ├── src/
│   │   │   ├── index.ts
│   │   │   ├── middleware/
│   │   │   │   └── auth.ts     # JWT verification via Supabase
│   │   │   ├── routes/
│   │   │   │   ├── auth.ts
│   │   │   │   ├── pantry.ts
│   │   │   │   ├── recipes.ts
│   │   │   │   ├── history.ts
│   │   │   │   └── ml.ts       # proxies /detect and /recommend to Python
│   │   │   └── lib/
│   │   │       └── supabase.ts # Supabase client singleton
│   │   ├── Dockerfile
│   │   └── package.json
│   ├── ml/                     # Python FastAPI ML service
│   │   ├── main.py
│   │   ├── routers/
│   │   │   ├── detect.py
│   │   │   └── recommend.py
│   │   ├── services/
│   │   │   ├── vision.py       # Google Vision API wrapper
│   │   │   └── dataset.py      # HF dataset loader + ingredient scorer
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   └── supabase/
│       └── migrations/         # SQL migration files (schema above)
```

---

## Environment Variables (Google Secret Manager)

| Variable | Service | Description |
|----------|---------|-------------|
| `SUPABASE_URL` | api | Supabase project URL |
| `SUPABASE_SERVICE_ROLE_KEY` | api | Server-side Supabase key (bypasses RLS for admin ops) |
| `SUPABASE_ANON_KEY` | api | Client key for auth operations |
| `ML_SERVICE_URL` | api | Internal Cloud Run URL of Python service |
| `GOOGLE_APPLICATION_CREDENTIALS` | ml | Path to GCP service account JSON |
| `HUGGINGFACE_TOKEN` | ml | HuggingFace access token (if dataset is gated) |

---

## Deployment (Google Cloud Run)

**API service (`api`):**
- Public ingress
- Min instances: 0, Max: 10
- Memory: 512Mi, CPU: 1

**ML service (`ml`):**
- Ingress: internal-only (VPC connector, not reachable from internet)
- Min instances: 0, Max: 5
- Memory: 2Gi (for dataset in RAM), CPU: 2

**CI/CD:** Cloud Build triggers on push to `main` → builds Docker images → deploys to Cloud Run.

---

## Frontend Integration

The Expo app needs these changes to connect to the backend:
1. Replace `PantryContext` in-memory state with API calls to `/pantry/*`
2. Wire `login.tsx` and `signup.tsx` to `/auth/login` and `/auth/register`
3. Store JWT in `expo-secure-store`
4. Wire `scan.tsx` to `POST /ml/detect` (send base64 camera image)
5. Wire `recipes.tsx` recommend tab to `GET /recipes/recommend`

---

## Verification

End-to-end test sequence:
1. `POST /auth/register` → verify 200 + JWT returned
2. `GET /pantry` (with JWT) → verify empty array
3. `POST /pantry` body `{ "ingredient_id": "rice", "quantity": 2 }` → verify 201
4. `GET /pantry` → verify rice appears
5. `POST /ml/detect` with test food image → verify ingredient IDs returned
6. `GET /recipes/recommend` → verify recipes ranked by pantry match
7. `POST /history` → verify meal logged
8. `GET /history` → verify logged meal appears
9. Test RLS: create 2 users, verify user A cannot see user B's pantry