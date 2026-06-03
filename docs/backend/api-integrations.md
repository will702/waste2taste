# Backend API & Integrations — Waste2Taste

**Base URL:** `https://api.waste2taste.com`  
**Stack:** Node.js 20 + Hono (TypeScript), Cloud Run  
**Source:** `backend/api/`

---

## Architecture

```
Mobile App (Flutter)
       │ HTTPS + JWT Bearer
       ▼
Node.js API Gateway  (Cloud Run, public ingress)
  ├── /auth/*    → Supabase Auth SDK
  ├── /pantry/*  → Supabase Postgres (RLS)
  ├── /recipes/* → Supabase Postgres
  ├── /history/* → Supabase Postgres (RLS)
  └── /ml/*      → Python ML Service (internal-only Cloud Run)
       │
       ├── Supabase (Postgres + Auth)
       └── Python ML Service (internal VPC, never internet-facing)
```

---

## Authentication

All routes except `/auth/register`, `/auth/login`, and `/health` require:

```
Authorization: Bearer <access_token>
```

**Middleware** (`backend/api/src/middleware/auth.ts`):
1. Extracts Bearer token from `Authorization` header
2. Calls `supabase.auth.getUser(token)` using the anon key client
3. On success: sets `userId` and `userEmail` in Hono context
4. On failure: throws `401 HTTPException`

Tokens are Supabase JWTs — no custom signing needed.

---

## Routes

### Auth — `/auth`

| Method | Path | Auth | Body | Response |
|--------|------|------|------|----------|
| POST | `/auth/register` | No | `{ email, password }` | `201 { user, access_token, refresh_token }` |
| POST | `/auth/login` | No | `{ email, password }` | `200 { user, access_token, refresh_token }` |
| POST | `/auth/logout` | Yes | — | `200 { message }` |
| GET | `/auth/me` | Yes | — | `200 { id, email }` |

**Register** calls `supabase.auth.signUp()` with the anon key. Returns the session tokens directly from Supabase.

**Login** calls `supabase.auth.signInWithPassword()`. Returns the same token shape.

**Logout** validates the Bearer token and returns a logout acknowledgement. The mobile app clears its stored session token.

**Me** returns `userId` and `userEmail` already extracted by auth middleware — no extra DB call.

---

### Pantry — `/pantry`

All routes require auth. Supabase RLS ensures users only see their own rows.

| Method | Path | Body | Response |
|--------|------|------|----------|
| GET | `/pantry` | — | `200 [PantryItem + ingredients join]` |
| POST | `/pantry` | `{ ingredient_id, quantity? }` | `201 PantryItem` |
| PATCH | `/pantry/:ingredientId` | `{ quantity }` | `200 PantryItem` |
| DELETE | `/pantry/:ingredientId` | — | `204` |

`POST /pantry` uses `upsert` with `onConflict: 'user_id,ingredient_id'` — safe to call repeatedly; updates quantity if the row already exists.

`GET /pantry` returns items joined with the full `ingredients` row (`select('*, ingredients(*)')`), ordered by `updated_at` descending.

---

### Ingredients — `/ingredients`

| Method | Path | Auth | Response |
|--------|------|------|----------|
| GET | `/ingredients` | Yes | `200 [Ingredient]` |

Read-only catalog. No user-specific data. No RLS on this table.

---

### Recipes — `/recipes`

| Method | Path | Auth | Response |
|--------|------|------|----------|
| GET | `/recipes` | Yes | `200 [Recipe]` |
| GET | `/recipes/recommend` | Yes | `200 { recipes: [Recipe + match_pct] }` |
| GET | `/recipes/:id` | Yes | `200 Recipe` |

`GET /recipes/recommend` reads the requesting user's pantry, then proxies to `POST /ml/recommend` on the Python service. Returns recipes sorted by `match_pct` descending.

---

### History — `/history`

| Method | Path | Auth | Body | Response |
|--------|------|------|------|----------|
| GET | `/history` | Yes | — | `200 [CookedMeal]` |
| POST | `/history` | Yes | `{ recipe_id, notes? }` | `201 CookedMeal` |

The API uses the service-role Supabase client for DB operations and must explicitly filter every user-owned query by the authenticated `user_id`.

---

### ML Proxy — `/ml`

The Node.js API proxies ML requests to the Python service. The Python service URL is internal-only and never exposed to clients.

