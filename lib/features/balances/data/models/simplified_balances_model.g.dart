// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simplified_balances_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SimplifiedBalancesModelImpl _$$SimplifiedBalancesModelImplFromJson(
  Map<String, dynamic> json,
) => _$SimplifiedBalancesModelImpl(
  groupId: json['group_id'] as String,
  currency: json['currency'] as String,
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => PairwiseBalanceModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$SimplifiedBalancesModelImplToJson(
  _$SimplifiedBalancesModelImpl instance,
) => <String, dynamic>{
  'group_id': instance.groupId,
  'currency': instance.currency,
  'transactions': instance.transactions,
};
