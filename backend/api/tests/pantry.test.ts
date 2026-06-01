import { describe, it, expect, vi } from 'vitest'

const mockPantryItem = {
  id: 'item-1',
  user_id: 'user-123',
  ingredient_id: 'rice',
  quantity: 2,
  updated_at: new Date().toISOString(),
  ingredients: { id: 'rice', name: 'Rice', category: 'grain', unit: 'cup', color: '#FFF2CB', accent: '#B57B25' },
}

vi.mock('../src/lib/supabase.js', () => ({
  supabase: {
    from: vi.fn(() => ({
      select: vi.fn().mockReturnThis(),
      eq: vi.fn().mockReturnThis(),
      order: vi.fn().mockResolvedValue({ data: [mockPantryItem], error: null }),
      upsert: vi.fn().mockReturnThis(),
      update: vi.fn().mockReturnThis(),
      delete: vi.fn().mockReturnThis(),
      single: vi.fn().mockResolvedValue({ data: mockPantryItem, error: null }),
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

import { pantry } from '../src/routes/pantry.js'

describe('GET /pantry', () => {
  it('returns user pantry items', async () => {
    const res = await pantry.request('/', {
      headers: { Authorization: 'Bearer valid-token' },
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any[]
    expect(json[0].ingredient_id).toBe('rice')
  })
})

describe('POST /pantry', () => {
  it('adds ingredient to pantry', async () => {
    const res = await pantry.request('/', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ ingredient_id: 'rice', quantity: 2 }),
    })
    expect(res.status).toBe(201)
  })

  it('returns 400 when ingredient_id missing', async () => {
    const res = await pantry.request('/', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ quantity: 2 }),
    })
    expect(res.status).toBe(400)
  })
})

describe('DELETE /pantry/:ingredientId', () => {
  it('returns 204', async () => {
    const res = await pantry.request('/rice', {
      method: 'DELETE',
      headers: { Authorization: 'Bearer valid-token' },
    })
    expect(res.status).toBe(204)
  })
})
