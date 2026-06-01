from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from services.vision import detect_ingredients_from_image

router = APIRouter()


class DetectRequest(BaseModel):
    image_b64: str


@router.post("/detect")
def detect(req: DetectRequest):
    try:
        ingredients = detect_ingredients_from_image(req.image_b64)
        return {"detected_ingredients": ingredients}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Detection failed: {str(e)}")
