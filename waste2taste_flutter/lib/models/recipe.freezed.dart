// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) {
  return _RecipeIngredient.fromJson(json);
}

/// @nodoc
mixin _$RecipeIngredient {
  @JsonKey(name: 'recipe_id')
  String get recipeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ingredient_id')
  String get ingredientId => throw _privateConstructorUsedError;
  String? get quantity =>
      throw _privateConstructorUsedError; // free-form like "2 tbsp"
  bool get required => throw _privateConstructorUsedError;

  /// Serializes this RecipeIngredient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeIngredientCopyWith<RecipeIngredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeIngredientCopyWith<$Res> {
  factory $RecipeIngredientCopyWith(
          RecipeIngredient value, $Res Function(RecipeIngredient) then) =
      _$RecipeIngredientCopyWithImpl<$Res, RecipeIngredient>;
  @useResult
  $Res call(
      {@JsonKey(name: 'recipe_id') String recipeId,
      @JsonKey(name: 'ingredient_id') String ingredientId,
      String? quantity,
      bool required});
}

/// @nodoc
class _$RecipeIngredientCopyWithImpl<$Res, $Val extends RecipeIngredient>
    implements $RecipeIngredientCopyWith<$Res> {
  _$RecipeIngredientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipeId = null,
    Object? ingredientId = null,
    Object? quantity = freezed,
    Object? required = null,
  }) {
    return _then(_value.copyWith(
      recipeId: null == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String?,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeIngredientImplCopyWith<$Res>
    implements $RecipeIngredientCopyWith<$Res> {
  factory _$$RecipeIngredientImplCopyWith(_$RecipeIngredientImpl value,
          $Res Function(_$RecipeIngredientImpl) then) =
      __$$RecipeIngredientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'recipe_id') String recipeId,
      @JsonKey(name: 'ingredient_id') String ingredientId,
      String? quantity,
      bool required});
}

/// @nodoc
class __$$RecipeIngredientImplCopyWithImpl<$Res>
    extends _$RecipeIngredientCopyWithImpl<$Res, _$RecipeIngredientImpl>
    implements _$$RecipeIngredientImplCopyWith<$Res> {
  __$$RecipeIngredientImplCopyWithImpl(_$RecipeIngredientImpl _value,
      $Res Function(_$RecipeIngredientImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipeId = null,
    Object? ingredientId = null,
    Object? quantity = freezed,
    Object? required = null,
  }) {
    return _then(_$RecipeIngredientImpl(
      recipeId: null == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String?,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeIngredientImpl implements _RecipeIngredient {
  const _$RecipeIngredientImpl(
      {@JsonKey(name: 'recipe_id') required this.recipeId,
      @JsonKey(name: 'ingredient_id') required this.ingredientId,
      this.quantity,
      this.required = true});

  factory _$RecipeIngredientImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeIngredientImplFromJson(json);

  @override
  @JsonKey(name: 'recipe_id')
  final String recipeId;
  @override
  @JsonKey(name: 'ingredient_id')
  final String ingredientId;
  @override
  final String? quantity;
// free-form like "2 tbsp"
  @override
  @JsonKey()
  final bool required;

  @override
  String toString() {
    return 'RecipeIngredient(recipeId: $recipeId, ingredientId: $ingredientId, quantity: $quantity, required: $required)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeIngredientImpl &&
            (identical(other.recipeId, recipeId) ||
                other.recipeId == recipeId) &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.required, required) ||
                other.required == required));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, recipeId, ingredientId, quantity, required);

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeIngredientImplCopyWith<_$RecipeIngredientImpl> get copyWith =>
      __$$RecipeIngredientImplCopyWithImpl<_$RecipeIngredientImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeIngredientImplToJson(
      this,
    );
  }
}

abstract class _RecipeIngredient implements RecipeIngredient {
  const factory _RecipeIngredient(
      {@JsonKey(name: 'recipe_id') required final String recipeId,
      @JsonKey(name: 'ingredient_id') required final String ingredientId,
      final String? quantity,
      final bool required}) = _$RecipeIngredientImpl;

  factory _RecipeIngredient.fromJson(Map<String, dynamic> json) =
      _$RecipeIngredientImpl.fromJson;

  @override
  @JsonKey(name: 'recipe_id')
  String get recipeId;
  @override
  @JsonKey(name: 'ingredient_id')
  String get ingredientId;
  @override
  String? get quantity; // free-form like "2 tbsp"
  @override
  bool get required;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeIngredientImplCopyWith<_$RecipeIngredientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return _Recipe.fromJson(json);
}

