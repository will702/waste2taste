# Database — Waste2Taste

**Provider:** Supabase (Postgres 15)  
**Auth:** Supabase Auth (JWTs, `auth.users` built-in table)  
**Migrations:** `backend/supabase/migrations/` (5 files, run in order)

---

## Tables

### `ingredients`
Migration: `001_ingredients.sql`

Ingredient catalog. Seeded from `data/catalog.ts`. Read-only at runtime — no user writes.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| `id` | TEXT | PRIMARY KEY | Slug, e.g. `"rice"`, `"soy-sauce"` |
| `name` | TEXT | NOT NULL | Display name |
| `category` | TEXT | NOT NULL, CHECK | `grain \| protein \| produce \| pantry` |
| `unit` | TEXT | NOT NULL | e.g. `"cups"`, `"pieces"` |
| `color` | TEXT | | Hex color for UI glyph background |
| `accent` | TEXT | | Hex color for UI glyph icon |

No RLS — catalog is public to all authenticated users.

---

### `pantry_items`
Migration: `002_pantry.sql`

Per-user pantry state. Each row = one ingredient a user currently has.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| `id` | UUID | PRIMARY KEY, `gen_random_uuid()` | |
| `user_id` | UUID | NOT NULL, FK → `auth.users(id)` CASCADE | Owner |
| `ingredient_id` | TEXT | NOT NULL, FK → `ingredients(id)` | |
| `quantity` | INTEGER | NOT NULL, DEFAULT 1, CHECK ≥ 0 | |
| `updated_at` | TIMESTAMPTZ | NOT NULL, DEFAULT `now()` | Updated on PATCH |

**Unique constraint:** `(user_id, ingredient_id)` — one row per ingredient per user.

**RLS enabled.** Policy: `"Users manage own pantry"` — `ALL` operations filtered by `auth.uid() = user_id`.

---

### `recipes`
Migration: `003_recipes.sql`

Recipe catalog. Seeded from `data/catalog.ts` and optionally from the HuggingFace `junwatu/indonesian-recipes` dataset.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| `id` | TEXT | PRIMARY KEY | Slug, e.g. `"nasi-goreng"` |
| `title` | TEXT | NOT NULL | |
| `subtitle` | TEXT | | Short description |
| `time_minutes` | INTEGER | | Cook time |
| `servings` | INTEGER | | |
| `difficulty` | TEXT | CHECK | `easy \| medium \| hard` |
| `hero_color` | TEXT | | Hex for recipe card background |
| `accent_color` | TEXT | | Hex for UI accents |
| `waste_note` | TEXT | | Why this recipe reduces waste |
| `source` | TEXT | DEFAULT `'catalog'`, CHECK | `catalog \| huggingface` |

No RLS — catalog is shared across all users.

---

### `recipe_ingredients`
Migration: `003_recipes.sql`

Join table linking recipes to ingredients with quantities.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| `recipe_id` | TEXT | FK → `recipes(id)` CASCADE | |
| `ingredient_id` | TEXT | NOT NULL, FK → `ingredients(id)` CASCADE | |
| `quantity` | TEXT | | Free-form, e.g. `"2 tbsp"` |
| `required` | BOOLEAN | DEFAULT true | False = optional/garnish |

**Primary key:** `(recipe_id, ingredient_id)`

---

### `cooked_meals`
Migration: `004_history.sql`

User cooking history. Append-only — no updates.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| `id` | UUID | PRIMARY KEY, `gen_random_uuid()` | |
| `user_id` | UUID | NOT NULL, FK → `auth.users(id)` CASCADE | Owner |
| `recipe_id` | TEXT | FK → `recipes(id)` | Nullable if recipe later deleted |
| `cooked_at` | TIMESTAMPTZ | NOT NULL, DEFAULT `now()` | |
| `saved` | BOOLEAN | DEFAULT false | User bookmarked this meal |
| `notes` | TEXT | | Optional free-text notes |

**RLS enabled.** Policy: `"Users manage own history"` — `ALL` operations filtered by `auth.uid() = user_id`.

---

## Row Level Security

RLS is enabled on `pantry_items` and `cooked_meals`. Both use the same pattern:

```sql
-- pantry_items (002_pantry.sql)
ALTER TABLE pantry_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own pantry" ON pantry_items
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- cooked_meals (004_history.sql)
ALTER TABLE cooked_meals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own history" ON cooked_meals
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
```

`ingredients` and `recipes` have no RLS — they are shared catalogs readable by any authenticated user.

**Service role key** (`SUPABASE_SERVICE_ROLE_KEY`) used in the API bypasses RLS. Only used for catalog reads and seeding — pantry and history routes rely on RLS enforcement via the user's JWT.

---

## Indexes

Migration: `005_indexes.sql`

| Index | Table | Column | Purpose |
|-------|-------|--------|---------|
| `idx_pantry_items_user_id` | `pantry_items` | `user_id` | Fast user pantry lookup |
| `idx_pantry_items_ingredient_id` | `pantry_items` | `ingredient_id` | Ingredient cross-reference |
| `idx_cooked_meals_user_id` | `cooked_meals` | `user_id` | Fast history lookup per user |
| `idx_cooked_meals_recipe_id` | `cooked_meals` | `recipe_id` | Recipe popularity queries |
| `idx_recipe_ingredients_ingredient_id` | `recipe_ingredients` | `ingredient_id` | Ingredient → recipe reverse lookup |

---

## Entity Relationship

```
auth.users (Supabase built-in)
  │
  ├─< pantry_items >─── ingredients ──< recipe_ingredients >─── recipes
  │        │                                                         │
  └─< cooked_meals >────────────────────────────────────────────────┘
```

- `auth.users` owns `pantry_items` and `cooked_meals` (CASCADE DELETE)
- `ingredients` is referenced by `pantry_items` and `recipe_ingredients`
- `recipes` is referenced by `recipe_ingredients` and `cooked_meals`
- Deleting a recipe cascades to `recipe_ingredients` but leaves `cooked_meals.recipe_id` nullable

---

## Running Migrations

Migrations run in order using the Supabase CLI or by pasting into the Supabase SQL editor:

```bash
supabase db push
# or manually:
psql $DATABASE_URL -f backend/supabase/migrations/001_ingredients.sql
psql $DATABASE_URL -f backend/supabase/migrations/002_pantry.sql
psql $DATABASE_URL -f backend/supabase/migrations/003_recipes.sql
psql $DATABASE_URL -f backend/supabase/migrations/004_history.sql
psql $DATABASE_URL -f backend/supabase/migrations/005_indexes.sql
```

After migrations, seed the catalog:

```bash
cd backend/api && npx tsx scripts/seed.ts
```

---

## Seed Data

`backend/api/scripts/seed.ts` reads from `data/catalog.ts` (the same source used by the Expo frontend) and inserts rows into `ingredients` and `recipes` + `recipe_ingredients`. Safe to re-run — uses `upsert` with `onConflict: 'id'`.
