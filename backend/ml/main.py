from contextlib import asynccontextmanager
from fastapi import FastAPI
from routers import detect, recommend
from services.dataset import load_dataset_on_startup


@asynccontextmanager
async def lifespan(app: FastAPI):
    print("Loading Indonesian recipes dataset...")
    load_dataset_on_startup()
    print("Dataset ready.")
    yield


app = FastAPI(title="Waste2Taste ML Service", lifespan=lifespan)

app.include_router(detect.router)
app.include_router(recommend.router)


@app.get("/health")
def health():
    return {"status": "ok"}