/// @nodoc
mixin _$Recipe {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_minutes')
  int get timeMinutes => throw _privateConstructorUsedError;
  int get servings => throw _privateConstructorUsedError;
  String get difficulty =>
      throw _privateConstructorUsedError; // "Easy" | "Medium"
  @JsonKey(name: 'hero_color')
  String? get heroColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'accent_color')
  String? get accentColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'waste_note')
  String? get wasteNote => throw _privateConstructorUsedError;
  List<String> get ingredientIds =>
      throw _privateConstructorUsedError; // local catalog only — not from API
  List<String> get steps =>
      throw _privateConstructorUsedError; // local catalog only
  List<RecipeIngredient> get recipeIngredients =>
      throw _privateConstructorUsedError;

  /// Serializes this Recipe to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeCopyWith<Recipe> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeCopyWith<$Res> {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) then) =
      _$RecipeCopyWithImpl<$Res, Recipe>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? subtitle,
      @JsonKey(name: 'time_minutes') int timeMinutes,
      int servings,
      String difficulty,
      @JsonKey(name: 'hero_color') String? heroColor,
      @JsonKey(name: 'accent_color') String? accentColor,
      @JsonKey(name: 'waste_note') String? wasteNote,
      List<String> ingredientIds,
      List<String> steps,
      List<RecipeIngredient> recipeIngredients});
}

/// @nodoc
class _$RecipeCopyWithImpl<$Res, $Val extends Recipe>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? timeMinutes = null,
    Object? servings = null,
    Object? difficulty = null,
    Object? heroColor = freezed,
    Object? accentColor = freezed,
    Object? wasteNote = freezed,
    Object? ingredientIds = null,
    Object? steps = null,
    Object? recipeIngredients = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      timeMinutes: null == timeMinutes
          ? _value.timeMinutes
          : timeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      servings: null == servings
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as int,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
      heroColor: freezed == heroColor
          ? _value.heroColor
          : heroColor // ignore: cast_nullable_to_non_nullable
              as String?,
      accentColor: freezed == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as String?,
      wasteNote: freezed == wasteNote
          ? _value.wasteNote
          : wasteNote // ignore: cast_nullable_to_non_nullable
              as String?,
      ingredientIds: null == ingredientIds
          ? _value.ingredientIds
          : ingredientIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recipeIngredients: null == recipeIngredients
          ? _value.recipeIngredients
          : recipeIngredients // ignore: cast_nullable_to_non_nullable
              as List<RecipeIngredient>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeImplCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$$RecipeImplCopyWith(
          _$RecipeImpl value, $Res Function(_$RecipeImpl) then) =
      __$$RecipeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? subtitle,
      @JsonKey(name: 'time_minutes') int timeMinutes,
      int servings,
      String difficulty,
      @JsonKey(name: 'hero_color') String? heroColor,
      @JsonKey(name: 'accent_color') String? accentColor,
      @JsonKey(name: 'waste_note') String? wasteNote,
      List<String> ingredientIds,
      List<String> steps,
      List<RecipeIngredient> recipeIngredients});
}

