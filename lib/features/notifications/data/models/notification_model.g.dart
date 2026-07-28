// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  type: json['type'] as String,
  title: json['title'] as String?,
  message: json['message'] as String?,
  isRead: json['is_read'] as bool,
  metadata: json['metadata'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'message': instance.message,
  'is_read': instance.isRead,
  'metadata': instance.metadata,
  'created_at': instance.createdAt,
};
