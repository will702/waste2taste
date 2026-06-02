// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pantry_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PantryItem _$PantryItemFromJson(Map<String, dynamic> json) {
  return _PantryItem.fromJson(json);
}

/// @nodoc
mixin _$PantryItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'ingredient_id')
  String get ingredientId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PantryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PantryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PantryItemCopyWith<PantryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PantryItemCopyWith<$Res> {
  factory $PantryItemCopyWith(
          PantryItem value, $Res Function(PantryItem) then) =
      _$PantryItemCopyWithImpl<$Res, PantryItem>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'ingredient_id') String ingredientId,
      int quantity,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$PantryItemCopyWithImpl<$Res, $Val extends PantryItem>
    implements $PantryItemCopyWith<$Res> {
  _$PantryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PantryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ingredientId = null,
    Object? quantity = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PantryItemImplCopyWith<$Res>
    implements $PantryItemCopyWith<$Res> {
  factory _$$PantryItemImplCopyWith(
          _$PantryItemImpl value, $Res Function(_$PantryItemImpl) then) =
      __$$PantryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'ingredient_id') String ingredientId,
      int quantity,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$PantryItemImplCopyWithImpl<$Res>
    extends _$PantryItemCopyWithImpl<$Res, _$PantryItemImpl>
    implements _$$PantryItemImplCopyWith<$Res> {
  __$$PantryItemImplCopyWithImpl(
      _$PantryItemImpl _value, $Res Function(_$PantryItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of PantryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ingredientId = null,
    Object? quantity = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PantryItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ingredientId: null == ingredientId
          ? _value.ingredientId
          : ingredientId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PantryItemImpl implements _PantryItem {
  const _$PantryItemImpl(
      {required this.id,
      @JsonKey(name: 'ingredient_id') required this.ingredientId,
      required this.quantity,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$PantryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PantryItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'ingredient_id')
  final String ingredientId;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PantryItem(id: $id, ingredientId: $ingredientId, quantity: $quantity, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PantryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ingredientId, ingredientId) ||
                other.ingredientId == ingredientId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, ingredientId, quantity, updatedAt);

  /// Create a copy of PantryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PantryItemImplCopyWith<_$PantryItemImpl> get copyWith =>
      __$$PantryItemImplCopyWithImpl<_$PantryItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PantryItemImplToJson(
      this,
    );
  }
}

abstract class _PantryItem implements PantryItem {
  const factory _PantryItem(
          {required final String id,
          @JsonKey(name: 'ingredient_id') required final String ingredientId,
          required final int quantity,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$PantryItemImpl;

  factory _PantryItem.fromJson(Map<String, dynamic> json) =
      _$PantryItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'ingredient_id')
  String get ingredientId;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of PantryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PantryItemImplCopyWith<_$PantryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
