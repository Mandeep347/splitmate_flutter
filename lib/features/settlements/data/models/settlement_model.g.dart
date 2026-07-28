// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettlementModelImpl _$$SettlementModelImplFromJson(
  Map<String, dynamic> json,
) => _$SettlementModelImpl(
  id: json['id'] as String,
  groupId: json['group_id'] as String,
  fromUserId: json['from_user_id'] as String,
  fromUserName: json['from_user_name'] as String,
  toUserId: json['to_user_id'] as String,
  toUserName: json['to_user_name'] as String,
  amount: json['amount'] as String,
  currency: json['currency'] as String,
  note: json['note'] as String?,
  status: json['status'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$$SettlementModelImplToJson(
  _$SettlementModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'group_id': instance.groupId,
  'from_user_id': instance.fromUserId,
  'from_user_name': instance.fromUserName,
  'to_user_id': instance.toUserId,
  'to_user_name': instance.toUserName,
  'amount': instance.amount,
  'currency': instance.currency,
  'note': instance.note,
  'status': instance.status,
  'created_at': instance.createdAt,
};
