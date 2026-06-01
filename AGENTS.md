# Repository Guidelines

## Project Structure & Module Organization

Waste2Taste is an Expo + React Native TypeScript app with two backend services. Frontend routes live in `app/` using Expo Router, reusable UI is in `components/`, global pantry state is in `context/`, shared catalog/theme data is in `data/`, and app types are in `types/`. Static prototype files (`index.html`, `style.css`, `script.js`) are separate from the React Native app. Backend code is split into `backend/api/` for the Hono TypeScript API gateway and `backend/ml/` for the FastAPI ML service. Database migrations are in `backend/supabase/migrations/`, docs in `docs/`, and image assets in `assets/`.

## Build, Test, and Development Commands

Run shell commands with the local `rtk` prefix. Common commands:

```bash
rtk npm install
rtk npm run start       # Expo Metro bundler
rtk npm run web         # Expo web target
rtk npm run typecheck   # root TypeScript check
```

For the API:

```bash
cd backend/api
rtk npm install
rtk npm run dev
rtk npm test
rtk npm run build
```

For the ML service:

```bash
cd backend/ml
rtk python -m venv venv
rtk pip install -r requirements.txt
rtk uvicorn main:app --reload --port 8001
rtk pytest
```

Use `rtk docker compose up` from `backend/` to run the API and ML service together.

## Coding Style & Naming Conventions

Use TypeScript for frontend and API code, Python for ML code. Follow existing naming: React components use PascalCase (`AppButton.tsx`), hooks/context use descriptive PascalCase or camelCase, route files use lowercase feature names, and tests use `*.test.ts` or `test_*.py`. Keep catalog changes centralized in `data/catalog.ts` before seeding or consuming them elsewhere.

## Testing Guidelines

Run `rtk npm run typecheck` before frontend changes. API tests use Vitest under `backend/api/tests/`; run all with `rtk npm test` or a single file such as `rtk npm test -- tests/pantry.test.ts`. ML tests use Pytest under `backend/ml/tests/`; run `rtk pytest` or `rtk pytest tests/test_detect.py`.

## Commit & Pull Request Guidelines

Git history uses Conventional Commit-style prefixes such as `feat:`, `fix:`, and `docs:`. Keep commits scoped and imperative, for example `feat: add pantry item expiry filter`. PRs should describe behavior changes, list verification commands, link related issues or specs, and include screenshots for UI changes.

## Security & Configuration Tips

Do not commit real secrets. Start from `.env.example`, `backend/api/.env.example`, and `backend/ml/.env.example`. Keep the ML service internal; frontend requests should go through the API gateway.
