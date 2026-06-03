# Repository Guidelines

## Project Structure & Module Organization

Waste2Taste is a Flutter app with two backend services. The active frontend lives in `waste2taste_flutter/` with Riverpod providers, GoRouter routes, generated Freezed models, and ML Kit ingredient scanning. Legacy Expo/React Native files remain in `app/`, `components/`, `context/`, `data/`, and `types/` for reference only. Static prototype files (`index.html`, `style.css`, `script.js`) are separate from the app. Backend code is split into `backend/api/` for the Hono TypeScript API gateway and `backend/ml/` for the FastAPI ML service. Database migrations are in `backend/supabase/migrations/`, docs in `docs/`, and image assets in `assets/`.

## Build, Test, and Development Commands

Run shell commands with the local `rtk` prefix. Common commands:

```bash
cd waste2taste_flutter
rtk flutter pub get
rtk dart run build_runner build --delete-conflicting-outputs
rtk flutter analyze
rtk flutter test
rtk flutter run -d android --dart-define=API_URL=http://10.0.2.2:8080
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

Use Dart for the active Flutter frontend, TypeScript for the API code, and Python for ML code. Follow existing naming: Flutter widgets use PascalCase (`app_button.dart` file, `AppButton` class), providers use descriptive snake_case filenames, generated model files stay committed, API route files use lowercase feature names, and tests use `*.test.ts`, `test_*.py`, or Flutter `*_test.dart`. Keep catalog changes centralized before seeding or consuming them elsewhere.

## Testing Guidelines

Run `rtk flutter analyze` and `rtk flutter test` before Flutter changes. API tests use Vitest under `backend/api/tests/`; run all with `rtk npm test` or a single file such as `rtk npm test -- tests/pantry.test.ts`. ML tests use Pytest under `backend/ml/tests/`; run `rtk pytest` or `rtk pytest tests/test_detect.py`.

## Commit & Pull Request Guidelines

Git history uses Conventional Commit-style prefixes such as `feat:`, `fix:`, and `docs:`. Keep commits scoped and imperative, for example `feat: add pantry item expiry filter`. PRs should describe behavior changes, list verification commands, link related issues or specs, and include screenshots for UI changes.

## Security & Configuration Tips

Do not commit real secrets. Start from `.env.example`, `backend/api/.env.example`, and `backend/ml/.env.example`. Keep the ML service internal; frontend requests should go through the API gateway.
