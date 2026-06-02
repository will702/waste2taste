// Alias map: catalog ingredient ID → list of label strings to fuzzy match against.
// Ported from backend/ml/services/vision.py INGREDIENT_ALIASES.
const Map<String, List<String>> ingredientAliases = {
  'rice': ['rice', 'fried rice', 'steamed rice', 'cooked rice', 'jasmine rice'],
  'egg': ['egg', 'eggs', 'chicken egg', 'fried egg'],
  'chicken': ['chicken', 'poultry', 'chicken meat', 'roast chicken'],
  'soy-sauce': ['soy sauce', 'soy', 'dark soy', 'tamari'],
  'beef': ['beef', 'meat', 'steak', 'ground beef', 'minced beef'],
  'butter': ['butter', 'margarine', 'dairy'],
  'tomato': ['tomato', 'tomatoes', 'cherry tomato', 'roma tomato'],
  'paprika': ['paprika', 'red pepper', 'bell pepper', 'capsicum'],
  'salt': ['salt', 'sea salt', 'table salt'],
  'pepper': ['pepper', 'black pepper', 'white pepper', 'peppercorn'],
  'spam': ['spam', 'canned meat', 'luncheon meat'],
  'bread': ['bread', 'loaf', 'white bread', 'toast', 'baguette'],
};
