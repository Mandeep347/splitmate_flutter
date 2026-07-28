// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_balances_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupBalancesModelImpl _$$GroupBalancesModelImplFromJson(
  Map<String, dynamic> json,
) => _$GroupBalancesModelImpl(
  groupId: json['group_id'] as String,
  currency: json['currency'] as String,
  balances: (json['balances'] as List<dynamic>)
      .map((e) => PairwiseBalanceModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$GroupBalancesModelImplToJson(
  _$GroupBalancesModelImpl instance,
) => <String, dynamic>{
  'group_id': instance.groupId,
  'currency': instance.currency,
  'balances': instance.balances,
};
