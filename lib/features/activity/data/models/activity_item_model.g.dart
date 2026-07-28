// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityItemModelImpl _$$ActivityItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityItemModelImpl(
  type: json['type'] as String,
  actor: json['actor'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$$ActivityItemModelImplToJson(
  _$ActivityItemModelImpl instance,
) => <String, dynamic>{
  'type': instance.type,
  'actor': instance.actor,
  'created_at': instance.createdAt,
};
