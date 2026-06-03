# Waste2Taste

Minimize food waste through smart pantry management and AI-powered recipe generation.

Waste2Taste is a full-stack application that helps users track their ingredients and discover recipes based on what they already have. It features a Flutter mobile app, a Node.js API gateway, and a Python-based ML microservice for recipe ranking.

---

## 🏗 System Architecture

```mermaid
graph TD
    App[Mobile App - Flutter] --> API[API Gateway - Node.js/Hono]
    API --> DB[(Supabase Postgres)]
    API --> Auth[Supabase Auth]
    API --> ML[ML Service - Python/FastAPI]
    App --> MLKit[On-device ML Kit scan]
    ML --> HF[HuggingFace Recipes Dataset]
```

- **Frontend:** Flutter mobile app in `waste2taste_flutter/` with Riverpod, GoRouter, and on-device ML Kit scanning.
- **API Gateway (`backend/api`):** Node.js service using Hono. Handles auth, CRUD, and proxies ML requests.
- **ML Service (`backend/ml`):** Python microservice using FastAPI. Recommends recipes from the `junwatu/indonesian-recipes` dataset and is called only through the API gateway.

---

## 🚀 Prerequisites

Ensure you have the following installed:
- **Node.js** (v20 or later)
- **Python** (v3.11 or later)
- **Docker** & **Docker Compose**
- **Flutter SDK** (v3.10 or later)

---

## 🛠 Setup & Installation

### 1. Backend Setup

The easiest way to run the backend services (API + ML) is using Docker Compose.

1.  **Configure Environment Variables:**
    - Create `backend/api/.env` based on `backend/api/.env.example`.
    - Create `backend/ml/.env` based on `backend/ml/.env.example`.
    - Ensure you have your **Supabase** credentials and a **Google Cloud** service account JSON key.

2.  **Start Services:**
    ```bash
    cd backend
    docker compose up --build
    ```
    The API will be available at `http://localhost:8080`.

#### (Alternative) Manual Backend Setup

If you prefer to run services manually for debugging:

**API Gateway:**
```bash
cd backend/api
npm install
npm run dev
```

**ML Service:**
```bash
cd backend/ml
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --port 8001
```

### 2. Flutter Setup

1.  **Install dependencies:**
    ```bash
    cd waste2taste_flutter
    flutter pub get
    ```

2.  **Configure API URL:**
    Pass the API gateway URL with `--dart-define=API_URL=...`.
    Use `http://10.0.2.2:8080` for Android emulator local dev and `http://127.0.0.1:8080` for iOS simulator local dev.

3.  **Start the app:**
    ```bash
    flutter run -d android --dart-define=API_URL=http://10.0.2.2:8080
    ```

---

## 🧪 Testing

### Backend API
```bash
cd backend/api
npm test
```

### ML Service
```bash
cd backend/ml
source venv/bin/activate
pytest
```

---

## 📂 Project Structure

- `waste2taste_flutter/`: Active Flutter app.
- `app/`, `components/`, `context/`, `data/`, `types/`: Legacy Expo/React Native reference code.
- `backend/api/`: Node.js API Gateway (Hono).
- `backend/ml/`: Python ML Microservice (FastAPI).
- `backend/supabase/migrations/`: SQL database schema.
- `docs/superpowers/`: Detailed architecture specs and implementation plans.
