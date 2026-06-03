import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'
import { supabase } from '../lib/supabase.js'
import type { AppEnv } from '../types.js'

export const recipes = new Hono<AppEnv>()
recipes.use('*', authMiddleware)

type DbRecipe = {
  id: string
  title: string
  subtitle?: string | null
  time_minutes?: number | null
  servings?: number | null
  difficulty?: string | null
  hero_color?: string | null
  accent_color?: string | null
  waste_note?: string | null
  recipe_ingredients?: Array<{
    recipe_id: string
    ingredient_id: string
    quantity?: string | null
    required?: boolean | null
  }>
}

const displayDifficulty = (difficulty?: string | null) => {
  if (!difficulty) return 'Easy'
  return difficulty.charAt(0).toUpperCase() + difficulty.slice(1).toLowerCase()
}

const toFlutterRecipe = (recipe: DbRecipe, extra: Record<string, unknown> = {}) => {
  const recipeIngredients = recipe.recipe_ingredients ?? []
  return {
    id: recipe.id,
    title: recipe.title,
    subtitle: recipe.subtitle ?? null,
    time_minutes: recipe.time_minutes ?? 30,
    servings: recipe.servings ?? 2,
    difficulty: displayDifficulty(recipe.difficulty),
    hero_color: recipe.hero_color ?? null,
    accent_color: recipe.accent_color ?? null,
    waste_note: recipe.waste_note ?? null,
    ingredientIds: recipeIngredients.map((item) => item.ingredient_id),
    steps: [],
    recipeIngredients: recipeIngredients.map((item) => ({
      recipe_id: item.recipe_id,
      ingredient_id: item.ingredient_id,
      quantity: item.quantity ?? null,
      required: item.required ?? true,
    })),
    ...extra,
  }
}

const toFallbackRecipe = (recipe: Record<string, unknown>) => ({
  id: String(recipe.id ?? recipe.title ?? 'recommended-recipe'),
  title: String(recipe.title ?? 'Recommended recipe'),
  subtitle: 'Recommended from your pantry',
  time_minutes: 30,
  servings: 2,
  difficulty: 'Easy',
  hero_color: null,
  accent_color: null,
  waste_note: null,
  ingredientIds: Array.isArray(recipe.catalog_ingredients) ? recipe.catalog_ingredients : [],
  steps: recipe.instructions ? [String(recipe.instructions)] : [],
  recipeIngredients: [],
  match_pct: recipe.match_pct,
  missing: recipe.missing,
})

recipes.get('/', async (c) => {
  const { data, error } = await supabase
    .from('recipes')
    .select('*, recipe_ingredients(*)')

  if (error) return c.json({ error: error.message }, 500)
  return c.json((data ?? []).map((recipe) => toFlutterRecipe(recipe as DbRecipe)))
})

recipes.get('/recommend', async (c) => {
  const mlUrl = process.env.ML_SERVICE_URL
  if (!mlUrl) return c.json({ error: 'ML_SERVICE_URL is not configured' }, 500)

  const { data: pantryItems, error: pantryError } = await supabase
    .from('pantry_items')
    .select('ingredient_id')
    .eq('user_id', c.get('userId'))

  if (pantryError) return c.json({ error: pantryError.message }, 500)

  try {
    const response = await fetch(`${mlUrl}/recommend`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        pantry: (pantryItems ?? []).map((item) => item.ingredient_id),
      }),
    })
    if (!response.ok) return c.json({ error: 'Recommendation service error' }, 502)

    const mlPayload = await response.json() as { recipes?: Array<Record<string, unknown>> }
    const mlRecipes = mlPayload.recipes ?? []
    const { data: catalogRecipes, error: recipesError } = await supabase
      .from('recipes')
      .select('*, recipe_ingredients(*)')

    if (recipesError) return c.json({ error: recipesError.message }, 500)

    const catalogById = new Map((catalogRecipes ?? []).map((recipe) => [(recipe as DbRecipe).id, recipe as DbRecipe]))
    const enrichedRecipes = mlRecipes.map((recipe) => {
      const id = String(recipe.id ?? '')
      const catalogRecipe = catalogById.get(id)
      if (!catalogRecipe) return toFallbackRecipe(recipe)
      return toFlutterRecipe(catalogRecipe, {
        match_pct: recipe.match_pct,
        missing: recipe.missing,
      })
    })

    return c.json({ recipes: enrichedRecipes })
  } catch (e) {
    return c.json({ error: 'Recommendation service unavailable' }, 502)
  }
})

recipes.get('/:id', async (c) => {
  const id = c.req.param('id')
  const { data, error } = await supabase
    .from('recipes')
    .select('*, recipe_ingredients(*)')
    .eq('id', id)
    .single()

  if (error) return c.json({ error: error.message }, 404)
  return c.json(toFlutterRecipe(data as DbRecipe))
})
