import { describe, it, expect, vi } from 'vitest'

const mockMeal = {
  id: 'meal-1',
  user_id: 'user-123',
  recipe_id: 'nasi-goreng',
  cooked_at: new Date().toISOString(),
  saved: false,
  notes: null,
  recipes: { id: 'nasi-goreng', title: 'Nasi Goreng Rescue', hero_color: '#AB2A02' },
}

vi.mock('../src/lib/supabase.js', () => ({
  supabase: {
    from: vi.fn(() => ({
      select: vi.fn().mockReturnThis(),
      eq: vi.fn().mockReturnThis(),
      order: vi.fn().mockResolvedValue({ data: [mockMeal], error: null }),
      insert: vi.fn().mockReturnThis(),
      single: vi.fn().mockResolvedValue({ data: mockMeal, error: null }),
    })),
  },
}))

vi.mock('@supabase/supabase-js', () => ({
  createClient: vi.fn(() => ({
    auth: {
      getUser: vi.fn().mockResolvedValue({
        data: { user: { id: 'user-123', email: 'test@example.com' } },
        error: null,
      }),
    },
  })),
}))

import { history } from '../src/routes/history.js'

describe('GET /history', () => {
  it('returns user cooking history', async () => {
    const res = await history.request('/', {
      headers: { Authorization: 'Bearer valid-token' },
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any[]
    expect(json[0].recipe_id).toBe('nasi-goreng')
  })
})

describe('POST /history', () => {
  it('logs a cooked meal', async () => {
    const res = await history.request('/', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ recipe_id: 'nasi-goreng' }),
    })
    expect(res.status).toBe(201)
  })

  it('returns 400 when recipe_id missing', async () => {
    const res = await history.request('/', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ saved: true }),
    })
    expect(res.status).toBe(400)
  })
})
