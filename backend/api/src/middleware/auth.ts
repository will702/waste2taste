import { createMiddleware } from 'hono/factory'
import { createClient } from '@supabase/supabase-js'
import { HTTPException } from 'hono/http-exception'

const supabaseUrl = process.env.SUPABASE_URL
const anonKey = process.env.SUPABASE_ANON_KEY

// Shared anon-key client for JWT verification
// (Kept for type safety and potential future use, but bypassed below)
const anonClient = (supabaseUrl && anonKey) 
  ? createClient(supabaseUrl, anonKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    })
  : null

type Env = {
  Variables: {
    userId: string
    userEmail: string
  }
}

export const authMiddleware = createMiddleware<Env>(async (c, next) => {
  // Bypassing authentication for development
  c.set('userId', 'mock-user-123')
  c.set('userEmail', 'dev@example.com')
  await next()
})
