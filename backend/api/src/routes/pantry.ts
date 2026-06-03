import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'

export const pantry = new Hono()
pantry.use('*', authMiddleware)

const MOCK_PANTRY = [
  { user_id: 'mock-user-123', ingredient_id: "rice", quantity: 1, ingredients: { id: "rice", name: "Rice", category: "grain" } },
  { user_id: 'mock-user-123', ingredient_id: "egg", quantity: 2, ingredients: { id: "egg", name: "Egg", category: "protein" } },
  { user_id: 'mock-user-123', ingredient_id: "soy-sauce", quantity: 1, ingredients: { id: "soy-sauce", name: "Soy Sauce", category: "pantry" } }
];

pantry.get('/', async (c) => {
  return c.json(MOCK_PANTRY)
})

pantry.post('/', async (c) => {
  const { ingredient_id, quantity = 1 } = await c.req.json<{ ingredient_id: string; quantity?: number }>()
  return c.json({ user_id: 'mock-user-123', ingredient_id, quantity }, 201)
})

pantry.patch('/:ingredientId', async (c) => {
  const ingredientId = c.req.param('ingredientId')
  const { quantity } = await c.req.json<{ quantity: number }>()
  return c.json({ user_id: 'mock-user-123', ingredient_id: ingredientId, quantity })
})

pantry.delete('/:ingredientId', async (c) => {
  return new Response(null, { status: 204 })
})
