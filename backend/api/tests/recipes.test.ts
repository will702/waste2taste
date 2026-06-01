import { describe, it, expect, vi } from 'vitest'

const mockRecipe = {
  id: 'nasi-goreng',
  title: 'Nasi Goreng Rescue',
  difficulty: 'easy',
  recipe_ingredients: [{ ingredient_id: 'rice', required: true, ingredients: { name: 'Rice' } }],
}

const mockPantryItems = [{ ingredient_id: 'rice' }, { ingredient_id: 'egg' }]
const mockRecommendations = { recipes: [{ id: 'nasi-goreng', title: 'Nasi Goreng Rescue', match_pct: 100, missing: [] }] }

vi.mock('../src/lib/supabase.js', () => ({
  supabase: {
    from: vi.fn((table: string) => {
      if (table === 'pantry_items') {
        return {
          select: vi.fn().mockReturnThis(),
          eq: vi.fn().mockResolvedValue({ data: mockPantryItems, error: null }),
        }
      }
      return {
        select: vi.fn().mockReturnThis(),
        eq: vi.fn().mockReturnThis(),
        single: vi.fn().mockResolvedValue({ data: mockRecipe, error: null }),
        // for list: make the select itself resolve
        then: (resolve: any) => resolve({ data: [mockRecipe], error: null }),
      }
    }),
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

vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
  ok: true,
  json: () => Promise.resolve(mockRecommendations),
}))

import { recipes } from '../src/routes/recipes.js'

describe('GET /recipes', () => {
  it('returns recipe list', async () => {
    const res = await recipes.request('/', {
      headers: { Authorization: 'Bearer valid-token' },
    })
    expect(res.status).toBe(200)
  })
})

describe('GET /recipes/:id', () => {
  it('returns a single recipe', async () => {
    const res = await recipes.request('/nasi-goreng', {
      headers: { Authorization: 'Bearer valid-token' },
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any
    expect(json.id).toBe('nasi-goreng')
  })
})

describe('GET /recipes/recommend', () => {
  it('returns ML recommendations', async () => {
    const res = await recipes.request('/recommend', {
      headers: { Authorization: 'Bearer valid-token' },
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any
    expect(json.recipes[0].id).toBe('nasi-goreng')
  })
})
