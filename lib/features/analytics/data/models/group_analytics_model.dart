import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/group_analytics.dart';
import 'member_contribution_model.dart';
import 'monthly_spending_model.dart';

part 'group_analytics_model.freezed.dart';
part 'group_analytics_model.g.dart';

/// Serialization model representing backend group analytics details responses.
@freezed
class GroupAnalyticsModel with _$GroupAnalyticsModel {
  /// Creates a new [GroupAnalyticsModel] instance.
  const factory GroupAnalyticsModel({
    @JsonKey(name: 'group_id') required String groupId,
    @JsonKey(name: 'group_name') required String groupName,
    required String currency,
    @JsonKey(name: 'total_expenses_amount') required String totalExpensesAmount,
    @JsonKey(name: 'total_expense_count') required int totalExpenseCount,
    @JsonKey(name: 'total_settlements_amount')
    required String totalSettlementsAmount,
    @JsonKey(name: 'settlement_rate') required String settlementRate,
    @JsonKey(name: 'average_expense_amount')
    required String averageExpenseAmount,
    @JsonKey(name: 'largest_expense_amount')
    required String largestExpenseAmount,
    @JsonKey(name: 'largest_expense_title') String? largestExpenseTitle,
    @JsonKey(name: 'top_spender_name') String? topSpenderName,
    required List<MemberContributionModel> members,
    @JsonKey(name: 'monthly_spending')
    required List<MonthlySpendingModel> monthlySpending,
  }) = _GroupAnalyticsModel;

  const GroupAnalyticsModel._();

  /// Deserializes a JSON map into a [GroupAnalyticsModel].
  factory GroupAnalyticsModel.fromJson(Map<String, dynamic> json) =>
      _$GroupAnalyticsModelFromJson(json);

  /// Converts this serialization model into a domain [GroupAnalytics] entity.
  GroupAnalytics toEntity() {
    return GroupAnalytics(
      groupId: groupId,
      groupName: groupName,
      currency: currency,
      totalExpenses: double.parse(totalExpensesAmount),
      totalExpenseCount: totalExpenseCount,
      totalSettled: double.parse(totalSettlementsAmount),
      averageExpenseAmount: double.parse(averageExpenseAmount),
      largestExpense: double.parse(largestExpenseAmount),
      largestExpenseTitle: largestExpenseTitle,
      topSpenderName: topSpenderName,
      settlementRate: double.parse(settlementRate) / 100.0,
      memberContributions: members.map((m) => m.toEntity()).toList(),
      monthlySpending: monthlySpending
          .map((m) => m.toEntity(currency: currency))
          .toList(),
    );
  }
}
