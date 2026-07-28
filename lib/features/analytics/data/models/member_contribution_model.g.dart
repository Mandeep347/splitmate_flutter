// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_contribution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberContributionModelImpl _$$MemberContributionModelImplFromJson(
  Map<String, dynamic> json,
) => _$MemberContributionModelImpl(
  userId: json['user_id'] as String,
  name: json['name'] as String,
  totalPaid: json['total_paid'] as String,
  totalOwed: json['total_owed'] as String,
  netBalance: json['net_balance'] as String,
  expenseCount: (json['expense_count'] as num).toInt(),
  percentageOfTotal: json['percentage_of_total'] as String,
);

Map<String, dynamic> _$$MemberContributionModelImplToJson(
  _$MemberContributionModelImpl instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'name': instance.name,
  'total_paid': instance.totalPaid,
  'total_owed': instance.totalOwed,
  'net_balance': instance.netBalance,
  'expense_count': instance.expenseCount,
  'percentage_of_total': instance.percentageOfTotal,
};
