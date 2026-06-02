import 'package:collection/collection.dart';

import '../models/ingredient.dart';
import '../models/recipe.dart';

const List<Ingredient> catalogIngredients = [
  Ingredient(
    id: 'rice',
    name: 'Rice',
    category: 'grain',
    unit: 'cup',
    color: '#FFF2CB',
    accent: '#B57B25',
  ),
  Ingredient(
    id: 'egg',
    name: 'Egg',
    category: 'protein',
    unit: 'pc',
    color: '#FFF8E7',
    accent: '#D99A16',
  ),
  Ingredient(
    id: 'chicken',
    name: 'Chicken',
    category: 'protein',
    unit: 'portion',
    color: '#FFE1C7',
    accent: '#B66A2B',
  ),
  Ingredient(
    id: 'soy-sauce',
    name: 'Soy Sauce',
    category: 'pantry',
    unit: 'tbsp',
    color: '#F4D1AA',
    accent: '#6D2A0C',
  ),
  Ingredient(
    id: 'beef',
    name: 'Beef',
    category: 'protein',
    unit: 'portion',
    color: '#FFD7C8',
    accent: '#8F2F1E',
  ),
  Ingredient(
    id: 'butter',
    name: 'Butter',
    category: 'pantry',
    unit: 'tbsp',
    color: '#FFF0A8',
    accent: '#C2961A',
  ),
  Ingredient(
    id: 'tomato',
    name: 'Tomato',
    category: 'produce',
    unit: 'pc',
    color: '#FFD0C4',
    accent: '#AB2A02',
  ),
  Ingredient(
    id: 'paprika',
    name: 'Paprika',
    category: 'produce',
    unit: 'pc',
    color: '#FFE0BA',
    accent: '#CB5C1A',
  ),
  Ingredient(
    id: 'salt',
    name: 'Salt',
    category: 'pantry',
    unit: 'pinch',
    color: '#F6F0DF',
    accent: '#8D8066',
  ),
  Ingredient(
    id: 'pepper',
    name: 'Pepper',
    category: 'pantry',
    unit: 'pinch',
    color: '#E3D3BC',
    accent: '#4B3927',
  ),
  Ingredient(
    id: 'spam',
    name: 'Spam',
    category: 'protein',
    unit: 'slice',
    color: '#FFD5D0',
    accent: '#A44434',
  ),
  Ingredient(
    id: 'bread',
    name: 'Bread',
    category: 'grain',
    unit: 'slice',
    color: '#FFE7B5',
    accent: '#A96D22',
  ),
];

const List<Recipe> catalogRecipes = [
  Recipe(
    id: 'nasi-goreng',
    title: 'Nasi Goreng Rescue',
    subtitle: 'Best match for leftover rice and eggs',
    timeMinutes: 20,
    servings: 2,
    difficulty: 'Easy',
    heroColor: '#AB2A02',
    accentColor: '#F6D695',
    ingredientIds: ['rice', 'egg', 'soy-sauce', 'tomato'],
    wasteNote:
        'Uses day-old rice before it dries out and turns pantry scraps into a full meal.',
    steps: [
      'Loosen cold rice with a fork so every grain can toast evenly.',
      'Scramble eggs in the pan, then move them aside before adding rice.',
      'Fold in soy sauce and tomato at the end to keep the flavor bright.',
    ],
  ),
  Recipe(
    id: 'butter-toast-egg',
    title: 'Savory Egg Toast',
    subtitle: 'A fast breakfast from bread, butter, and egg',
    timeMinutes: 12,
    servings: 1,
    difficulty: 'Easy',
    heroColor: '#2D5016',
    accentColor: '#FFE7B5',
    ingredientIds: ['bread', 'butter', 'egg', 'pepper'],
    wasteNote:
        'Turns the last slices of bread into a complete meal instead of a stale snack.',
    steps: [
      'Toast bread in butter until both sides are crisp.',
      'Cook the egg in the same pan so the butter flavor carries through.',
      'Finish with pepper and a pinch of salt.',
    ],
  ),
  Recipe(
    id: 'paprika-chicken-bowl',
    title: 'Paprika Chicken Bowl',
    subtitle: 'Colorful bowl with protein and grains',
    timeMinutes: 28,
    servings: 2,
    difficulty: 'Medium',
    heroColor: '#D85D1D',
    accentColor: '#FFE0BA',
    ingredientIds: ['rice', 'chicken', 'paprika', 'soy-sauce'],
    wasteNote: 'Good for using half vegetables and one leftover protein portion.',
    steps: [
      'Slice chicken and paprika into small strips for fast cooking.',
      'Sear chicken first, then add paprika until just soft.',
      'Serve over rice with soy sauce glaze.',
    ],
  ),
  Recipe(
    id: 'tomato-beef-rice',
    title: 'Tomato Beef Rice',
    subtitle: 'Comfort bowl for small leftover portions',
    timeMinutes: 30,
    servings: 2,
    difficulty: 'Medium',
    heroColor: '#7D2C18',
    accentColor: '#FFD0C4',
    ingredientIds: ['rice', 'beef', 'tomato', 'salt'],
    wasteNote:
        'Stretches a small amount of beef with rice and tomato so nothing sits forgotten.',
    steps: [
      'Season beef lightly and sear until browned.',
      'Add chopped tomato and salt, simmering until saucy.',
      'Spoon over warm rice.',
    ],
  ),
];

Ingredient? getIngredient(String id) =>
    catalogIngredients.firstWhereOrNull((i) => i.id == id);

Recipe? getRecipe(String id) =>
    catalogRecipes.firstWhereOrNull((r) => r.id == id);
