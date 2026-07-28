// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseParticipantModelImpl _$$ExpenseParticipantModelImplFromJson(
  Map<String, dynamic> json,
) => _$ExpenseParticipantModelImpl(
  userId: json['user_id'] as String,
  name: json['name'] as String,
  owedAmount: json['owed_amount'] as String,
  percentage: json['percentage'] as String?,
  shares: (json['shares'] as num?)?.toInt(),
);

Map<String, dynamic> _$$ExpenseParticipantModelImplToJson(
  _$ExpenseParticipantModelImpl instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'name': instance.name,
  'owed_amount': instance.owedAmount,
  'percentage': instance.percentage,
  'shares': instance.shares,
};
