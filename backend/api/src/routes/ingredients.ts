import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'
import { supabase } from '../lib/supabase.js'
import type { AppEnv } from '../types.js'

export const ingredients = new Hono<AppEnv>()
ingredients.use('*', authMiddleware)

ingredients.get('/', async (c) => {
  const { data, error } = await supabase
    .from('ingredients')
    .select('*')
    .order('name', { ascending: true })

  if (error) return c.json({ error: error.message }, 500)
  return c.json(data)
})
