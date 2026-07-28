// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_spending_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlySpendingModelImpl _$$MonthlySpendingModelImplFromJson(
  Map<String, dynamic> json,
) => _$MonthlySpendingModelImpl(
  year: (json['year'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  monthLabel: json['month_label'] as String,
  totalAmount: json['total_amount'] as String,
  expenseCount: (json['expense_count'] as num).toInt(),
);

Map<String, dynamic> _$$MonthlySpendingModelImplToJson(
  _$MonthlySpendingModelImpl instance,
) => <String, dynamic>{
  'year': instance.year,
  'month': instance.month,
  'month_label': instance.monthLabel,
  'total_amount': instance.totalAmount,
  'expense_count': instance.expenseCount,
};
