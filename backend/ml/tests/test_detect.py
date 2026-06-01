import pytest
from unittest.mock import MagicMock, patch
from services.vision import detect_ingredients_from_image, _match_label_to_catalog


def test_match_label_exact():
    result = _match_label_to_catalog("rice")
    assert result == "rice"


def test_match_label_alias():
    result = _match_label_to_catalog("poultry")
    assert result == "chicken"


def test_match_label_no_match():
    result = _match_label_to_catalog("skateboard")
    assert result is None


def test_detect_from_image():
    mock_client = MagicMock()
    mock_response = MagicMock()
    mock_label_1 = MagicMock()
    mock_label_1.description = "Rice"
    mock_label_1.score = 0.97
    mock_label_2 = MagicMock()
    mock_label_2.description = "Egg"
    mock_label_2.score = 0.92
    mock_label_3 = MagicMock()
    mock_label_3.description = "Sky"
    mock_label_3.score = 0.88
    mock_response.label_annotations = [mock_label_1, mock_label_2, mock_label_3]
    mock_client.label_detection.return_value = mock_response

    import base64
    fake_image = base64.b64encode(b"fake-image-bytes").decode()

    with patch("services.vision.vision.ImageAnnotatorClient", return_value=mock_client):
        result = detect_ingredients_from_image(fake_image)

    assert "rice" in result
    assert "egg" in result
    assert len([r for r in result if r == "sky"]) == 0  # sky is not in catalog
