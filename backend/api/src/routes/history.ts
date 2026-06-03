import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'
import { supabase } from '../lib/supabase.js'
import type { AppEnv } from '../types.js'

export const history = new Hono<AppEnv>()
history.use('*', authMiddleware)

history.get('/', async (c) => {
  const userId = c.get('userId')
  const { data, error } = await supabase
    .from('cooked_meals')
    .select('*, recipes(id, title, hero_color)')
    .eq('user_id', userId)
    .order('cooked_at', { ascending: false })
  if (error) return c.json({ error: error.message }, 500)
  return c.json(data)
})

history.post('/', async (c) => {
  const userId = c.get('userId')
  const { recipe_id, saved = false, notes } = await c.req.json<{
    recipe_id: string
    saved?: boolean
    notes?: string
  }>()

  if (!recipe_id) return c.json({ error: 'recipe_id required' }, 400)

  const { data, error } = await supabase
    .from('cooked_meals')
    .insert({ user_id: userId, recipe_id, saved, notes })
    .select()
    .single()

  if (error) return c.json({ error: error.message }, 400)
  return c.json(data, 201)
})
