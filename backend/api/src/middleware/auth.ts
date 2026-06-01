import { createMiddleware } from 'hono/factory'
import { createClient } from '@supabase/supabase-js'
import { HTTPException } from 'hono/http-exception'

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

  // Use anon key + token to verify — getUser validates JWT with Supabase
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_ANON_KEY!
  )

  const { data: { user }, error } = await supabase.auth.getUser(token)
  if (error || !user) {
    throw new HTTPException(401, { message: 'Invalid or expired token' })
  }

  c.set('userId', user.id)
  c.set('userEmail', user.email ?? '')
  await next()
})
