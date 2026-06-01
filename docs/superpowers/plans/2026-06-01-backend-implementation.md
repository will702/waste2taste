# Backend Implementation Plan — Waste2Taste

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a complete backend for Waste2Taste — authentication, pantry/recipe/history API, ingredient detection via Google Vision, and recipe recommendation from a HuggingFace Indonesian recipe dataset.

**Architecture:** Hono (Node.js, TypeScript) API gateway is the single entry point for the Expo mobile app. It handles auth via Supabase Auth JWT, all CRUD via Supabase Postgres, and proxies ML requests to an internal-only Python FastAPI service. Python service wraps Google Vision API for ingredient detection and loads `junwatu/indonesian-recipes` HuggingFace dataset at startup for ingredient-overlap recipe recommendation.

**Tech Stack:** Hono 4.x, Node.js 20, TypeScript 5.x, @supabase/supabase-js 2.x, Vitest | FastAPI 0.111, Python 3.11, Uvicorn, google-cloud-vision 3.x, datasets, pandas, rapidfuzz 3.x, pytest, httpx | Supabase (Postgres + Auth), Google Cloud Run, Docker

**Spec:** `docs/superpowers/specs/2026-06-01-backend-design.md`

---

## File Map

```
waste2taste/
├── backend/
│   ├── api/                         Node.js Hono API gateway
│   │   ├── src/
│   │   │   ├── index.ts             App entry, route registration
│   │   │   ├── middleware/
│   │   │   │   └── auth.ts          JWT verification middleware
│   │   │   ├── routes/
│   │   │   │   ├── auth.ts          /auth/* routes
│   │   │   │   ├── ingredients.ts   GET /ingredients
│   │   │   │   ├── pantry.ts        /pantry/* routes
│   │   │   │   ├── recipes.ts       /recipes/* routes
│   │   │   │   ├── history.ts       /history/* routes
│   │   │   │   └── ml.ts            /ml/* proxy routes
│   │   │   └── lib/
│   │   │       └── supabase.ts      Service-role Supabase client
│   │   ├── tests/
│   │   │   ├── auth.test.ts
│   │   │   ├── pantry.test.ts
│   │   │   ├── recipes.test.ts
│   │   │   ├── history.test.ts
│   │   │   └── ml.test.ts
│   │   ├── scripts/
│   │   │   └── seed.ts              Seed ingredients + catalog recipes
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   └── Dockerfile
│   ├── ml/                          Python FastAPI ML service
│   │   ├── main.py                  FastAPI app entry + startup hook
│   │   ├── routers/
│   │   │   ├── detect.py            POST /detect
│   │   │   └── recommend.py         POST /recommend
│   │   ├── services/
│   │   │   ├── vision.py            Google Vision API wrapper
│   │   │   └── dataset.py           HF dataset loader + scorer
│   │   ├── tests/
│   │   │   ├── test_detect.py
│   │   │   └── test_recommend.py
│   │   ├── requirements.txt
│   │   └── Dockerfile
│   └── supabase/
│       └── migrations/
│           ├── 001_ingredients.sql
│           ├── 002_pantry.sql
│           ├── 003_recipes.sql
│           └── 004_history.sql
```

---

## Task 1: Create project directory structure + dependencies

**Files:**
- Create: `backend/api/package.json`
- Create: `backend/api/tsconfig.json`
- Create: `backend/api/.env.example`
- Create: `backend/ml/requirements.txt`
- Create: `backend/ml/.env.example`

- [ ] **Step 1: Create Node.js package.json**

```bash
mkdir -p backend/api/src/middleware backend/api/src/routes backend/api/src/lib backend/api/tests backend/api/scripts
```

Create `backend/api/package.json`:
```json
{
  "name": "waste2taste-api",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "vitest run",
    "seed": "tsx scripts/seed.ts"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.45.0",
    "hono": "^4.5.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "tsx": "^4.16.0",
    "typescript": "^5.5.0",
    "vitest": "^2.0.0"
  }
}
```

- [ ] **Step 2: Create tsconfig.json**

Create `backend/api/tsconfig.json`:
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ES2022",
    "moduleResolution": "bundler",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*", "scripts/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

- [ ] **Step 3: Create Node .env.example**

Create `backend/api/.env.example`:
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
ML_SERVICE_URL=http://localhost:8001
PORT=8080
```

- [ ] **Step 4: Create Python requirements.txt**

```bash
mkdir -p backend/ml/routers backend/ml/services backend/ml/tests
```

Create `backend/ml/requirements.txt`:
```
fastapi==0.111.0
uvicorn[standard]==0.30.1
google-cloud-vision==3.7.2
datasets==2.20.0
pandas==2.2.2
rapidfuzz==3.9.3
python-dotenv==1.0.1
httpx==0.27.0
pytest==8.2.2
pytest-asyncio==0.23.7
pydantic==2.7.4
```

- [ ] **Step 5: Create Python .env.example**

Create `backend/ml/.env.example`:
```
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
HUGGINGFACE_TOKEN=optional-if-dataset-is-gated
```

- [ ] **Step 6: Install Node dependencies**

```bash
cd backend/api && npm install
```

Expected: `node_modules/` created, no errors.

- [ ] **Step 7: Install Python dependencies**

```bash
cd backend/ml && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt
```

Expected: all packages install without error.

- [ ] **Step 8: Commit**

```bash
git add backend/
git commit -m "chore: scaffold backend/api and backend/ml directory structure with dependencies"
```

---

## Task 2: Supabase database migrations

**Files:**
- Create: `backend/supabase/migrations/001_ingredients.sql`
- Create: `backend/supabase/migrations/002_pantry.sql`
- Create: `backend/supabase/migrations/003_recipes.sql`
- Create: `backend/supabase/migrations/004_history.sql`

- [ ] **Step 1: Write ingredients migration**

Create `backend/supabase/migrations/001_ingredients.sql`:
```sql
CREATE TABLE IF NOT EXISTS ingredients (
  id        TEXT PRIMARY KEY,
  name      TEXT NOT NULL,
  category  TEXT NOT NULL CHECK (category IN ('grain', 'protein', 'produce', 'pantry')),
  unit      TEXT NOT NULL,
  color     TEXT,
  accent    TEXT
);
```

- [ ] **Step 2: Write pantry migration**

Create `backend/supabase/migrations/002_pantry.sql`:
```sql
CREATE TABLE IF NOT EXISTS pantry_items (
  id             UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id        UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  ingredient_id  TEXT REFERENCES ingredients(id) NOT NULL,
  quantity       INTEGER NOT NULL DEFAULT 1 CHECK (quantity >= 0),
  updated_at     TIMESTAMPTZ DEFAULT now() NOT NULL,
  UNIQUE(user_id, ingredient_id)
);

ALTER TABLE pantry_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own pantry" ON pantry_items
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
```

- [ ] **Step 3: Write recipes migration**

Create `backend/supabase/migrations/003_recipes.sql`:
```sql
CREATE TABLE IF NOT EXISTS recipes (
  id           TEXT PRIMARY KEY,
  title        TEXT NOT NULL,
  subtitle     TEXT,
  time_minutes INTEGER,
  servings     INTEGER,
  difficulty   TEXT CHECK (difficulty IN ('easy', 'medium', 'hard')),
  hero_color   TEXT,
  accent_color TEXT,
  waste_note   TEXT,
  source       TEXT DEFAULT 'catalog' CHECK (source IN ('catalog', 'huggingface'))
);

