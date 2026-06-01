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
