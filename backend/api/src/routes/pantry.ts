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