CREATE TABLE IF NOT EXISTS recipe_ingredients (
  recipe_id     TEXT REFERENCES recipes(id) ON DELETE CASCADE,
  ingredient_id TEXT REFERENCES ingredients(id),
  quantity      TEXT,
  required      BOOLEAN DEFAULT true,
  PRIMARY KEY (recipe_id, ingredient_id)
);
```

- [ ] **Step 4: Write history migration**

Create `backend/supabase/migrations/004_history.sql`:
```sql
CREATE TABLE IF NOT EXISTS cooked_meals (
  id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id    UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  recipe_id  TEXT REFERENCES recipes(id),
  cooked_at  TIMESTAMPTZ DEFAULT now() NOT NULL,
  saved      BOOLEAN DEFAULT false,
  notes      TEXT
);

ALTER TABLE cooked_meals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own history" ON cooked_meals
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
```

- [ ] **Step 5: Run migrations in Supabase**

In Supabase dashboard → SQL Editor, paste and run each file in order (001 → 004).

Or via Supabase CLI (if installed):
```bash
supabase db push
```

Verify in Supabase Table Editor: all 4 tables present (`ingredients`, `pantry_items`, `recipes`, `recipe_ingredients`, `cooked_meals`).

- [ ] **Step 6: Commit**

```bash
git add backend/supabase/
git commit -m "feat: add Supabase database migrations for ingredients, pantry, recipes, history"
```

---

## Task 3: Node.js service core files (Supabase client, auth middleware, app entry)

**Files:**
- Create: `backend/api/src/lib/supabase.ts`
- Create: `backend/api/src/middleware/auth.ts`
- Create: `backend/api/src/index.ts`

- [ ] **Step 1: Write Supabase client**

Create `backend/api/src/lib/supabase.ts`:
```typescript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.SUPABASE_URL
const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!supabaseUrl || !serviceKey) {
  throw new Error('SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set')
}

// Service-role client — bypasses RLS for server-side writes
export const supabase = createClient(supabaseUrl, serviceKey, {
  auth: { autoRefreshToken: false, persistSession: false },
})
```

- [ ] **Step 2: Write auth middleware**

Create `backend/api/src/middleware/auth.ts`:
```typescript
import { createMiddleware } from 'hono/factory'
import { createClient } from '@supabase/supabase-js'
import { HTTPException } from 'hono/http-exception'

type Env = {
  Variables: {
    userId: string
    userEmail: string
  }
}

export const authMiddleware = createMiddleware<Env>(async (c, next) => {
  const authHeader = c.req.header('Authorization')
  if (!authHeader?.startsWith('Bearer ')) {
    throw new HTTPException(401, { message: 'Missing Authorization header' })
  }

  const token = authHeader.slice(7)

  // Use anon key + token to verify — getUser validates JWT with Supabase
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_ANON_KEY!
  )

  const { data: { user }, error } = await supabase.auth.getUser(token)
  if (error || !user) {
    throw new HTTPException(401, { message: 'Invalid or expired token' })
  }

  c.set('userId', user.id)
  c.set('userEmail', user.email ?? '')
  await next()
})
```

- [ ] **Step 3: Write app entry**

Create `backend/api/src/index.ts`:
```typescript
import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { logger } from 'hono/logger'
import { auth } from './routes/auth.js'
import { ingredients } from './routes/ingredients.js'
import { pantry } from './routes/pantry.js'
import { recipes } from './routes/recipes.js'
import { history } from './routes/history.js'
import { ml } from './routes/ml.js'

const app = new Hono()

app.use('*', logger())
app.use('*', cors())

app.get('/health', (c) => c.json({ status: 'ok' }))

app.route('/auth', auth)
app.route('/ingredients', ingredients)
app.route('/pantry', pantry)
app.route('/recipes', recipes)
app.route('/history', history)
app.route('/ml', ml)

app.onError((err, c) => {
  console.error(err)
  return c.json({ error: err.message }, 500)
})

const port = Number(process.env.PORT ?? 8080)
console.log(`API running on port ${port}`)

export default { port, fetch: app.fetch }
```

- [ ] **Step 4: Start server to verify it boots**

```bash
cd backend/api && cp .env.example .env   # fill in real values
npm run dev
```

Expected output:
```
API running on port 8080
```

```bash
curl http://localhost:8080/health
# {"status":"ok"}
```

- [ ] **Step 5: Commit**

```bash
git add backend/api/src/
git commit -m "feat: add Node.js Hono app entry, Supabase client, and JWT auth middleware"
```

---

## Task 4: Seed script — ingredients + catalog recipes

**Files:**
- Create: `backend/api/scripts/seed.ts`

- [ ] **Step 1: Write seed script**

Create `backend/api/scripts/seed.ts`:
```typescript
import { createClient } from '@supabase/supabase-js'
import 'dotenv/config'

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
)

const ingredients = [
  { id: 'rice',      name: 'Rice',      category: 'grain',   unit: 'cup',     color: '#FFF2CB', accent: '#B57B25' },
  { id: 'egg',       name: 'Egg',       category: 'protein', unit: 'pc',      color: '#FFF8E7', accent: '#D99A16' },
  { id: 'chicken',   name: 'Chicken',   category: 'protein', unit: 'portion', color: '#FFE1C7', accent: '#B66A2B' },
  { id: 'soy-sauce', name: 'Soy Sauce', category: 'pantry',  unit: 'tbsp',    color: '#F4D1AA', accent: '#6D2A0C' },
  { id: 'beef',      name: 'Beef',      category: 'protein', unit: 'portion', color: '#FFD7C8', accent: '#8F2F1E' },
  { id: 'butter',    name: 'Butter',    category: 'pantry',  unit: 'tbsp',    color: '#FFF0A8', accent: '#C2961A' },
  { id: 'tomato',    name: 'Tomato',    category: 'produce', unit: 'pc',      color: '#FFD0C4', accent: '#AB2A02' },
  { id: 'paprika',   name: 'Paprika',   category: 'produce', unit: 'pc',      color: '#FFE0BA', accent: '#CB5C1A' },
  { id: 'salt',      name: 'Salt',      category: 'pantry',  unit: 'pinch',   color: '#F6F0DF', accent: '#8D8066' },
  { id: 'pepper',    name: 'Pepper',    category: 'pantry',  unit: 'pinch',   color: '#E3D3BC', accent: '#4B3927' },
  { id: 'spam',      name: 'Spam',      category: 'protein', unit: 'slice',   color: '#FFD5D0', accent: '#A44434' },
  { id: 'bread',     name: 'Bread',     category: 'grain',   unit: 'slice',   color: '#FFE7B5', accent: '#A96D22' },
]

