import { describe, it, expect, vi, beforeEach } from 'vitest'

// Mock Supabase before importing routes
vi.mock('@supabase/supabase-js', () => ({
  createClient: vi.fn(() => ({
    auth: {
      signUp: vi.fn().mockResolvedValue({
        data: {
          user: { id: 'user-123', email: 'test@example.com' },
          session: { access_token: 'token-abc', refresh_token: 'refresh-xyz' },
        },
        error: null,
      }),
      signInWithPassword: vi.fn().mockResolvedValue({
        data: {
          user: { id: 'user-123', email: 'test@example.com' },
          session: { access_token: 'token-abc', refresh_token: 'refresh-xyz' },
        },
        error: null,
      }),
      getUser: vi.fn().mockResolvedValue({
        data: { user: { id: 'user-123', email: 'test@example.com' } },
        error: null,
      }),
      signOut: vi.fn().mockResolvedValue({ error: null }),
    },
  })),
}))

import { auth } from '../src/routes/auth.js'

describe('POST /auth/register', () => {
  it('returns 201 with user and tokens', async () => {
    const res = await auth.request('/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'test@example.com', password: 'password123' }),
    })
    expect(res.status).toBe(201)
    const json = await res.json() as any
    expect(json.user.email).toBe('test@example.com')
    expect(json.access_token).toBe('token-abc')
  })

  it('returns 400 when body is missing fields', async () => {
    const res = await auth.request('/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'test@example.com' }),
    })
    expect(res.status).toBe(400)
  })
})

describe('POST /auth/login', () => {
  it('returns 200 with tokens', async () => {
    const res = await auth.request('/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'test@example.com', password: 'password123' }),
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any
    expect(json.access_token).toBe('token-abc')
  })
})

describe('GET /auth/me', () => {
  it('returns user info with valid token', async () => {
    const res = await auth.request('/me', {
      headers: { Authorization: 'Bearer token-abc' },
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any
    expect(json.id).toBe('user-123')
  })

  it('returns 401 without token', async () => {
    const res = await auth.request('/me')
    expect(res.status).toBe(401)
  })
})
