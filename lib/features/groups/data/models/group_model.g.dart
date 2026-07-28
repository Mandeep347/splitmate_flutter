// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupModelImpl _$$GroupModelImplFromJson(Map<String, dynamic> json) =>
    _$GroupModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      defaultCurrency: json['default_currency'] as String,
      status: json['status'] as String,
      createdBy: json['created_by'] as String,
      createdAt: json['created_at'] as String,
      membersCount: (json['members_count'] as num).toInt(),
      members:
          (json['members'] as List<dynamic>?)
              ?.map((e) => GroupMemberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GroupModelImplToJson(_$GroupModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'default_currency': instance.defaultCurrency,
      'status': instance.status,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt,
      'members_count': instance.membersCount,
      'members': instance.members,
    };