const recipes = [
  {
    id: 'nasi-goreng', title: 'Nasi Goreng Rescue',
    subtitle: 'Best match for leftover rice and eggs',
    time_minutes: 20, servings: 2, difficulty: 'easy',
    hero_color: '#AB2A02', accent_color: '#F6D695', source: 'catalog',
    waste_note: 'Uses day-old rice before it dries out and turns pantry scraps into a full meal.',
  },
  {
    id: 'butter-toast-egg', title: 'Savory Egg Toast',
    subtitle: 'A fast breakfast from bread, butter, and egg',
    time_minutes: 12, servings: 1, difficulty: 'easy',
    hero_color: '#2D5016', accent_color: '#FFE7B5', source: 'catalog',
    waste_note: 'Turns the last slices of bread into a complete meal instead of a stale snack.',
  },
  {
    id: 'paprika-chicken-bowl', title: 'Paprika Chicken Bowl',
    subtitle: 'Colorful bowl with protein and grains',
    time_minutes: 28, servings: 2, difficulty: 'medium',
    hero_color: '#D85D1D', accent_color: '#FFE0BA', source: 'catalog',
    waste_note: 'Good for using half vegetables and one leftover protein portion.',
  },
  {
    id: 'tomato-beef-rice', title: 'Tomato Beef Rice',
    subtitle: 'Comfort bowl for small leftover portions',
    time_minutes: 30, servings: 2, difficulty: 'medium',
    hero_color: '#7D2C18', accent_color: '#FFD0C4', source: 'catalog',
    waste_note: 'Stretches a small amount of beef with rice and tomato so nothing sits forgotten.',
  },
]

// recipe_id → [ingredient_id]
const recipeIngredients: Record<string, string[]> = {
  'nasi-goreng':         ['rice', 'egg', 'soy-sauce', 'tomato'],
  'butter-toast-egg':    ['bread', 'butter', 'egg', 'pepper'],
  'paprika-chicken-bowl':['rice', 'chicken', 'paprika', 'soy-sauce'],
  'tomato-beef-rice':    ['rice', 'beef', 'tomato', 'salt'],
}

async function seed() {
  console.log('Seeding ingredients...')
  const { error: ingErr } = await supabase
    .from('ingredients')
    .upsert(ingredients, { onConflict: 'id' })
  if (ingErr) throw ingErr
  console.log(`  ${ingredients.length} ingredients seeded`)

  console.log('Seeding recipes...')
  const { error: recErr } = await supabase
    .from('recipes')
    .upsert(recipes, { onConflict: 'id' })
  if (recErr) throw recErr
  console.log(`  ${recipes.length} recipes seeded`)

  console.log('Seeding recipe_ingredients...')
  const rows = Object.entries(recipeIngredients).flatMap(([recipeId, ingIds]) =>
    ingIds.map((ingredientId) => ({ recipe_id: recipeId, ingredient_id: ingredientId, required: true }))
  )
  const { error: riErr } = await supabase
    .from('recipe_ingredients')
    .upsert(rows, { onConflict: 'recipe_id,ingredient_id' })
  if (riErr) throw riErr
  console.log(`  ${rows.length} recipe_ingredient rows seeded`)

  console.log('Done.')
}

seed().catch((e) => { console.error(e); process.exit(1) })
```

- [ ] **Step 2: Install dotenv**

```bash
cd backend/api && npm install dotenv
```

- [ ] **Step 3: Run seed**

```bash
cd backend/api && npm run seed
```

Expected:
```
Seeding ingredients...
  12 ingredients seeded
Seeding recipes...
  4 recipes seeded
Seeding recipe_ingredients...
  14 recipe_ingredient rows seeded
Done.
```

Verify in Supabase Table Editor: `ingredients` has 12 rows, `recipes` has 4 rows.

- [ ] **Step 4: Commit**

```bash
git add backend/api/scripts/seed.ts backend/api/package.json
git commit -m "feat: add seed script for ingredient catalog and initial recipes"
```

---

## Task 5: Auth routes

**Files:**
- Create: `backend/api/src/routes/auth.ts`
- Create: `backend/api/tests/auth.test.ts`

- [ ] **Step 1: Write auth routes**

Create `backend/api/src/routes/auth.ts`:
```typescript
import { Hono } from 'hono'
import { createClient } from '@supabase/supabase-js'
import { authMiddleware } from '../middleware/auth.js'

export const auth = new Hono()

function anonClient() {
  return createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_ANON_KEY!
  )
}

auth.post('/register', async (c) => {
  const { email, password } = await c.req.json<{ email: string; password: string }>()
  if (!email || !password) {
    return c.json({ error: 'email and password required' }, 400)
  }

  const { data, error } = await anonClient().auth.signUp({ email, password })
  if (error) return c.json({ error: error.message }, 400)

  return c.json({
    user: { id: data.user?.id, email: data.user?.email },
    access_token: data.session?.access_token,
    refresh_token: data.session?.refresh_token,
  }, 201)
})

auth.post('/login', async (c) => {
  const { email, password } = await c.req.json<{ email: string; password: string }>()

  const { data, error } = await anonClient().auth.signInWithPassword({ email, password })
  if (error) return c.json({ error: error.message }, 401)

  return c.json({
    user: { id: data.user.id, email: data.user.email },
    access_token: data.session.access_token,
    refresh_token: data.session.refresh_token,
  })
})

auth.post('/logout', async (c) => {
  const token = c.req.header('Authorization')?.slice(7) ?? ''
  const client = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_ANON_KEY!,
    { global: { headers: { Authorization: `Bearer ${token}` } } }
  )
  await client.auth.signOut()
  return c.json({ message: 'logged out' })
})

auth.get('/me', authMiddleware, async (c) => {
  return c.json({ id: c.get('userId'), email: c.get('userEmail') })
})
```

- [ ] **Step 2: Write auth tests**

Create `backend/api/tests/auth.test.ts`:
```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest'

// Mock Supabase before importing routes
vi.mock('@supabase/supabase-js', () => ({
  createClient: vi.fn(() => ({
    auth: {
      signUp: vi.fn().mockResolvedValue({
        data: {
          user: { id: 'user-123', email: 'test@example.com' },
          session: { access_token: 'token-abc', refresh_token: 'refresh-xyz' },
        },
        error: null,
      }),
      signInWithPassword: vi.fn().mockResolvedValue({
        data: {
          user: { id: 'user-123', email: 'test@example.com' },
          session: { access_token: 'token-abc', refresh_token: 'refresh-xyz' },
        },
        error: null,
      }),
      getUser: vi.fn().mockResolvedValue({
        data: { user: { id: 'user-123', email: 'test@example.com' } },
        error: null,
      }),
      signOut: vi.fn().mockResolvedValue({ error: null }),
    },
  })),
}))

import { auth } from '../src/routes/auth.js'

describe('POST /auth/register', () => {
  it('returns 201 with user and tokens', async () => {
    const res = await auth.request('/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'test@example.com', password: 'password123' }),
    })
    expect(res.status).toBe(201)
    const json = await res.json() as any
    expect(json.user.email).toBe('test@example.com')
    expect(json.access_token).toBe('token-abc')
  })

  it('returns 400 when body is missing fields', async () => {
    const res = await auth.request('/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'test@example.com' }),
    })
    expect(res.status).toBe(400)
  })
})