/// @nodoc
class __$$RecipeImplCopyWithImpl<$Res>
    extends _$RecipeCopyWithImpl<$Res, _$RecipeImpl>
    implements _$$RecipeImplCopyWith<$Res> {
  __$$RecipeImplCopyWithImpl(
      _$RecipeImpl _value, $Res Function(_$RecipeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? timeMinutes = null,
    Object? servings = null,
    Object? difficulty = null,
    Object? heroColor = freezed,
    Object? accentColor = freezed,
    Object? wasteNote = freezed,
    Object? ingredientIds = null,
    Object? steps = null,
    Object? recipeIngredients = null,
  }) {
    return _then(_$RecipeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      timeMinutes: null == timeMinutes
          ? _value.timeMinutes
          : timeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      servings: null == servings
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as int,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
      heroColor: freezed == heroColor
          ? _value.heroColor
          : heroColor // ignore: cast_nullable_to_non_nullable
              as String?,
      accentColor: freezed == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as String?,
      wasteNote: freezed == wasteNote
          ? _value.wasteNote
          : wasteNote // ignore: cast_nullable_to_non_nullable
              as String?,
      ingredientIds: null == ingredientIds
          ? _value._ingredientIds
          : ingredientIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      recipeIngredients: null == recipeIngredients
          ? _value._recipeIngredients
          : recipeIngredients // ignore: cast_nullable_to_non_nullable
              as List<RecipeIngredient>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeImpl implements _Recipe {
  const _$RecipeImpl(
      {required this.id,
      required this.title,
      required this.subtitle,
      @JsonKey(name: 'time_minutes') required this.timeMinutes,
      required this.servings,
      required this.difficulty,
      @JsonKey(name: 'hero_color') this.heroColor,
      @JsonKey(name: 'accent_color') this.accentColor,
      @JsonKey(name: 'waste_note') this.wasteNote,
      final List<String> ingredientIds = const [],
      final List<String> steps = const [],
      final List<RecipeIngredient> recipeIngredients = const []})
      : _ingredientIds = ingredientIds,
        _steps = steps,
        _recipeIngredients = recipeIngredients;

  factory _$RecipeImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? subtitle;
  @override
  @JsonKey(name: 'time_minutes')
  final int timeMinutes;
  @override
  final int servings;
  @override
  final String difficulty;
// "Easy" | "Medium"
  @override
  @JsonKey(name: 'hero_color')
  final String? heroColor;
  @override
  @JsonKey(name: 'accent_color')
  final String? accentColor;
  @override
  @JsonKey(name: 'waste_note')
  final String? wasteNote;
  final List<String> _ingredientIds;
  @override
  @JsonKey()
  List<String> get ingredientIds {
    if (_ingredientIds is EqualUnmodifiableListView) return _ingredientIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredientIds);
  }

// local catalog only — not from API
  final List<String> _steps;
// local catalog only — not from API
  @override
  @JsonKey()
  List<String> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

// local catalog only
  final List<RecipeIngredient> _recipeIngredients;
// local catalog only
  @override
  @JsonKey()
  List<RecipeIngredient> get recipeIngredients {
    if (_recipeIngredients is EqualUnmodifiableListView)
      return _recipeIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recipeIngredients);
  }

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, subtitle: $subtitle, timeMinutes: $timeMinutes, servings: $servings, difficulty: $difficulty, heroColor: $heroColor, accentColor: $accentColor, wasteNote: $wasteNote, ingredientIds: $ingredientIds, steps: $steps, recipeIngredients: $recipeIngredients)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.timeMinutes, timeMinutes) ||
                other.timeMinutes == timeMinutes) &&
            (identical(other.servings, servings) ||
                other.servings == servings) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.heroColor, heroColor) ||
                other.heroColor == heroColor) &&
            (identical(other.accentColor, accentColor) ||
                other.accentColor == accentColor) &&
            (identical(other.wasteNote, wasteNote) ||
                other.wasteNote == wasteNote) &&
            const DeepCollectionEquality()
                .equals(other._ingredientIds, _ingredientIds) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            const DeepCollectionEquality()
                .equals(other._recipeIngredients, _recipeIngredients));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      subtitle,
      timeMinutes,
      servings,
      difficulty,
      heroColor,
      accentColor,
      wasteNote,
      const DeepCollectionEquality().hash(_ingredientIds),
      const DeepCollectionEquality().hash(_steps),
      const DeepCollectionEquality().hash(_recipeIngredients));

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      __$$RecipeImplCopyWithImpl<_$RecipeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeImplToJson(
      this,
    );
  }
}

abstract class _Recipe implements Recipe {
  const factory _Recipe(
      {required final String id,
      required final String title,
      required final String? subtitle,
      @JsonKey(name: 'time_minutes') required final int timeMinutes,
      required final int servings,
      required final String difficulty,
      @JsonKey(name: 'hero_color') final String? heroColor,
      @JsonKey(name: 'accent_color') final String? accentColor,
      @JsonKey(name: 'waste_note') final String? wasteNote,
      final List<String> ingredientIds,
      final List<String> steps,
      final List<RecipeIngredient> recipeIngredients}) = _$RecipeImpl;

  factory _Recipe.fromJson(Map<String, dynamic> json) = _$RecipeImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get subtitle;
  @override
  @JsonKey(name: 'time_minutes')
  int get timeMinutes;
  @override
  int get servings;
  @override
  String get difficulty; // "Easy" | "Medium"
  @override
  @JsonKey(name: 'hero_color')
  String? get heroColor;
  @override
  @JsonKey(name: 'accent_color')
  String? get accentColor;
  @override
  @JsonKey(name: 'waste_note')
  String? get wasteNote;
  @override
  List<String> get ingredientIds; // local catalog only — not from API
  @override
  List<String> get steps; // local catalog only
  @override
  List<RecipeIngredient> get recipeIngredients;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
