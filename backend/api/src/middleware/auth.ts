import { createMiddleware } from 'hono/factory'
import { createClient } from '@supabase/supabase-js'
import { HTTPException } from 'hono/http-exception'
import type { AppEnv } from '../types.js'

const supabaseUrl = process.env.SUPABASE_URL
const anonKey = process.env.SUPABASE_ANON_KEY

const anonClient = (supabaseUrl && anonKey) 
  ? createClient(supabaseUrl, anonKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    })
  : null

export const authMiddleware = createMiddleware<AppEnv>(async (c, next) => {
  if (!anonClient) {
    throw new HTTPException(500, { message: 'Supabase auth is not configured' })
  }

  const authHeader = c.req.header('Authorization')
  const match = authHeader?.match(/^Bearer\s+(.+)$/i)
  const token = match?.[1]
  if (!token) {
    throw new HTTPException(401, { message: 'Missing bearer token' })
  }

  const { data, error } = await anonClient.auth.getUser(token)
  if (error || !data.user) {
    throw new HTTPException(401, { message: 'Invalid bearer token' })
  }

  c.set('userId', data.user.id)
  c.set('userEmail', data.user.email ?? '')
  await next()
})
