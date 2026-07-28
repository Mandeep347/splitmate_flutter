import 'member_contribution.dart';
import 'monthly_spending.dart';

/// Aggregates all computed statistical properties returned by the API for a group's transaction history.
class GroupAnalytics {
  /// The unique identifier of the group.
  final String groupId;

  /// The name of the group.
  final String groupName;

  /// The currency code of the aggregated metrics.
  final String currency;

  /// The sum of all active expenses.
  final double totalExpenses;

  /// The number of active expenses in the group.
  final int totalExpenseCount;

  /// The sum of all completed settlements.
  final double totalSettled;

  /// The average transaction amount of active expenses.
  final double averageExpenseAmount;

  /// The maximum transaction amount among active expenses.
  final double largestExpense;

  /// The title of the largest expense.
  final String? largestExpenseTitle;

  /// The name of the member who paid the most.
  final String? topSpenderName;

  /// The settlement rate percentage represented as a fraction (0.0 to 1.0).
  final double settlementRate;

  /// Financial stats per group member, sorted by total paid descending.
  final List<MemberContribution> memberContributions;

  /// Monthly spending metrics, sorted chronologically ascending by year then month.
  final List<MonthlySpending> monthlySpending;

  /// Creates a new [GroupAnalytics] instance.
  const GroupAnalytics({
    required this.groupId,
    required this.groupName,
    required this.currency,
    required this.totalExpenses,
    required this.totalExpenseCount,
    required this.totalSettled,
    required this.averageExpenseAmount,
    required this.largestExpense,
    this.largestExpenseTitle,
    this.topSpenderName,
    required this.settlementRate,
    required this.memberContributions,
    required this.monthlySpending,
  });

  /// Returns true if the group contains at least one active expense.
  bool get hasData => totalExpenseCount > 0;

  /// The member who paid the largest sum for expenses in the group.
  /// Returns null if there are no member contributions recorded.
  MemberContribution? get topPayer {
    if (memberContributions.isEmpty) return null;
    return memberContributions.reduce(
      (a, b) => a.totalPaid > b.totalPaid ? a : b,
    );
  }
}
