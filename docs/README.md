# Waste2Taste Documentation

Human-maintained documentation for the Waste2Taste project.

## Getting started

| Document | Description |
|----------|-------------|
| [Contributing](contributing.md) | Local setup, tests, and catalog sync |
| [Architecture](architecture.md) | System design, data flows, and security boundaries |
| [Flutter frontend](frontend/flutter.md) | Mobile app structure, providers, and ML Kit scan |

## Backend

| Document | Description |
|----------|-------------|
| [API & integrations](backend/api-integrations.md) | Routes, auth, ML proxy, environment variables |
| [Database](backend/database.md) | Schema, RLS policies, migrations, seeding |
| [Deployment](../backend/DEPLOY.md) | Cloud Run deployment guide |

## Diagrams

Source files live in [`diagrams-src/`](diagrams-src/). Exported SVGs are in [`assets/diagrams/`](assets/diagrams/).

To regenerate SVG exports:

```bash
for f in docs/diagrams-src/*.mmd; do
  npx -y @mermaid-js/mermaid-cli -i "$f" -o "docs/assets/diagrams/$(basename "${f%.mmd}").svg"
done
```

## Local AI assistant config

AI tooling files (`AGENTS.md`, `CLAUDE.md`, etc.) are gitignored. Copy [`templates/AGENTS.md.example`](templates/AGENTS.md.example) to the repo root as `AGENTS.md` if you use Cursor or similar tools locally.
