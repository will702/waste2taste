import { Hono } from 'hono'
import { createClient } from '@supabase/supabase-js'
import { authMiddleware } from '../middleware/auth.js'

export const auth = new Hono()

function anonClient() {
  return createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_ANON_KEY!
  )
}

auth.post('/register', async (c) => {
  const { email, password } = await c.req.json<{ email: string; password: string }>()
  if (!email || !password) {
    return c.json({ error: 'email and password required' }, 400)
  }

  const { data, error } = await anonClient().auth.signUp({ email, password })
  if (error) return c.json({ error: error.message }, 400)

  return c.json({
    user: { id: data.user?.id, email: data.user?.email },
    access_token: data.session?.access_token,
    refresh_token: data.session?.refresh_token,
  }, 201)
})

auth.post('/login', async (c) => {
  const { email, password } = await c.req.json<{ email: string; password: string }>()
  if (!email || !password) {
    return c.json({ error: 'email and password required' }, 400)
  }

  const { data, error } = await anonClient().auth.signInWithPassword({ email, password })
  if (error) return c.json({ error: error.message }, 401)

  return c.json({
    user: { id: data.user?.id, email: data.user?.email },
    access_token: data.session?.access_token,
    refresh_token: data.session?.refresh_token,
  })
})

auth.post('/logout', async (c) => {
  const token = c.req.header('Authorization')?.slice(7) ?? ''
  const client = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_ANON_KEY!,
    { global: { headers: { Authorization: `Bearer ${token}` } } }
  )
  await client.auth.signOut()
  return c.json({ message: 'logged out' })
})

auth.get('/me', authMiddleware, async (c) => {
  return c.json({ id: c.get('userId'), email: c.get('userEmail') })
})
