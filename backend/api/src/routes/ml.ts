import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'
import type { AppEnv } from '../types.js'

export const ml = new Hono<AppEnv>()
ml.use('*', authMiddleware)

const mlFetch = (path: string, body: unknown) =>
  fetch(`${process.env.ML_SERVICE_URL!}${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })

ml.post('/detect', async (c) => {
  const { image_b64 } = await c.req.json<{ image_b64: string }>()
  if (!image_b64) return c.json({ error: 'image_b64 required' }, 400)

  const res = await mlFetch('/detect', { image_b64 })
  if (!res.ok) return c.json({ error: 'Detection service error' }, 502)
  return c.json(await res.json())
})

ml.post('/recommend', async (c) => {
  const { pantry } = await c.req.json<{ pantry: string[] }>()
  if (!Array.isArray(pantry)) return c.json({ error: 'pantry must be an array' }, 400)

  const res = await mlFetch('/recommend', { pantry })
  if (!res.ok) return c.json({ error: 'Recommendation service error' }, 502)
  return c.json(await res.json())
})
