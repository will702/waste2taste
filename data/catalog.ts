import type { CookedMeal, Ingredient, Recipe } from "@/types/app";

export const ingredients: Ingredient[] = [
  { id: "rice", name: "Rice", category: "grain", unit: "cup", color: "#FFF2CB", accent: "#B57B25" },
  { id: "egg", name: "Egg", category: "protein", unit: "pc", color: "#FFF8E7", accent: "#D99A16" },
  { id: "chicken", name: "Chicken", category: "protein", unit: "portion", color: "#FFE1C7", accent: "#B66A2B" },
  { id: "soy-sauce", name: "Soy Sauce", category: "pantry", unit: "tbsp", color: "#F4D1AA", accent: "#6D2A0C" },
  { id: "beef", name: "Beef", category: "protein", unit: "portion", color: "#FFD7C8", accent: "#8F2F1E" },
  { id: "butter", name: "Butter", category: "pantry", unit: "tbsp", color: "#FFF0A8", accent: "#C2961A" },
  { id: "tomato", name: "Tomato", category: "produce", unit: "pc", color: "#FFD0C4", accent: "#AB2A02" },
  { id: "paprika", name: "Paprika", category: "produce", unit: "pc", color: "#FFE0BA", accent: "#CB5C1A" },
  { id: "salt", name: "Salt", category: "pantry", unit: "pinch", color: "#F6F0DF", accent: "#8D8066" },
  { id: "pepper", name: "Pepper", category: "pantry", unit: "pinch", color: "#E3D3BC", accent: "#4B3927" },
  { id: "spam", name: "Spam", category: "protein", unit: "slice", color: "#FFD5D0", accent: "#A44434" },
  { id: "bread", name: "Bread", category: "grain", unit: "slice", color: "#FFE7B5", accent: "#A96D22" }
];

export const initialPantry = [
  { ingredientId: "rice", quantity: 1 },
  { ingredientId: "egg", quantity: 2 },
  { ingredientId: "soy-sauce", quantity: 1 }
];

export const recipes: Recipe[] = [
  {
    id: "nasi-goreng",
    title: "Nasi Goreng Rescue",
    subtitle: "Best match for leftover rice and eggs",
    time: "20 min",
    servings: "2 servings",
    difficulty: "Easy",
    heroColor: "#AB2A02",
    accentColor: "#F6D695",
    ingredients: ["rice", "egg", "soy-sauce", "tomato"],
    missing: ["tomato"],
    wasteNote: "Uses day-old rice before it dries out and turns pantry scraps into a full meal.",
    steps: [
      "Loosen cold rice with a fork so every grain can toast evenly.",
      "Scramble eggs in the pan, then move them aside before adding rice.",
      "Fold in soy sauce and tomato at the end to keep the flavor bright."
    ]
  },
  {
    id: "butter-toast-egg",
    title: "Savory Egg Toast",
    subtitle: "A fast breakfast from bread, butter, and egg",
    time: "12 min",
    servings: "1 serving",
    difficulty: "Easy",
    heroColor: "#2D5016",
    accentColor: "#FFE7B5",
    ingredients: ["bread", "butter", "egg", "pepper"],
    missing: ["bread", "butter", "pepper"],
    wasteNote: "Turns the last slices of bread into a complete meal instead of a stale snack.",
    steps: [
      "Toast bread in butter until both sides are crisp.",
      "Cook the egg in the same pan so the butter flavor carries through.",
      "Finish with pepper and a pinch of salt."
    ]
  },
  {
    id: "paprika-chicken-bowl",
    title: "Paprika Chicken Bowl",
    subtitle: "Colorful bowl with protein and grains",
    time: "28 min",
    servings: "2 servings",
    difficulty: "Medium",
    heroColor: "#D85D1D",
    accentColor: "#FFE0BA",
    ingredients: ["rice", "chicken", "paprika", "soy-sauce"],
    missing: ["chicken", "paprika"],
    wasteNote: "Good for using half vegetables and one leftover protein portion.",
    steps: [
      "Slice chicken and paprika into small strips for fast cooking.",
      "Sear chicken first, then add paprika until just soft.",
      "Serve over rice with soy sauce glaze."
    ]
  },
  {
    id: "tomato-beef-rice",
    title: "Tomato Beef Rice",
    subtitle: "Comfort bowl for small leftover portions",
    time: "30 min",
    servings: "2 servings",
    difficulty: "Medium",
    heroColor: "#7D2C18",
    accentColor: "#FFD0C4",
    ingredients: ["rice", "beef", "tomato", "salt"],
    missing: ["beef", "tomato", "salt"],
    wasteNote: "Stretches a small amount of beef with rice and tomato so nothing sits forgotten.",
    steps: [
      "Season beef lightly and sear until browned.",
      "Add chopped tomato and salt, simmering until saucy.",
      "Spoon over warm rice."
    ]
  }
];

export const history: CookedMeal[] = [
  { id: "h1", recipeId: "nasi-goreng", cookedAt: "Today", saved: "Rice saved" },
  { id: "h2", recipeId: "butter-toast-egg", cookedAt: "Yesterday", saved: "Bread saved" },
  { id: "h3", recipeId: "paprika-chicken-bowl", cookedAt: "May 16", saved: "Paprika saved" }
];

export function getIngredient(id: string) {
  return ingredients.find((ingredient) => ingredient.id === id);
}

export function getRecipe(id: string) {
  return recipes.find((recipe) => recipe.id === id);
}
