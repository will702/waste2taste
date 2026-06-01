CREATE INDEX IF NOT EXISTS idx_pantry_items_user_id ON pantry_items(user_id);
CREATE INDEX IF NOT EXISTS idx_pantry_items_ingredient_id ON pantry_items(ingredient_id);
CREATE INDEX IF NOT EXISTS idx_cooked_meals_user_id ON cooked_meals(user_id);
CREATE INDEX IF NOT EXISTS idx_cooked_meals_recipe_id ON cooked_meals(recipe_id);
CREATE INDEX IF NOT EXISTS idx_recipe_ingredients_ingredient_id ON recipe_ingredients(ingredient_id);
