import { describe, it, expect, vi } from 'vitest'

const mockDetectResponse = { detected_ingredients: ['rice', 'egg'] }
const mockRecommendResponse = { recipes: [{ id: 'nasi-goreng', title: 'Nasi Goreng', match_pct: 100, missing: [] }] }

vi.stubGlobal('fetch', vi.fn().mockImplementation((url: string) => {
  if (url.includes('/detect')) {
    return Promise.resolve({ ok: true, json: () => Promise.resolve(mockDetectResponse) })
  }
  return Promise.resolve({ ok: true, json: () => Promise.resolve(mockRecommendResponse) })
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

import { ml } from '../src/routes/ml.js'

describe('POST /ml/detect', () => {
  it('returns detected ingredients', async () => {
    const res = await ml.request('/detect', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ image_b64: 'base64encodedimage' }),
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any
    expect(json.detected_ingredients).toContain('rice')
  })

  it('returns 400 when image_b64 missing', async () => {
    const res = await ml.request('/detect', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({}),
    })
    expect(res.status).toBe(400)
  })
})

describe('POST /ml/recommend', () => {
  it('returns recipe recommendations', async () => {
    const res = await ml.request('/recommend', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ pantry: ['rice', 'egg'] }),
    })
    expect(res.status).toBe(200)
    const json = await res.json() as any
    expect(json.recipes[0].id).toBe('nasi-goreng')
  })

  it('returns 400 when pantry is not array', async () => {
    const res = await ml.request('/recommend', {
      method: 'POST',
      headers: { Authorization: 'Bearer valid-token', 'Content-Type': 'application/json' },
      body: JSON.stringify({ pantry: 'rice' }),
    })
    expect(res.status).toBe(400)
  })
})
