import { Hono } from 'hono'
import type { Context } from 'hono'
import { createClient } from '@supabase/supabase-js'
import { authMiddleware } from '../middleware/auth.js'
import type { AppEnv } from '../types.js'

export const auth = new Hono<AppEnv>()

const supabaseUrl = process.env.SUPABASE_URL
const anonKey = process.env.SUPABASE_ANON_KEY

if (!supabaseUrl || !anonKey) {
  throw new Error('SUPABASE_URL and SUPABASE_ANON_KEY must be set')
}

const supabaseAuth = createClient(supabaseUrl, anonKey, {
  auth: { autoRefreshToken: false, persistSession: false },
})

const sessionResponse = (user: { id: string; email?: string | null }, session: {
  access_token: string
  refresh_token?: string | null
}) => ({
  user: {
    id: user.id,
    email: user.email,
  },
  access_token: session.access_token,
  refresh_token: session.refresh_token,
})

const readCredentials = async (c: Context<AppEnv>) => {
  const { email, password } = await c.req.json<{ email?: string; password?: string }>()
  if (!email || !password) {
    return null
  }
  return { email, password }
}

auth.post('/register', async (c) => {
  const credentials = await readCredentials(c)
  if (!credentials) return c.json({ error: 'email and password required' }, 400)

  const { data, error } = await supabaseAuth.auth.signUp(credentials)
  if (error) return c.json({ error: error.message }, 400)
  if (!data.user || !data.session) return c.json({ error: 'registration requires email confirmation' }, 400)

  return c.json(sessionResponse(data.user, data.session), 201)
})

auth.post('/login', async (c) => {
  const credentials = await readCredentials(c)
  if (!credentials) return c.json({ error: 'email and password required' }, 400)

  const { data, error } = await supabaseAuth.auth.signInWithPassword(credentials)
  if (error) return c.json({ error: error.message }, 401)
  if (!data.user || !data.session) return c.json({ error: 'invalid login response' }, 502)

  return c.json(sessionResponse(data.user, data.session))
})

auth.post('/logout', authMiddleware, async (c) => {
  return c.json({ message: 'logged out' })
})

auth.get('/me', authMiddleware, async (c) => {
  return c.json({
    id: c.get('userId'),
    email: c.get('userEmail'),
  })
})
