import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splito_flutter/core/utils/date_utils.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'expense_participant_model.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

/// Serialization model representing an expense record response.
@freezed
class ExpenseModel with _$ExpenseModel {
  /// Creates a new [ExpenseModel] instance.
  const factory ExpenseModel({
    required String id,
    @JsonKey(name: 'group_id') required String groupId,
    @JsonKey(name: 'paid_by_user_id') required String paidByUserId,
    @JsonKey(name: 'paid_by_name') required String paidByName,
    required String title,
    String? description,
    @JsonKey(name: 'total_amount') required String totalAmount,
    required String currency,
    @JsonKey(name: 'split_type') required String splitType,
    required String status,
    @JsonKey(name: 'created_at') required String createdAt,
    @Default([]) List<ExpenseParticipantModel> participants,
  }) = _ExpenseModel;

  const ExpenseModel._();

  /// Deserializes a JSON map into an [ExpenseModel].
  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  /// Converts this serialization model into a domain [Expense] entity.
  Expense toEntity() {
    return Expense(
      id: id,
      groupId: groupId,
      paidByUserId: paidByUserId,
      paidByName: paidByName,
      title: title,
      description: description,
      totalAmount: double.parse(totalAmount),
      currency: currency,
      splitType: SplitType.fromApiValue(splitType),
      status: status,
      createdAt: AppDateUtils.parseApiDate(createdAt),
      participants: participants.map((p) => p.toEntity()).toList(),
    );
  }
}
