// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooked_meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CookedMealImpl _$$CookedMealImplFromJson(Map<String, dynamic> json) =>
    _$CookedMealImpl(
      id: json['id'] as String,
      recipeId: json['recipe_id'] as String,
      cookedAt: DateTime.parse(json['cooked_at'] as String),
      saved: json['saved'] as bool?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$CookedMealImplToJson(_$CookedMealImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipe_id': instance.recipeId,
      'cooked_at': instance.cookedAt.toIso8601String(),
      'saved': instance.saved,
      'notes': instance.notes,
    };
