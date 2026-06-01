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

seed().then(() => process.exit(0)).catch((e) => { console.error(e); process.exit(1) })
