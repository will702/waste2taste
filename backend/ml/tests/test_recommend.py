import pytest
from unittest.mock import patch
import pandas as pd
from services.dataset import recommend_recipes, _match_to_catalog


def test_match_to_catalog_exact():
    result = _match_to_catalog("rice")
    assert result == "rice"


def test_match_to_catalog_fuzzy():
    result = _match_to_catalog("chicken meat")
    assert result == "chicken"


def test_match_to_catalog_no_match():
    result = _match_to_catalog("xylophone")
    assert result is None


def test_recommend_recipes_scores_correctly():
    mock_df = pd.DataFrame([
        {
            "Title": "Nasi Goreng",
            "Ingredients": "rice, egg, soy sauce, tomato",
            "Steps": "Cook rice. Add egg.",
        },
        {
            "Title": "Beef Stew",
            "Ingredients": "beef, tomato, salt, pepper",
            "Steps": "Brown beef.",
        },
    ])

    import services.dataset as ds
    ds._df = ds._preprocess(mock_df)
    results = recommend_recipes(["rice", "egg", "soy-sauce", "tomato"])
    ds._df = None  # cleanup

    assert len(results) >= 1
    nasi = next((r for r in results if "nasi" in r["title"].lower()), None)
    assert nasi is not None
    assert nasi["match_pct"] == 100
