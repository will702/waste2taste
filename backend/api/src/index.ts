import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { logger } from 'hono/logger'
import { HTTPException } from 'hono/http-exception'
import { auth } from './routes/auth.js'
import { ingredients } from './routes/ingredients.js'
import { pantry } from './routes/pantry.js'
import { recipes } from './routes/recipes.js'
import { history } from './routes/history.js'
import { ml } from './routes/ml.js'

const app = new Hono()

app.use('*', logger())
app.use('*', cors())

app.get('/health', (c) => c.json({ status: 'ok' }))

app.route('/auth', auth)
app.route('/ingredients', ingredients)
app.route('/pantry', pantry)
app.route('/recipes', recipes)
app.route('/history', history)
app.route('/ml', ml)

app.onError((err, c) => {
  console.error(err)
  if (err instanceof HTTPException) {
    return c.json({ error: err.message }, err.status)
  }
  const message = err instanceof Error ? err.message : String(err)
  return c.json({ error: message }, 500)
})

const port = Number(process.env.PORT ?? 8080)
console.log(`API running on port ${port}`)

export default { port, fetch: app.fetch }
