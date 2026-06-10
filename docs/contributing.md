# Contributing — Waste2Taste

Thank you for contributing. This guide covers local setup, testing, and common workflows.

---

## Prerequisites

| Tool | Version | Used for |
|------|---------|----------|
| Flutter SDK | ≥ 3.10 | Mobile app (`waste2taste_flutter/`) |
| Node.js | ≥ 20 | API gateway (`backend/api/`) |
| Python | ≥ 3.11 | ML service (`backend/ml/`) |
| Docker & Compose | latest | Optional full-stack local run |

---

## Quick start

### 1. Backend (Docker — recommended)

```bash
cp backend/api/.env.example backend/api/.env
cp backend/ml/.env.example backend/ml/.env
# Fill in Supabase credentials and GCP service account path

cd backend
docker compose up --build
```

API available at `http://localhost:8080`.

### 2. Flutter app

```bash
cd waste2taste_flutter
flutter pub get
flutter run -d android --dart-define=API_URL=http://10.0.2.2:8080
```

### 3. Seed the database

After migrations are applied to your Supabase project:

```bash
cd backend/api
npm install
npm run seed
```

---

## Running tests

```bash
# API
cd backend/api && npm test

# ML service
cd backend/ml && source venv/bin/activate && pytest

# Flutter
cd waste2taste_flutter && flutter analyze && flutter test
```

---

## Catalog data sync

When adding or editing ingredients or recipes, update **both**:

1. [`backend/api/scripts/seed.ts`](../backend/api/scripts/seed.ts) — database seed source
2. [`waste2taste_flutter/lib/data/catalog.dart`](../waste2taste_flutter/lib/data/catalog.dart) — UI display catalog

Then re-run the seed script:

```bash
cd backend/api && npm run seed
```

For ML Kit scan support, also update [`waste2taste_flutter/lib/data/ingredient_aliases.dart`](../waste2taste_flutter/lib/data/ingredient_aliases.dart) with label variants for the new ingredient.

---

## Project layout

```
waste2taste/
├── waste2taste_flutter/   Flutter mobile app
├── backend/
│   ├── api/               Hono API gateway
│   ├── ml/                FastAPI ML service
│   └── supabase/migrations/
├── docs/                  Documentation (you are here)
└── CONTRIBUTING.md        This file (root pointer)
```

---

## Commit conventions

Use Conventional Commit prefixes: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`.

Example: `feat: add pantry item expiry filter`

PRs should describe behavior changes, list verification commands run, and include screenshots for UI changes.

---

## Security

- Never commit `.env` files or credentials
- Start from `.env.example`, `backend/api/.env.example`, `backend/ml/.env.example`
- The ML service must stay internal; frontend requests go through the API gateway only

---

## Documentation

- [Docs index](README.md)
- [Architecture](architecture.md)
- [Flutter frontend](frontend/flutter.md)
- [API reference](backend/api-integrations.md)
- [Database schema](backend/database.md)
- [Deployment](../backend/DEPLOY.md)

---

## Local AI assistant setup (optional)

Files like `AGENTS.md` and `CLAUDE.md` are gitignored. To configure Cursor or similar tools locally:

```bash
cp docs/templates/AGENTS.md.example AGENTS.md
```

Customize as needed — these files will not be pushed to the remote repository.