describe('POST /auth/login', () => {
  it('returns 200 with tokens', async () => {
    const res = await auth.request('/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'test@example.com', password: 'password123' }),
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any
    expect(json.access_token).toBe('token-abc')
  })
})

describe('GET /auth/me', () => {
  it('returns user info with valid token', async () => {
    const res = await auth.request('/me', {
      headers: { Authorization: 'Bearer token-abc' },
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any
    expect(json.id).toBe('user-123')
  })

  it('returns 401 without token', async () => {
    const res = await auth.request('/me')
    expect(res.status).toBe(401)
  })
})
```

- [ ] **Step 3: Run tests**

```bash
cd backend/api && npm test -- tests/auth.test.ts
```

Expected: all 4 tests pass.

- [ ] **Step 4: Commit**

```bash
git add backend/api/src/routes/auth.ts backend/api/tests/auth.test.ts
git commit -m "feat: add auth routes (register, login, logout, me) with tests"
```

---

## Task 6: Ingredients route

**Files:**
- Create: `backend/api/src/routes/ingredients.ts`

- [ ] **Step 1: Write ingredients route**

Create `backend/api/src/routes/ingredients.ts`:
```typescript
import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'
import { supabase } from '../lib/supabase.js'

export const ingredients = new Hono()
ingredients.use('*', authMiddleware)

ingredients.get('/', async (c) => {
  const { data, error } = await supabase.from('ingredients').select('*').order('name')
  if (error) return c.json({ error: error.message }, 500)
  return c.json(data)
})
```

- [ ] **Step 2: Test manually**

```bash
# Start server, get token from login, then:
curl -H "Authorization: Bearer <token>" http://localhost:8080/ingredients
```

Expected: JSON array of 12 ingredients.

- [ ] **Step 3: Commit**

```bash
git add backend/api/src/routes/ingredients.ts
git commit -m "feat: add GET /ingredients route"
```

---

## Task 7: Pantry routes + tests

**Files:**
- Create: `backend/api/src/routes/pantry.ts`
- Create: `backend/api/tests/pantry.test.ts`

- [ ] **Step 1: Write pantry routes**

Create `backend/api/src/routes/pantry.ts`:
```typescript
import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'
import { supabase } from '../lib/supabase.js'

export const pantry = new Hono()
pantry.use('*', authMiddleware)

pantry.get('/', async (c) => {
  const userId = c.get('userId')
  const { data, error } = await supabase
    .from('pantry_items')
    .select('*, ingredients(*)')
    .eq('user_id', userId)
    .order('updated_at', { ascending: false })
  if (error) return c.json({ error: error.message }, 500)
  return c.json(data)
})

pantry.post('/', async (c) => {
  const userId = c.get('userId')
  const { ingredient_id, quantity = 1 } = await c.req.json<{ ingredient_id: string; quantity?: number }>()

  if (!ingredient_id) return c.json({ error: 'ingredient_id required' }, 400)

  const { data, error } = await supabase
    .from('pantry_items')
    .upsert(
      { user_id: userId, ingredient_id, quantity },
      { onConflict: 'user_id,ingredient_id' }
    )
    .select()
    .single()

  if (error) return c.json({ error: error.message }, 400)
  return c.json(data, 201)
})

pantry.patch('/:ingredientId', async (c) => {
  const userId = c.get('userId')
  const ingredientId = c.req.param('ingredientId')
  const { quantity } = await c.req.json<{ quantity: number }>()

  if (quantity === undefined) return c.json({ error: 'quantity required' }, 400)

  const { data, error } = await supabase
    .from('pantry_items')
    .update({ quantity, updated_at: new Date().toISOString() })
    .eq('user_id', userId)
    .eq('ingredient_id', ingredientId)
    .select()
    .single()

  if (error || !data) return c.json({ error: 'not found' }, 404)
  return c.json(data)
})

pantry.delete('/:ingredientId', async (c) => {
  const userId = c.get('userId')
  const ingredientId = c.req.param('ingredientId')

  const { error } = await supabase
    .from('pantry_items')
    .delete()
    .eq('user_id', userId)
    .eq('ingredient_id', ingredientId)

  if (error) return c.json({ error: error.message }, 400)
  return new Response(null, { status: 204 })
})
```

- [ ] **Step 2: Write pantry tests**

Create `backend/api/tests/pantry.test.ts`:
```typescript
import { describe, it, expect, vi } from 'vitest'

const mockPantryItem = {
  id: 'item-1',
  user_id: 'user-123',
  ingredient_id: 'rice',
  quantity: 2,
  updated_at: new Date().toISOString(),
  ingredients: { id: 'rice', name: 'Rice', category: 'grain', unit: 'cup', color: '#FFF2CB', accent: '#B57B25' },
}

vi.mock('../src/lib/supabase.js', () => ({
  supabase: {
    from: vi.fn(() => ({
      select: vi.fn().mockReturnThis(),
      eq: vi.fn().mockReturnThis(),
      order: vi.fn().mockResolvedValue({ data: [mockPantryItem], error: null }),
      upsert: vi.fn().mockReturnThis(),
      update: vi.fn().mockReturnThis(),
      delete: vi.fn().mockReturnThis(),
      single: vi.fn().mockResolvedValue({ data: mockPantryItem, error: null }),
    })),
  },
}))

vi.mock('@supabase/supabase-js', () => ({
  createClient: vi.fn(() => ({
    auth: {
      getUser: vi.fn().mockResolvedValue({
        data: { user: { id: 'user-123', email: 'test@example.com' } },
        error: null,
      }),
    },
  })),
}))

import { pantry } from '../src/routes/pantry.js'

describe('GET /pantry', () => {
  it('returns user pantry items', async () => {
    const res = await pantry.request('/', {
      headers: { Authorization: 'Bearer valid-token' },
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any[]
    expect(json[0].ingredient_id).toBe('rice')
  })
})

describe('POST /pantry', () => {
  it('adds ingredient to pantry', async () => {
    const res = await pantry.request('/', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ ingredient_id: 'rice', quantity: 2 }),
    })
    expect(res.status).toBe(201)
  })

  it('returns 400 when ingredient_id missing', async () => {
    const res = await pantry.request('/', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ quantity: 2 }),
    })
    expect(res.status).toBe(400)
  })
})

describe('DELETE /pantry/:ingredientId', () => {
  it('returns 204', async () => {
    const res = await pantry.request('/rice', {
      method: 'DELETE',
      headers: { Authorization: 'Bearer valid-token' },
    })
    expect(res.status).toBe(204)
  })
})
```

- [ ] **Step 3: Run tests**

```bash
cd backend/api && npm test -- tests/pantry.test.ts
```

Expected: all tests pass.

- [ ] **Step 4: Commit**

```bash
git add backend/api/src/routes/pantry.ts backend/api/tests/pantry.test.ts
git commit -m "feat: add pantry CRUD routes (GET, POST, PATCH, DELETE) with tests"
```

---

## Task 8: Recipe routes + tests

**Files:**
- Create: `backend/api/src/routes/recipes.ts`
- Create: `backend/api/tests/recipes.test.ts`

- [ ] **Step 1: Write recipe routes**

Create `backend/api/src/routes/recipes.ts`:
```typescript
import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'
import { supabase } from '../lib/supabase.js'

export const recipes = new Hono()
recipes.use('*', authMiddleware)

recipes.get('/', async (c) => {
  const { data, error } = await supabase
    .from('recipes')
    .select('*, recipe_ingredients(ingredient_id, quantity, required, ingredients(*))')
  if (error) return c.json({ error: error.message }, 500)
  return c.json(data)
})

