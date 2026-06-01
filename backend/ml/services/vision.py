import base64
from typing import Optional
from google.cloud import vision
from rapidfuzz import fuzz

INGREDIENT_ALIASES: dict[str, list[str]] = {
    "rice":      ["rice", "fried rice", "steamed rice", "cooked rice", "jasmine rice"],
    "egg":       ["egg", "eggs", "chicken egg", "fried egg"],
    "chicken":   ["chicken", "poultry", "chicken meat", "roast chicken"],
    "soy-sauce": ["soy sauce", "soy", "dark soy", "tamari"],
    "beef":      ["beef", "meat", "steak", "ground beef", "minced beef"],
    "butter":    ["butter", "margarine", "dairy"],
    "tomato":    ["tomato", "tomatoes", "cherry tomato", "roma tomato"],
    "paprika":   ["paprika", "red pepper", "bell pepper", "capsicum"],
    "salt":      ["salt", "sea salt", "table salt"],
    "pepper":    ["pepper", "black pepper", "white pepper", "peppercorn"],
    "spam":      ["spam", "canned meat", "luncheon meat"],
    "bread":     ["bread", "loaf", "white bread", "toast", "baguette"],
}


def _match_label_to_catalog(label: str) -> Optional[str]:
    label_lower = label.lower().strip()
    for ingredient_id, aliases in INGREDIENT_ALIASES.items():
        for alias in aliases:
            if fuzz.token_sort_ratio(label_lower, alias) >= 80:
                return ingredient_id
    return None


def detect_ingredients_from_image(image_b64: str) -> list[str]:
    client = vision.ImageAnnotatorClient()
    image = vision.Image(content=base64.b64decode(image_b64))
    response = client.label_detection(image=image, max_results=20)

    detected: list[str] = []
    for label in response.label_annotations:
        if label.score < 0.70:
            continue
        matched_id = _match_label_to_catalog(label.description)
        if matched_id and matched_id not in detected:
            detected.append(matched_id)

    return detected
