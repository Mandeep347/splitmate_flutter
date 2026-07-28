import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splito_flutter/core/utils/date_utils.dart';
import '../../domain/entities/settlement.dart';

part 'settlement_model.freezed.dart';
part 'settlement_model.g.dart';

/// Data model representing a settlement transaction with JSON serialization support.
@freezed
class SettlementModel with _$SettlementModel {
  /// Constructor for [SettlementModel].
  const factory SettlementModel({
    required String id,
    @JsonKey(name: 'group_id') required String groupId,
    @JsonKey(name: 'from_user_id') required String fromUserId,
    @JsonKey(name: 'from_user_name') required String fromUserName,
    @JsonKey(name: 'to_user_id') required String toUserId,
    @JsonKey(name: 'to_user_name') required String toUserName,
    required String amount,
    required String currency,
    String? note,
    required String status,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _SettlementModel;

  const SettlementModel._();

  /// Creates a [SettlementModel] from a JSON map.
  factory SettlementModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementModelFromJson(json);

  /// Converts this model into a domain [Settlement] entity.
  Settlement toEntity() {
    return Settlement(
      id: id,
      groupId: groupId,
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      toUserId: toUserId,
      toUserName: toUserName,
      amount: double.parse(amount),
      currency: currency,
      note: note,
      status: status,
      createdAt: AppDateUtils.parseApiDate(createdAt),
    );
  }
}
