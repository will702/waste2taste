import { createMiddleware } from 'hono/factory'
import { createClient } from '@supabase/supabase-js'
import { HTTPException } from 'hono/http-exception'

const supabaseUrl = process.env.SUPABASE_URL
const anonKey = process.env.SUPABASE_ANON_KEY

if (!supabaseUrl || !anonKey) {
  throw new Error('SUPABASE_URL and SUPABASE_ANON_KEY must be set')
}

// Shared anon-key client for JWT verification
const anonClient = createClient(supabaseUrl, anonKey, {
  auth: { autoRefreshToken: false, persistSession: false },
})

type Env = {
  Variables: {
    userId: string
    userEmail: string
  }
}

export const authMiddleware = createMiddleware<Env>(async (c, next) => {
  const authHeader = c.req.header('Authorization')
  if (!authHeader?.startsWith('Bearer ')) {
    throw new HTTPException(401, { message: 'Missing Authorization header' })
  }

  const token = authHeader.slice(7)

  const { data: { user }, error } = await anonClient.auth.getUser(token)
  if (error || !user) {
    throw new HTTPException(401, { message: 'Invalid or expired token' })
  }

  c.set('userId', user.id)
  c.set('userEmail', user.email ?? '')
  await next()
})
