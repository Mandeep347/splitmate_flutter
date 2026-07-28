// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseModelImpl _$$ExpenseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseModelImpl(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      paidByUserId: json['paid_by_user_id'] as String,
      paidByName: json['paid_by_name'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      totalAmount: json['total_amount'] as String,
      currency: json['currency'] as String,
      splitType: json['split_type'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      participants:
          (json['participants'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ExpenseParticipantModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ExpenseModelImplToJson(_$ExpenseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'paid_by_user_id': instance.paidByUserId,
      'paid_by_name': instance.paidByName,
      'title': instance.title,
      'description': instance.description,
      'total_amount': instance.totalAmount,
      'currency': instance.currency,
      'split_type': instance.splitType,
      'status': instance.status,
      'created_at': instance.createdAt,
      'participants': instance.participants,
    };
