// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_analytics_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserAnalyticsGroupModelImpl _$$UserAnalyticsGroupModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserAnalyticsGroupModelImpl(
  groupId: json['group_id'] as String,
  groupName: json['group_name'] as String,
  totalSpent: json['total_spent'] as String,
  userPaid: json['user_paid'] as String,
  userOwed: json['user_owed'] as String,
  expenseCount: (json['expense_count'] as num).toInt(),
  currency: json['currency'] as String,
);

Map<String, dynamic> _$$UserAnalyticsGroupModelImplToJson(
  _$UserAnalyticsGroupModelImpl instance,
) => <String, dynamic>{
  'group_id': instance.groupId,
  'group_name': instance.groupName,
  'total_spent': instance.totalSpent,
  'user_paid': instance.userPaid,
  'user_owed': instance.userOwed,
  'expense_count': instance.expenseCount,
  'currency': instance.currency,
};
