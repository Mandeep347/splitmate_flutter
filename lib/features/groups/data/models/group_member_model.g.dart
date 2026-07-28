// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupMemberModelImpl _$$GroupMemberModelImplFromJson(
  Map<String, dynamic> json,
) => _$GroupMemberModelImpl(
  userId: json['user_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  status: json['status'] as String,
  joinedAt: json['joined_at'] as String,
);

Map<String, dynamic> _$$GroupMemberModelImplToJson(
  _$GroupMemberModelImpl instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'status': instance.status,
  'joined_at': instance.joinedAt,
};
