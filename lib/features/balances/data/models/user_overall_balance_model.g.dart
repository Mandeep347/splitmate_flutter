// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_overall_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserOverallBalanceModelImpl _$$UserOverallBalanceModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserOverallBalanceModelImpl(
  counterpartUserId: json['counterpart_user_id'] as String,
  counterpartName: json['counterpart_name'] as String,
  netAmount: json['net_amount'] as String,
  currency: json['currency'] as String,
);

Map<String, dynamic> _$$UserOverallBalanceModelImplToJson(
  _$UserOverallBalanceModelImpl instance,
) => <String, dynamic>{
  'counterpart_user_id': instance.counterpartUserId,
  'counterpart_name': instance.counterpartName,
  'net_amount': instance.netAmount,
  'currency': instance.currency,
};
