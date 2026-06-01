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
