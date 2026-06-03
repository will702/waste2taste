import { Hono } from 'hono'
import { authMiddleware } from '../middleware/auth.js'

export const ingredients = new Hono()
ingredients.use('*', authMiddleware)

const MOCK_INGREDIENTS = [
  { id: "rice", name: "Rice", category: "grain", unit: "cup", color: "#FFF2CB", accent: "#B57B25" },
  { id: "egg", name: "Egg", category: "protein", unit: "pc", color: "#FFF8E7", accent: "#D99A16" },
  { id: "chicken", name: "Chicken", category: "protein", unit: "portion", color: "#FFE1C7", accent: "#B66A2B" },
  { id: "soy-sauce", name: "Soy Sauce", category: "pantry", unit: "tbsp", color: "#F4D1AA", accent: "#6D2A0C" },
  { id: "beef", name: "Beef", category: "protein", unit: "portion", color: "#FFD7C8", accent: "#8F2F1E" },
  { id: "butter", name: "Butter", category: "pantry", unit: "tbsp", color: "#FFF0A8", accent: "#C2961A" },
  { id: "tomato", name: "Tomato", category: "produce", unit: "pc", color: "#FFD0C4", accent: "#AB2A02" },
  { id: "paprika", name: "Paprika", category: "produce", unit: "pc", color: "#FFE0BA", accent: "#CB5C1A" },
  { id: "salt", name: "Salt", category: "pantry", unit: "pinch", color: "#F6F0DF", accent: "#8D8066" },
  { id: "pepper", name: "Pepper", category: "pantry", unit: "pinch", color: "#E3D3BC", accent: "#4B3927" },
  { id: "spam", name: "Spam", category: "protein", unit: "slice", color: "#FFD5D0", accent: "#A44434" },
  { id: "bread", name: "Bread", category: "grain", unit: "slice", color: "#FFE7B5", accent: "#A96D22" }
];

ingredients.get('/', async (c) => {
  return c.json(MOCK_INGREDIENTS)
})
