// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cooked_meal.freezed.dart';
part 'cooked_meal.g.dart';

@freezed
class CookedMeal with _$CookedMeal {
  const factory CookedMeal({
    required String id,
    @JsonKey(name: 'recipe_id') required String recipeId,
    @JsonKey(name: 'cooked_at') required DateTime cookedAt,
    bool? saved,
    String? notes,
  }) = _CookedMeal;

  factory CookedMeal.fromJson(Map<String, dynamic> json) =>
      _$CookedMealFromJson(json);
}
