from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from services.dataset import recommend_recipes

router = APIRouter()


class RecommendRequest(BaseModel):
    pantry: list[str]


@router.post("/recommend")
def recommend(req: RecommendRequest):
    try:
        results = recommend_recipes(req.pantry)
        return {"recipes": results}
    except RuntimeError as e:
        raise HTTPException(status_code=503, detail=str(e))