recipes.get('/recommend', async (c) => {
  const userId = c.get('userId')

  const { data: pantry, error: pantryErr } = await supabase
    .from('pantry_items')
    .select('ingredient_id')
    .eq('user_id', userId)

  if (pantryErr) return c.json({ error: pantryErr.message }, 500)

  const pantryIds = (pantry ?? []).map((p: any) => p.ingredient_id)

  const mlUrl = process.env.ML_SERVICE_URL!
  const response = await fetch(`${mlUrl}/recommend`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ pantry: pantryIds }),
  })

  if (!response.ok) return c.json({ error: 'ML service unavailable' }, 502)
  return c.json(await response.json())
})

recipes.get('/:id', async (c) => {
  const id = c.req.param('id')
  const { data, error } = await supabase
    .from('recipes')
    .select('*, recipe_ingredients(ingredient_id, quantity, required, ingredients(*))')
    .eq('id', id)
    .single()
  if (error || !data) return c.json({ error: 'recipe not found' }, 404)
  return c.json(data)
})
```

- [ ] **Step 2: Write recipe tests**

Create `backend/api/tests/recipes.test.ts`:
```typescript
import { describe, it, expect, vi } from 'vitest'

const mockRecipe = {
  id: 'nasi-goreng',
  title: 'Nasi Goreng Rescue',
  difficulty: 'easy',
  recipe_ingredients: [{ ingredient_id: 'rice', required: true, ingredients: { name: 'Rice' } }],
}

vi.mock('../src/lib/supabase.js', () => ({
  supabase: {
    from: vi.fn((table: string) => ({
      select: vi.fn().mockReturnThis(),
      eq: vi.fn().mockReturnThis(),
      single: vi.fn().mockResolvedValue({ data: mockRecipe, error: null }),
      order: vi.fn().mockResolvedValue({ data: [mockRecipe], error: null }),
      mockResolvedValue: vi.fn().mockResolvedValue({ data: [mockRecipe], error: null }),
      then: (resolve: any) => resolve({ data: [mockRecipe], error: null }),
    })),
  },
}))

vi.mock('@supabase/supabase-js', () => ({
  createClient: vi.fn(() => ({
    auth: {
      getUser: vi.fn().mockResolvedValue({
        data: { user: { id: 'user-123', email: 'test@example.com' } },
        error: null,
      }),
    },
  })),
}))

import { recipes } from '../src/routes/recipes.js'

describe('GET /recipes/:id', () => {
  it('returns a single recipe', async () => {
    const res = await recipes.request('/nasi-goreng', {
      headers: { Authorization: 'Bearer valid-token' },
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any
    expect(json.id).toBe('nasi-goreng')
  })
})
```

- [ ] **Step 3: Run tests**

```bash
cd backend/api && npm test -- tests/recipes.test.ts
```

Expected: tests pass.

- [ ] **Step 4: Commit**

```bash
git add backend/api/src/routes/recipes.ts backend/api/tests/recipes.test.ts
git commit -m "feat: add recipe routes (list, detail, recommend) with tests"
```

---

## Task 9: History routes + tests

**Files:**
- Create: `backend/api/src/routes/history.ts`
- Create: `backend/api/tests/history.test.ts`

- [ ] **Step 1: Write history routes**

Create `backend/api/src/routes/history.ts`:
```typescript
import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'
import { supabase } from '../lib/supabase.js'

export const history = new Hono()
history.use('*', authMiddleware)

history.get('/', async (c) => {
  const userId = c.get('userId')
  const { data, error } = await supabase
    .from('cooked_meals')
    .select('*, recipes(id, title, hero_color)')
    .eq('user_id', userId)
    .order('cooked_at', { ascending: false })
  if (error) return c.json({ error: error.message }, 500)
  return c.json(data)
})

history.post('/', async (c) => {
  const userId = c.get('userId')
  const { recipe_id, saved = false, notes } = await c.req.json<{
    recipe_id: string
    saved?: boolean
    notes?: string
  }>()

  if (!recipe_id) return c.json({ error: 'recipe_id required' }, 400)

  const { data, error } = await supabase
    .from('cooked_meals')
    .insert({ user_id: userId, recipe_id, saved, notes })
    .select()
    .single()

  if (error) return c.json({ error: error.message }, 400)
  return c.json(data, 201)
})
```

- [ ] **Step 2: Write history tests**

Create `backend/api/tests/history.test.ts`:
```typescript
import { describe, it, expect, vi } from 'vitest'

const mockMeal = {
  id: 'meal-1',
  user_id: 'user-123',
  recipe_id: 'nasi-goreng',
  cooked_at: new Date().toISOString(),
  saved: false,
  notes: null,
  recipes: { id: 'nasi-goreng', title: 'Nasi Goreng Rescue', hero_color: '#AB2A02' },
}

vi.mock('../src/lib/supabase.js', () => ({
  supabase: {
    from: vi.fn(() => ({
      select: vi.fn().mockReturnThis(),
      eq: vi.fn().mockReturnThis(),
      order: vi.fn().mockResolvedValue({ data: [mockMeal], error: null }),
      insert: vi.fn().mockReturnThis(),
      single: vi.fn().mockResolvedValue({ data: mockMeal, error: null }),
    })),
  },
}))

vi.mock('@supabase/supabase-js', () => ({
  createClient: vi.fn(() => ({
    auth: {
      getUser: vi.fn().mockResolvedValue({
        data: { user: { id: 'user-123', email: 'test@example.com' } },
        error: null,
      }),
    },
  })),
}))

import { history } from '../src/routes/history.js'

describe('GET /history', () => {
  it('returns user cooking history', async () => {
    const res = await history.request('/', {
      headers: { Authorization: 'Bearer valid-token' },
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any[]
    expect(json[0].recipe_id).toBe('nasi-goreng')
  })
})

describe('POST /history', () => {
  it('logs a cooked meal', async () => {
    const res = await history.request('/', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ recipe_id: 'nasi-goreng' }),
    })
    expect(res.status).toBe(201)
  })

  it('returns 400 when recipe_id missing', async () => {
    const res = await history.request('/', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ saved: true }),
    })
    expect(res.status).toBe(400)
  })
})
```

- [ ] **Step 3: Run tests**

```bash
cd backend/api && npm test -- tests/history.test.ts
```

Expected: all tests pass.

- [ ] **Step 4: Commit**

```bash
git add backend/api/src/routes/history.ts backend/api/tests/history.test.ts
git commit -m "feat: add cooking history routes (GET, POST) with tests"
```

---

## Task 10: Python ML service scaffold

**Files:**
- Create: `backend/ml/main.py`
- Create: `backend/ml/routers/__init__.py`
- Create: `backend/ml/services/__init__.py`
- Create: `backend/ml/tests/__init__.py`

- [ ] **Step 1: Write main.py**

Create `backend/ml/main.py`:
```python
from contextlib import asynccontextmanager
from fastapi import FastAPI
from routers import detect, recommend
from services.dataset import load_dataset_on_startup


@asynccontextmanager
async def lifespan(app: FastAPI):
    print("Loading Indonesian recipes dataset...")
    load_dataset_on_startup()
    print("Dataset ready.")
    yield


app = FastAPI(title="Waste2Taste ML Service", lifespan=lifespan)

