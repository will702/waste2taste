import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'

export const recipes = new Hono()
recipes.use('*', authMiddleware)

const MOCK_RECIPES = [
  {
    id: "nasi-goreng",
    title: "Nasi Goreng Rescue",
    subtitle: "Best match for leftover rice and eggs",
    time: "20 min",
    servings: "2 servings",
    difficulty: "Easy",
    heroColor: "#AB2A02",
    accentColor: "#F6D695",
    ingredients: ["rice", "egg", "soy-sauce", "tomato"],
    missing: ["tomato"],
    wasteNote: "Uses day-old rice before it dries out and turns pantry scraps into a full meal.",
    steps: [
      "Loosen cold rice with a fork so every grain can toast evenly.",
      "Scramble eggs in the pan, then move them aside before adding rice.",
      "Fold in soy sauce and tomato at the end to keep the flavor bright."
    ]
  }
];

recipes.get('/', async (c) => {
  return c.json(MOCK_RECIPES)
})

recipes.get('/recommend', async (c) => {
  const mlUrl = process.env.ML_SERVICE_URL!
  try {
    const response = await fetch(`${mlUrl}/recommend`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ pantry: ["rice", "egg", "soy-sauce"] }),
    })
    if (!response.ok) return c.json(MOCK_RECIPES)
    return c.json(await response.json())
  } catch (e) {
    return c.json(MOCK_RECIPES)
  }
})

recipes.get('/:id', async (c) => {
  const id = c.req.param('id')
  const recipe = MOCK_RECIPES.find(r => r.id === id)
  if (!recipe) return c.json({ error: 'recipe not found' }, 404)
  return c.json(recipe)
})
