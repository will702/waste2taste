export type IngredientCategory = "grain" | "protein" | "produce" | "pantry";

export type Ingredient = {
  id: string;
  name: string;
  category: IngredientCategory;
  unit: string;
  color: string;
  accent: string;
};

export type PantryItem = {
  ingredientId: string;
  quantity: number;
};

export type Recipe = {
  id: string;
  title: string;
  subtitle: string;
  time: string;
  servings: string;
  difficulty: "Easy" | "Medium";
  heroColor: string;
  accentColor: string;
  ingredients: string[];
  missing: string[];
  wasteNote: string;
  steps: string[];
};

export type CookedMeal = {
  id: string;
  recipeId: string;
  cookedAt: string;
  saved: string;
};