app.include_router(detect.router)
app.include_router(recommend.router)


@app.get("/health")
def health():
    return {"status": "ok"}
```

- [ ] **Step 2: Create __init__.py files**

```bash
touch backend/ml/routers/__init__.py
touch backend/ml/services/__init__.py
touch backend/ml/tests/__init__.py
```

- [ ] **Step 3: Verify server boots**

```bash
cd backend/ml && source venv/bin/activate
# Create placeholder routers so app can import
cat > routers/detect.py << 'EOF'
from fastapi import APIRouter
router = APIRouter()
EOF
cat > routers/recommend.py << 'EOF'
from fastapi import APIRouter
router = APIRouter()
EOF
cat > services/dataset.py << 'EOF'
def load_dataset_on_startup(): pass
EOF

uvicorn main:app --port 8001
```

Expected: server starts, `GET http://localhost:8001/health` returns `{"status":"ok"}`.

- [ ] **Step 4: Commit**

```bash
git add backend/ml/
git commit -m "feat: scaffold Python FastAPI ML service with health endpoint and lifespan startup"
```

---

## Task 11: Dataset service + recipe recommender

**Files:**
- Modify: `backend/ml/services/dataset.py`
- Modify: `backend/ml/routers/recommend.py`
- Create: `backend/ml/tests/test_recommend.py`

- [ ] **Step 1: Write failing test**

Create `backend/ml/tests/test_recommend.py`:
```python
import pytest
from unittest.mock import patch
import pandas as pd
from services.dataset import recommend_recipes, _match_to_catalog


def test_match_to_catalog_exact():
    result = _match_to_catalog("rice")
    assert result == "rice"


def test_match_to_catalog_fuzzy():
    result = _match_to_catalog("chicken meat")
    assert result == "chicken"


def test_match_to_catalog_no_match():
    result = _match_to_catalog("xylophone")
    assert result is None


def test_recommend_recipes_scores_correctly():
    mock_df = pd.DataFrame([
        {
            "Title": "Nasi Goreng",
            "Ingredients": "rice, egg, soy sauce, tomato",
            "Steps": "Cook rice. Add egg.",
        },
        {
            "Title": "Beef Stew",
            "Ingredients": "beef, tomato, salt, pepper",
            "Steps": "Brown beef.",
        },
    ])

    with patch("services.dataset._df", mock_df):
        # Preprocess mock df manually
        import services.dataset as ds
        ds._df = ds._preprocess(mock_df)
        results = recommend_recipes(["rice", "egg", "soy-sauce", "tomato"])

    assert len(results) >= 1
    nasi = next((r for r in results if "nasi" in r["title"].lower()), None)
    assert nasi is not None
    assert nasi["match_pct"] == 100
```

- [ ] **Step 2: Run test to see it fail**

```bash
cd backend/ml && source venv/bin/activate && pytest tests/test_recommend.py -v
```

Expected: `FAILED` — `recommend_recipes` and `_match_to_catalog` not implemented yet.

- [ ] **Step 3: Implement dataset service**

Replace `backend/ml/services/dataset.py`:
```python
import re
from typing import Optional
import pandas as pd
from datasets import load_dataset
from rapidfuzz import fuzz

_df: Optional[pd.DataFrame] = None

INGREDIENT_CATALOG = [
    "rice", "egg", "chicken", "soy-sauce", "beef", "butter",
    "tomato", "paprika", "salt", "pepper", "spam", "bread",
    "garlic", "onion", "oil", "ginger", "sugar",
]

# Map multi-word catalog entries to search-friendly form
_CATALOG_NORMALIZED = {
    "soy-sauce": "soy sauce",
}


def load_dataset_on_startup() -> None:
    global _df
    dataset = load_dataset("junwatu/indonesian-recipes", split="train")
    _df = _preprocess(dataset.to_pandas())


def _preprocess(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df["parsed_ingredients"] = df["Ingredients"].apply(_parse_ingredients)
    return df


def _parse_ingredients(raw: str) -> list[str]:
    if not raw or not isinstance(raw, str):
        return []
    items = re.split(r"[,;\n•·]", raw)
    return [re.sub(r"[^\w\s]", "", item).strip().lower() for item in items if item.strip()]


def _match_to_catalog(ingredient_text: str) -> Optional[str]:
    """Fuzzy-match an ingredient string to catalog. Returns catalog id or None."""
    best_score = 0
    best_id = None
    for catalog_id in INGREDIENT_CATALOG:
        display = _CATALOG_NORMALIZED.get(catalog_id, catalog_id.replace("-", " "))
        score = fuzz.token_sort_ratio(ingredient_text.lower(), display)
        if score > best_score:
            best_score = score
            best_id = catalog_id
    return best_id if best_score >= 70 else None


def recommend_recipes(pantry: list[str], top_n: int = 10) -> list[dict]:
    if _df is None:
        raise RuntimeError("Dataset not loaded. Call load_dataset_on_startup() first.")

    pantry_set = set(pantry)
    results = []

    for _, row in _df.iterrows():
        raw_ingredients: list[str] = row.get("parsed_ingredients", [])
        recipe_catalog_ids: set[str] = set()

        for ing in raw_ingredients:
            matched = _match_to_catalog(ing)
            if matched:
                recipe_catalog_ids.add(matched)

        if not recipe_catalog_ids:
            continue

        overlap = pantry_set & recipe_catalog_ids
        score = len(overlap) / len(recipe_catalog_ids)

        if score >= 0.5:
            results.append({
                "id": str(row.get("Title", "unknown")).lower().replace(" ", "-"),
                "title": row.get("Title", "Unknown"),
                "match_pct": round(score * 100),
                "missing": sorted(recipe_catalog_ids - pantry_set),
                "catalog_ingredients": sorted(recipe_catalog_ids),
                "instructions": str(row.get("Steps", ""))[:500],
            })

    results.sort(key=lambda x: x["match_pct"], reverse=True)
    return results[:top_n]
```

- [ ] **Step 4: Implement recommend router**

Replace `backend/ml/routers/recommend.py`:
```python
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from services.dataset import recommend_recipes

router = APIRouter()


class RecommendRequest(BaseModel):
    pantry: list[str]


@router.post("/recommend")
def recommend(req: RecommendRequest):
    try:
        results = recommend_recipes(req.pantry)
        return {"recipes": results}
    except RuntimeError as e:
        raise HTTPException(status_code=503, detail=str(e))
```

- [ ] **Step 5: Run tests**

```bash
cd backend/ml && source venv/bin/activate && pytest tests/test_recommend.py -v
```

Expected: all 4 tests pass.

- [ ] **Step 6: Smoke test recommender with real dataset**

```bash
uvicorn main:app --port 8001 &
sleep 5  # wait for dataset to load
curl -s -X POST http://localhost:8001/recommend \
  -H "Content-Type: application/json" \
  -d '{"pantry": ["rice", "egg", "soy-sauce"]}' | python3 -m json.tool | head -40
```

Expected: JSON with `recipes` array, each having `title`, `match_pct`, `missing`.

- [ ] **Step 7: Commit**

```bash
git add backend/ml/services/dataset.py backend/ml/routers/recommend.py backend/ml/tests/test_recommend.py
git commit -m "feat: add HuggingFace dataset recipe recommender with ingredient overlap scoring"
```

