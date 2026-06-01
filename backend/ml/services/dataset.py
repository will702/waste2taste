import re
from typing import Optional
import pandas as pd
from datasets import load_dataset
from rapidfuzz import fuzz

_df: Optional[pd.DataFrame] = None

INGREDIENT_CATALOG = [
    "rice", "egg", "chicken", "soy-sauce", "beef", "butter",
    "tomato", "paprika", "salt", "pepper", "spam", "bread",
    "garlic", "onion", "oil", "ginger", "sugar",
]

# Multi-word catalog IDs need display form for matching
_CATALOG_DISPLAY = {
    "soy-sauce": "soy sauce",
}


def load_dataset_on_startup() -> None:
    global _df
    dataset = load_dataset("junwatu/indonesian-recipes", split="train")
    _df = _preprocess(dataset.to_pandas())


def _preprocess(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df["parsed_ingredients"] = df["Ingredients"].apply(_parse_ingredients)
    return df


def _parse_ingredients(raw: str) -> list[str]:
    if not raw or not isinstance(raw, str):
        return []
    items = re.split(r"[,;\n•·]", raw)
    return [re.sub(r"[^\w\s]", "", item).strip().lower() for item in items if item.strip()]


def _match_to_catalog(ingredient_text: str) -> Optional[str]:
    """Fuzzy-match an ingredient string to the catalog. Returns catalog id or None."""
    best_score = 0
    best_id = None
    for catalog_id in INGREDIENT_CATALOG:
        display = _CATALOG_DISPLAY.get(catalog_id, catalog_id.replace("-", " "))
        score = fuzz.token_sort_ratio(ingredient_text.lower(), display)
        if score > best_score:
            best_score = score
            best_id = catalog_id
    return best_id if best_score >= 70 else None


def recommend_recipes(pantry: list[str], top_n: int = 10) -> list[dict]:
    if _df is None:
        raise RuntimeError("Dataset not loaded. Call load_dataset_on_startup() first.")

    pantry_set = set(pantry)
    results = []

    for _, row in _df.iterrows():
        raw_ingredients: list[str] = row.get("parsed_ingredients", [])
        recipe_catalog_ids: set[str] = set()

        for ing in raw_ingredients:
            matched = _match_to_catalog(ing)
            if matched:
                recipe_catalog_ids.add(matched)

        if not recipe_catalog_ids:
            continue

        overlap = pantry_set & recipe_catalog_ids
        score = len(overlap) / len(recipe_catalog_ids)

        if score >= 0.5:
            results.append({
                "id": str(row.get("Title", "unknown")).lower().replace(" ", "-"),
                "title": row.get("Title", "Unknown"),
                "match_pct": round(score * 100),
                "missing": sorted(recipe_catalog_ids - pantry_set),
                "catalog_ingredients": sorted(recipe_catalog_ids),
                "instructions": str(row.get("Steps", ""))[:500],
            })

    results.sort(key=lambda x: x["match_pct"], reverse=True)
    return results[:top_n]
