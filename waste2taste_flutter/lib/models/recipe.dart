// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
class RecipeIngredient with _$RecipeIngredient {
  const factory RecipeIngredient({
    @JsonKey(name: 'recipe_id') required String recipeId,
    @JsonKey(name: 'ingredient_id') required String ingredientId,
    String? quantity, // free-form like "2 tbsp"
    @Default(true) bool required,
  }) = _RecipeIngredient;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);
}

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String title,
    required String? subtitle,
    @JsonKey(name: 'time_minutes') required int timeMinutes,
    required int servings,
    required String difficulty, // "Easy" | "Medium"
    @JsonKey(name: 'hero_color') String? heroColor,
    @JsonKey(name: 'accent_color') String? accentColor,
    @JsonKey(name: 'waste_note') String? wasteNote,
    @Default([]) List<String> ingredientIds, // local catalog only — not from API
    @Default([]) List<String> steps, // local catalog only
    @Default([]) List<RecipeIngredient> recipeIngredients, // from API join
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) =>
      _$RecipeFromJson(json);
}