| Method | Path | Auth | Body | Response |
|--------|------|------|------|----------|
| POST | `/ml/recommend` | Yes | `{ pantry: string[] }` | `200 { recipes: [...] }` |

Flutter uses on-device ML Kit for ingredient detection, so `/ml/detect` is retained only for legacy/internal compatibility and should not be called by the active mobile app.

---

## Python ML Service

**Source:** `backend/ml/`  
**Framework:** FastAPI + Uvicorn  
**Python:** 3.11  
**Cloud Run:** internal-only ingress (not reachable from internet)

### Startup

On container start, `lifespan` in `main.py` calls `load_dataset_on_startup()`:
- Downloads `junwatu/indonesian-recipes` from HuggingFace (cached after first pull)
- Converts to Pandas DataFrame
- Normalizes ingredient strings (lowercase, split on `,;•\n`)
- Stores in module-level `_df` — reused for all requests

Cold start takes ~3–5 seconds. All `/recommend` calls after that hit the in-memory DataFrame.

### POST /detect

**Request:** `{ "image_b64": "<base64 JPEG>" }`  
**Response:** `{ "detected_ingredients": ["rice", "egg"] }`

Flow (`backend/ml/services/vision.py`):
1. Decode `image_b64` → bytes
2. Call Google Vision API `label_detection` (max 20 labels)
3. Keep labels with `score >= 0.70`
4. Fuzzy-match each label against `INGREDIENT_ALIASES` using `fuzz.token_sort_ratio`
5. Return ingredient IDs where any alias scores `>= 80`

`INGREDIENT_ALIASES` maps catalog IDs to human-readable label variants:
```python
"soy-sauce": ["soy sauce", "soy", "dark soy", "tamari"]
"paprika":   ["paprika", "red pepper", "bell pepper", "capsicum"]
# ... 12 ingredients total
```

### POST /recommend

**Request:** `{ "pantry": ["rice", "egg", "soy-sauce"] }`  
**Response:**
```json
{
  "recipes": [
    {
      "id": "nasi-goreng",
      "title": "Nasi Goreng",
      "match_pct": 85,
      "missing": ["garlic", "shallot"],
      "catalog_ingredients": ["egg", "garlic", "rice", "shallot", "soy-sauce"],
      "instructions": "..."
    }
  ]
}
```

Scoring (`backend/ml/services/dataset.py`):
- For each recipe: fuzzy-match each raw ingredient string → catalog ID
- `score = |pantry ∩ recipe_catalog_ids| / |recipe_catalog_ids|`
- Filter: `score >= 0.50`
- Sort descending, return top 10

---

## Supabase Integration

**Client** (`backend/api/src/lib/supabase.ts`): singleton using `SUPABASE_SERVICE_ROLE_KEY` for server-side DB operations (bypasses RLS for admin use). Auth routes use a separate anon-key client per request.

**Two clients in use:**

| Client | Key | Used For |
|--------|-----|----------|
| `supabase` singleton | `SUPABASE_SERVICE_ROLE_KEY` | Pantry, recipes, history DB ops |
| Per-request anon client | `SUPABASE_ANON_KEY` | Auth operations (signUp, signIn, getUser) |

---

## Environment Variables

| Variable | Service | Required |
|----------|---------|----------|
| `SUPABASE_URL` | api | Yes |
| `SUPABASE_SERVICE_ROLE_KEY` | api | Yes |
| `SUPABASE_ANON_KEY` | api | Yes |
| `ML_SERVICE_URL` | api | Yes |
| `GOOGLE_APPLICATION_CREDENTIALS` | ml | Yes |
| `HUGGINGFACE_TOKEN` | ml | If dataset is gated |

Managed via Google Secret Manager in production. See `backend/DEPLOY.md` for Cloud Run secret mounting.

---

## Error Handling

The API returns consistent JSON errors:

```json
{ "error": "<message>" }
```

| Scenario | Status |
|----------|--------|
| Missing / invalid JWT | 401 |
| Missing required body field | 400 |
| Resource not found | 404 |
| Unhandled server error | 500 |

`app.onError` in `index.ts` catches all `HTTPException` instances and unhandled errors, returning structured JSON in both cases.

---

## Health Check

`GET /health` returns `{ "status": "ok" }` — no auth required. Used by Cloud Run readiness probe and `docker-compose` healthchecks.
