import { Hono } from 'hono'
import { createClient } from '@supabase/supabase-js'
import { authMiddleware } from '../middleware/auth.js'

export const auth = new Hono()

// Mock user for local development without Supabase
const MOCK_USER = {
  id: 'mock-user-123',
  email: 'dev@example.com'
}

const MOCK_SESSION = {
  access_token: 'mock-token-abc',
  refresh_token: 'mock-refresh-xyz'
}

auth.post('/register', async (c) => {
  console.log('Register request (mocked success)')
  return c.json({
    user: MOCK_USER,
    ...MOCK_SESSION
  }, 201)
})

auth.post('/login', async (c) => {
  console.log('Login request (mocked success)')
  return c.json({
    user: MOCK_USER,
    ...MOCK_SESSION
  })
})

auth.post('/logout', async (c) => {
  return c.json({ message: 'logged out (mocked)' })
})

auth.get('/me', authMiddleware, async (c) => {
  return c.json(MOCK_USER)
})
