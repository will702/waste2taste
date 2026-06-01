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
  ingredient_id TEXT NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
  quantity      TEXT,
  required      BOOLEAN DEFAULT true,
  PRIMARY KEY (recipe_id, ingredient_id)
);
