CREATE TABLE IF NOT EXISTS ingredients (
  id        TEXT PRIMARY KEY,
  name      TEXT NOT NULL,
  category  TEXT NOT NULL CHECK (category IN ('grain', 'protein', 'produce', 'pantry')),
  unit      TEXT NOT NULL,
  color     TEXT,
  accent    TEXT
);