---

## Task 12: Google Vision ingredient detection

**Files:**
- Modify: `backend/ml/services/vision.py`
- Modify: `backend/ml/routers/detect.py`
- Create: `backend/ml/tests/test_detect.py`

- [ ] **Step 1: Write failing test**

Create `backend/ml/tests/test_detect.py`:
```python
import pytest
from unittest.mock import MagicMock, patch
from services.vision import detect_ingredients_from_image, _match_label_to_catalog


def test_match_label_exact():
    result = _match_label_to_catalog("rice")
    assert result == "rice"


def test_match_label_alias():
    result = _match_label_to_catalog("poultry")
    assert result == "chicken"


def test_match_label_no_match():
    result = _match_label_to_catalog("skateboard")
    assert result is None


def test_detect_from_image():
    mock_client = MagicMock()
    mock_response = MagicMock()
    mock_label_1 = MagicMock()
    mock_label_1.description = "Rice"
    mock_label_1.score = 0.97
    mock_label_2 = MagicMock()
    mock_label_2.description = "Egg"
    mock_label_2.score = 0.92
    mock_label_3 = MagicMock()
    mock_label_3.description = "Sky"
    mock_label_3.score = 0.88
    mock_response.label_annotations = [mock_label_1, mock_label_2, mock_label_3]
    mock_client.label_detection.return_value = mock_response

    import base64
    fake_image = base64.b64encode(b"fake-image-bytes").decode()

    with patch("services.vision.vision.ImageAnnotatorClient", return_value=mock_client):
        result = detect_ingredients_from_image(fake_image)

    assert "rice" in result
    assert "egg" in result
    assert "sky" not in result  # no catalog match
```

- [ ] **Step 2: Run test to see it fail**

```bash
cd backend/ml && source venv/bin/activate && pytest tests/test_detect.py -v
```

Expected: `FAILED` — `vision.py` not yet implemented.

- [ ] **Step 3: Implement vision service**

Replace `backend/ml/services/vision.py`:
```python
import base64
from typing import Optional
from google.cloud import vision
from rapidfuzz import fuzz

INGREDIENT_ALIASES: dict[str, list[str]] = {
    "rice":      ["rice", "fried rice", "steamed rice", "cooked rice", "jasmine rice"],
    "egg":       ["egg", "eggs", "chicken egg", "fried egg"],
    "chicken":   ["chicken", "poultry", "chicken meat", "roast chicken"],
    "soy-sauce": ["soy sauce", "soy", "dark soy", "tamari"],
    "beef":      ["beef", "meat", "steak", "ground beef", "minced beef"],
    "butter":    ["butter", "margarine", "dairy"],
    "tomato":    ["tomato", "tomatoes", "cherry tomato", "roma tomato"],
    "paprika":   ["paprika", "red pepper", "bell pepper", "capsicum"],
    "salt":      ["salt", "sea salt", "table salt"],
    "pepper":    ["pepper", "black pepper", "white pepper", "peppercorn"],
    "spam":      ["spam", "canned meat", "luncheon meat"],
    "bread":     ["bread", "loaf", "white bread", "toast", "baguette"],
}


def _match_label_to_catalog(label: str) -> Optional[str]:
    label_lower = label.lower().strip()
    for ingredient_id, aliases in INGREDIENT_ALIASES.items():
        for alias in aliases:
            if fuzz.token_sort_ratio(label_lower, alias) >= 80:
                return ingredient_id
    return None


def detect_ingredients_from_image(image_b64: str) -> list[str]:
    client = vision.ImageAnnotatorClient()
    image = vision.Image(content=base64.b64decode(image_b64))
    response = client.label_detection(image=image, max_results=20)

    detected: list[str] = []
    for label in response.label_annotations:
        if label.score < 0.70:
            continue
        matched_id = _match_label_to_catalog(label.description)
        if matched_id and matched_id not in detected:
            detected.append(matched_id)

    return detected
```

- [ ] **Step 4: Implement detect router**

Replace `backend/ml/routers/detect.py`:
```python
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from services.vision import detect_ingredients_from_image

router = APIRouter()


class DetectRequest(BaseModel):
    image_b64: str


@router.post("/detect")
def detect(req: DetectRequest):
    try:
        ingredients = detect_ingredients_from_image(req.image_b64)
        return {"detected_ingredients": ingredients}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Detection failed: {str(e)}")
```

- [ ] **Step 5: Run tests**

```bash
cd backend/ml && source venv/bin/activate && pytest tests/test_detect.py -v
```

Expected: all 4 tests pass.

- [ ] **Step 6: Commit**

```bash
git add backend/ml/services/vision.py backend/ml/routers/detect.py backend/ml/tests/test_detect.py
git commit -m "feat: add Google Vision ingredient detection service with alias matching and tests"
```

---

## Task 13: ML proxy routes in Node.js

**Files:**
- Create: `backend/api/src/routes/ml.ts`
- Create: `backend/api/tests/ml.test.ts`

- [ ] **Step 1: Write ML proxy routes**

Create `backend/api/src/routes/ml.ts`:
```typescript
import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'

export const ml = new Hono()
ml.use('*', authMiddleware)

const mlFetch = (path: string, body: unknown) =>
  fetch(`${process.env.ML_SERVICE_URL!}${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })

ml.post('/detect', async (c) => {
  const { image_b64 } = await c.req.json<{ image_b64: string }>()
  if (!image_b64) return c.json({ error: 'image_b64 required' }, 400)

  const res = await mlFetch('/detect', { image_b64 })
  if (!res.ok) return c.json({ error: 'Detection service error' }, 502)
  return c.json(await res.json())
})

ml.post('/recommend', async (c) => {
  const { pantry } = await c.req.json<{ pantry: string[] }>()
  if (!Array.isArray(pantry)) return c.json({ error: 'pantry must be an array' }, 400)

  const res = await mlFetch('/recommend', { pantry })
  if (!res.ok) return c.json({ error: 'Recommendation service error' }, 502)
  return c.json(await res.json())
})
```

- [ ] **Step 2: Write ML proxy tests**

Create `backend/api/tests/ml.test.ts`:
```typescript
import { describe, it, expect, vi } from 'vitest'

const mockDetectResponse = { detected_ingredients: ['rice', 'egg'] }
const mockRecommendResponse = { recipes: [{ id: 'nasi-goreng', title: 'Nasi Goreng', match_pct: 100, missing: [] }] }

vi.stubGlobal('fetch', vi.fn().mockImplementation((url: string) => {
  if (url.includes('/detect')) {
    return Promise.resolve({ ok: true, json: () => Promise.resolve(mockDetectResponse) })
  }
  return Promise.resolve({ ok: true, json: () => Promise.resolve(mockRecommendResponse) })
}))

vi.mock('@supabase/supabase-js', () => ({
  createClient: vi.fn(() => ({
    auth: {
      getUser: vi.fn().mockResolvedValue({
        data: { user: { id: 'user-123', email: 'test@example.com' } },
        error: null,
      }),
    },
  })),
}))

import { ml } from '../src/routes/ml.js'

