// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PantryItemImpl _$$PantryItemImplFromJson(Map<String, dynamic> json) =>
    _$PantryItemImpl(
      id: json['id'] as String,
      ingredientId: json['ingredient_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PantryItemImplToJson(_$PantryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ingredient_id': instance.ingredientId,
      'quantity': instance.quantity,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
