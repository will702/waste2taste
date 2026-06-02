// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cooked_meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CookedMeal _$CookedMealFromJson(Map<String, dynamic> json) {
  return _CookedMeal.fromJson(json);
}

/// @nodoc
mixin _$CookedMeal {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipe_id')
  String get recipeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cooked_at')
  DateTime get cookedAt => throw _privateConstructorUsedError;
  bool? get saved => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this CookedMeal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CookedMeal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CookedMealCopyWith<CookedMeal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CookedMealCopyWith<$Res> {
  factory $CookedMealCopyWith(
          CookedMeal value, $Res Function(CookedMeal) then) =
      _$CookedMealCopyWithImpl<$Res, CookedMeal>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'recipe_id') String recipeId,
      @JsonKey(name: 'cooked_at') DateTime cookedAt,
      bool? saved,
      String? notes});
}

/// @nodoc
class _$CookedMealCopyWithImpl<$Res, $Val extends CookedMeal>
    implements $CookedMealCopyWith<$Res> {
  _$CookedMealCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CookedMeal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recipeId = null,
    Object? cookedAt = null,
    Object? saved = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recipeId: null == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String,
      cookedAt: null == cookedAt
          ? _value.cookedAt
          : cookedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      saved: freezed == saved
          ? _value.saved
          : saved // ignore: cast_nullable_to_non_nullable
              as bool?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CookedMealImplCopyWith<$Res>
    implements $CookedMealCopyWith<$Res> {
  factory _$$CookedMealImplCopyWith(
          _$CookedMealImpl value, $Res Function(_$CookedMealImpl) then) =
      __$$CookedMealImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'recipe_id') String recipeId,
      @JsonKey(name: 'cooked_at') DateTime cookedAt,
      bool? saved,
      String? notes});
}

/// @nodoc
class __$$CookedMealImplCopyWithImpl<$Res>
    extends _$CookedMealCopyWithImpl<$Res, _$CookedMealImpl>
    implements _$$CookedMealImplCopyWith<$Res> {
  __$$CookedMealImplCopyWithImpl(
      _$CookedMealImpl _value, $Res Function(_$CookedMealImpl) _then)
      : super(_value, _then);

  /// Create a copy of CookedMeal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recipeId = null,
    Object? cookedAt = null,
    Object? saved = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$CookedMealImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recipeId: null == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String,
      cookedAt: null == cookedAt
          ? _value.cookedAt
          : cookedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      saved: freezed == saved
          ? _value.saved
          : saved // ignore: cast_nullable_to_non_nullable
              as bool?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CookedMealImpl implements _CookedMeal {
  const _$CookedMealImpl(
      {required this.id,
      @JsonKey(name: 'recipe_id') required this.recipeId,
      @JsonKey(name: 'cooked_at') required this.cookedAt,
      this.saved,
      this.notes});

  factory _$CookedMealImpl.fromJson(Map<String, dynamic> json) =>
      _$$CookedMealImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'recipe_id')
  final String recipeId;
  @override
  @JsonKey(name: 'cooked_at')
  final DateTime cookedAt;
  @override
  final bool? saved;
  @override
  final String? notes;

  @override
  String toString() {
    return 'CookedMeal(id: $id, recipeId: $recipeId, cookedAt: $cookedAt, saved: $saved, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CookedMealImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recipeId, recipeId) ||
                other.recipeId == recipeId) &&
            (identical(other.cookedAt, cookedAt) ||
                other.cookedAt == cookedAt) &&
            (identical(other.saved, saved) || other.saved == saved) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, recipeId, cookedAt, saved, notes);

  /// Create a copy of CookedMeal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CookedMealImplCopyWith<_$CookedMealImpl> get copyWith =>
      __$$CookedMealImplCopyWithImpl<_$CookedMealImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CookedMealImplToJson(
      this,
    );
  }
}

abstract class _CookedMeal implements CookedMeal {
  const factory _CookedMeal(
      {required final String id,
      @JsonKey(name: 'recipe_id') required final String recipeId,
      @JsonKey(name: 'cooked_at') required final DateTime cookedAt,
      final bool? saved,
      final String? notes}) = _$CookedMealImpl;

  factory _CookedMeal.fromJson(Map<String, dynamic> json) =
      _$CookedMealImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'recipe_id')
  String get recipeId;
  @override
  @JsonKey(name: 'cooked_at')
  DateTime get cookedAt;
  @override
  bool? get saved;
  @override
  String? get notes;

  /// Create a copy of CookedMeal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CookedMealImplCopyWith<_$CookedMealImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
