import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'
import { supabase } from '../lib/supabase.js'

export const ingredients = new Hono()
ingredients.use('*', authMiddleware)

ingredients.get('/', async (c) => {
  const { data, error } = await supabase.from('ingredients').select('*').order('name')
  if (error) return c.json({ error: error.message }, 500)
  return c.json(data)
})
