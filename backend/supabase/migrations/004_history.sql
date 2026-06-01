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
