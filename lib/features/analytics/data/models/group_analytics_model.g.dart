// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupAnalyticsModelImpl _$$GroupAnalyticsModelImplFromJson(
  Map<String, dynamic> json,
) => _$GroupAnalyticsModelImpl(
  groupId: json['group_id'] as String,
  groupName: json['group_name'] as String,
  currency: json['currency'] as String,
  totalExpensesAmount: json['total_expenses_amount'] as String,
  totalExpenseCount: (json['total_expense_count'] as num).toInt(),
  totalSettlementsAmount: json['total_settlements_amount'] as String,
  settlementRate: json['settlement_rate'] as String,
  averageExpenseAmount: json['average_expense_amount'] as String,
  largestExpenseAmount: json['largest_expense_amount'] as String,
  largestExpenseTitle: json['largest_expense_title'] as String?,
  topSpenderName: json['top_spender_name'] as String?,
  members: (json['members'] as List<dynamic>)
      .map((e) => MemberContributionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  monthlySpending: (json['monthly_spending'] as List<dynamic>)
      .map((e) => MonthlySpendingModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$GroupAnalyticsModelImplToJson(
  _$GroupAnalyticsModelImpl instance,
) => <String, dynamic>{
  'group_id': instance.groupId,
  'group_name': instance.groupName,
  'currency': instance.currency,
  'total_expenses_amount': instance.totalExpensesAmount,
  'total_expense_count': instance.totalExpenseCount,
  'total_settlements_amount': instance.totalSettlementsAmount,
  'settlement_rate': instance.settlementRate,
  'average_expense_amount': instance.averageExpenseAmount,
  'largest_expense_amount': instance.largestExpenseAmount,
  'largest_expense_title': instance.largestExpenseTitle,
  'top_spender_name': instance.topSpenderName,
  'members': instance.members,
  'monthly_spending': instance.monthlySpending,
};
