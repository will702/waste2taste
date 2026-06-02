// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeIngredientImpl _$$RecipeIngredientImplFromJson(
        Map<String, dynamic> json) =>
    _$RecipeIngredientImpl(
      recipeId: json['recipe_id'] as String,
      ingredientId: json['ingredient_id'] as String,
      quantity: json['quantity'] as String?,
      required: json['required'] as bool? ?? true,
    );

Map<String, dynamic> _$$RecipeIngredientImplToJson(
        _$RecipeIngredientImpl instance) =>
    <String, dynamic>{
      'recipe_id': instance.recipeId,
      'ingredient_id': instance.ingredientId,
      'quantity': instance.quantity,
      'required': instance.required,
    };

_$RecipeImpl _$$RecipeImplFromJson(Map<String, dynamic> json) => _$RecipeImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      timeMinutes: (json['time_minutes'] as num).toInt(),
      servings: (json['servings'] as num).toInt(),
      difficulty: json['difficulty'] as String,
      heroColor: json['hero_color'] as String?,
      accentColor: json['accent_color'] as String?,
      wasteNote: json['waste_note'] as String?,
      ingredientIds: (json['ingredientIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      steps:
          (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      recipeIngredients: (json['recipeIngredients'] as List<dynamic>?)
              ?.map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RecipeImplToJson(_$RecipeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'time_minutes': instance.timeMinutes,
      'servings': instance.servings,
      'difficulty': instance.difficulty,
      'hero_color': instance.heroColor,
      'accent_color': instance.accentColor,
      'waste_note': instance.wasteNote,
      'ingredientIds': instance.ingredientIds,
      'steps': instance.steps,
      'recipeIngredients': instance.recipeIngredients,
    };