describe('POST /ml/detect', () => {
  it('returns detected ingredients', async () => {
    const res = await ml.request('/detect', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ image_b64: 'base64encodedimage' }),
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any
    expect(json.detected_ingredients).toContain('rice')
  })

  it('returns 400 when image_b64 missing', async () => {
    const res = await ml.request('/detect', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({}),
    })
    expect(res.status).toBe(400)
  })
})

describe('POST /ml/recommend', () => {
  it('returns recipe recommendations', async () => {
    const res = await ml.request('/recommend', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ pantry: ['rice', 'egg'] }),
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any
    expect(json.recipes[0].id).toBe('nasi-goreng')
  })
})
```

- [ ] **Step 3: Run all Node tests**

```bash
cd backend/api && npm test
```

Expected: all test suites pass (auth, pantry, recipes, history, ml).

- [ ] **Step 4: Commit**

```bash
git add backend/api/src/routes/ml.ts backend/api/tests/ml.test.ts
git commit -m "feat: add ML proxy routes /ml/detect and /ml/recommend with tests"
```

---

## Task 14: Dockerfiles + docker-compose

**Files:**
- Create: `backend/api/Dockerfile`
- Create: `backend/ml/Dockerfile`
- Create: `backend/docker-compose.yml`

- [ ] **Step 1: Write Node.js Dockerfile**

Create `backend/api/Dockerfile`:
```dockerfile
FROM node:20-slim AS base
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --only=production

FROM base AS build
RUN npm ci
COPY tsconfig.json .
COPY src/ ./src/
RUN npm run build

FROM base AS runtime
COPY --from=build /app/dist ./dist
ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "dist/index.js"]
```

- [ ] **Step 2: Write Python Dockerfile**

Create `backend/ml/Dockerfile`:
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8001
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001"]
```

- [ ] **Step 3: Write docker-compose for local dev**

Create `backend/docker-compose.yml`:
```yaml
version: "3.9"
services:
  api:
    build: ./api
    ports:
      - "8080:8080"
    environment:
      - SUPABASE_URL=${SUPABASE_URL}
      - SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}
      - SUPABASE_SERVICE_ROLE_KEY=${SUPABASE_SERVICE_ROLE_KEY}
      - ML_SERVICE_URL=http://ml:8001
      - PORT=8080
    depends_on:
      - ml

  ml:
    build: ./ml
    expose:
      - "8001"
    environment:
      - GOOGLE_APPLICATION_CREDENTIALS=/app/service-account.json
    volumes:
      - ${GCP_SERVICE_ACCOUNT_JSON_PATH}:/app/service-account.json:ro
```

- [ ] **Step 4: Build and test locally**

```bash
cd backend
# Set env vars in shell from your .env files, then:
docker compose build
docker compose up
```

```bash
curl http://localhost:8080/health
# {"status":"ok"}
```

- [ ] **Step 5: Commit**

```bash
git add backend/api/Dockerfile backend/ml/Dockerfile backend/docker-compose.yml
git commit -m "feat: add Dockerfiles for api and ml services, docker-compose for local dev"
```

---

## Task 15: Google Cloud Run deployment

**Prerequisites:** GCP project created, Cloud Run API enabled, `gcloud` CLI authenticated.

- [ ] **Step 1: Set project variables**

```bash
export PROJECT_ID=your-gcp-project-id
export REGION=us-central1
export API_IMAGE=gcr.io/$PROJECT_ID/waste2taste-api
export ML_IMAGE=gcr.io/$PROJECT_ID/waste2taste-ml
```

- [ ] **Step 2: Build and push images**

```bash
gcloud auth configure-docker
docker build -t $API_IMAGE ./backend/api
docker push $API_IMAGE

docker build -t $ML_IMAGE ./backend/ml
docker push $ML_IMAGE
```

- [ ] **Step 3: Store secrets in Secret Manager**

```bash
echo -n "your-supabase-url" | gcloud secrets create SUPABASE_URL --data-file=-
echo -n "your-anon-key"     | gcloud secrets create SUPABASE_ANON_KEY --data-file=-
echo -n "your-service-key"  | gcloud secrets create SUPABASE_SERVICE_ROLE_KEY --data-file=-
```

- [ ] **Step 4: Deploy ML service (internal-only)**

```bash
gcloud run deploy waste2taste-ml \
  --image $ML_IMAGE \
  --region $REGION \
  --no-allow-unauthenticated \
  --ingress internal \
  --memory 2Gi \
  --cpu 2 \
  --min-instances 0 \
  --max-instances 5 \
  --set-secrets "GOOGLE_APPLICATION_CREDENTIALS=GCP_SERVICE_ACCOUNT:latest"
```

Note the internal URL returned — save it as `ML_SERVICE_URL`.

- [ ] **Step 5: Deploy API service (public)**

```bash
ML_URL=$(gcloud run services describe waste2taste-ml --region $REGION --format 'value(status.url)')

gcloud run deploy waste2taste-api \
  --image $API_IMAGE \
  --region $REGION \
  --allow-unauthenticated \
  --ingress all \
  --memory 512Mi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 10 \
  --set-secrets "SUPABASE_URL=SUPABASE_URL:latest,SUPABASE_ANON_KEY=SUPABASE_ANON_KEY:latest,SUPABASE_SERVICE_ROLE_KEY=SUPABASE_SERVICE_ROLE_KEY:latest" \
  --set-env-vars "ML_SERVICE_URL=$ML_URL"
```

- [ ] **Step 6: Smoke test production**

```bash
API_URL=$(gcloud run services describe waste2taste-api --region $REGION --format 'value(status.url)')

curl $API_URL/health
# {"status":"ok"}

curl -X POST $API_URL/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@waste2taste.com","password":"testpass123"}'
# {"user":{"id":"...","email":"test@waste2taste.com"},"access_token":"..."}
```

- [ ] **Step 7: Commit**

```bash
git add backend/
git commit -m "docs: add Cloud Run deployment steps and verify production health"
```

---

## Verification Sequence

Run end-to-end after all tasks complete:

```bash
API=http://localhost:8080  # or Cloud Run URL

# 1. Register
TOKEN=$(curl -s -X POST $API/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"e2e@test.com","password":"password123"}' | jq -r '.access_token')

# 2. Get empty pantry
curl -s -H "Authorization: Bearer $TOKEN" $API/pantry
# []

# 3. Add rice
curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  $API/pantry -d '{"ingredient_id":"rice","quantity":2}'

# 4. Verify rice in pantry
curl -s -H "Authorization: Bearer $TOKEN" $API/pantry | jq '.[0].ingredient_id'
# "rice"

# 5. Get recommendations (calls Python ML)
curl -s -H "Authorization: Bearer $TOKEN" $API/recipes/recommend | jq '.recipes[0].title'

# 6. Log history
curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  $API/history -d '{"recipe_id":"nasi-goreng","saved":true}'

# 7. Check history
curl -s -H "Authorization: Bearer $TOKEN" $API/history | jq '.[0].recipe_id'
# "nasi-goreng"

# 8. Detect (requires valid base64 food image)
# curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
#   $API/ml/detect -d "{\"image_b64\":\"$(base64 -i test-food-image.jpg)\"}"
```

**RLS check:** Repeat steps 1-4 with a second user, then try to access first user's pantry — should return empty array (Supabase RLS enforces row isolation automatically through the `auth.uid()` policy).
