// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserAnalyticsModelImpl _$$UserAnalyticsModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserAnalyticsModelImpl(
  userId: json['user_id'] as String,
  userName: json['user_name'] as String,
  totalPaidAllGroups: json['total_paid_all_groups'] as String,
  totalOwedToOthers: json['total_owed_to_others'] as String,
  totalOthersOweUser: json['total_others_owe_user'] as String,
  netBalance: json['net_balance'] as String,
  totalGroupsCount: (json['total_groups_count'] as num).toInt(),
  totalExpenseCount: (json['total_expense_count'] as num).toInt(),
  mostExpensiveGroupName: json['most_expensive_group_name'] as String?,
  groups: (json['groups'] as List<dynamic>)
      .map((e) => UserAnalyticsGroupModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  monthlySpending: (json['monthly_spending'] as List<dynamic>)
      .map((e) => MonthlySpendingModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$UserAnalyticsModelImplToJson(
  _$UserAnalyticsModelImpl instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'user_name': instance.userName,
  'total_paid_all_groups': instance.totalPaidAllGroups,
  'total_owed_to_others': instance.totalOwedToOthers,
  'total_others_owe_user': instance.totalOthersOweUser,
  'net_balance': instance.netBalance,
  'total_groups_count': instance.totalGroupsCount,
  'total_expense_count': instance.totalExpenseCount,
  'most_expensive_group_name': instance.mostExpensiveGroupName,
  'groups': instance.groups,
  'monthly_spending': instance.monthlySpending,
};
