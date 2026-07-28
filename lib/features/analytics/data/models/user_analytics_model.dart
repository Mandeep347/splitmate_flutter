import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_analytics.dart';
import 'monthly_spending_model.dart';
import 'user_analytics_group_model.dart';

part 'user_analytics_model.freezed.dart';
part 'user_analytics_model.g.dart';

/// Serialization model representing backend user analytics responses.
@freezed
class UserAnalyticsModel with _$UserAnalyticsModel {
  /// Creates a new [UserAnalyticsModel] instance.
  const factory UserAnalyticsModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_name') required String userName,
    @JsonKey(name: 'total_paid_all_groups') required String totalPaidAllGroups,
    @JsonKey(name: 'total_owed_to_others') required String totalOwedToOthers,
    @JsonKey(name: 'total_others_owe_user') required String totalOthersOweUser,
    @JsonKey(name: 'net_balance') required String netBalance,
    @JsonKey(name: 'total_groups_count') required int totalGroupsCount,
    @JsonKey(name: 'total_expense_count') required int totalExpenseCount,
    @JsonKey(name: 'most_expensive_group_name') String? mostExpensiveGroupName,
    required List<UserAnalyticsGroupModel> groups,
    @JsonKey(name: 'monthly_spending')
    required List<MonthlySpendingModel> monthlySpending,
  }) = _UserAnalyticsModel;

  const UserAnalyticsModel._();

  /// Deserializes a JSON map into a [UserAnalyticsModel].
  factory UserAnalyticsModel.fromJson(Map<String, dynamic> json) =>
      _$UserAnalyticsModelFromJson(json);

  /// Converts this serialization model into a domain [UserAnalytics] entity.
  UserAnalytics toEntity() {
    return UserAnalytics(
      userId: userId,
      userName: userName,
      totalPaidAllGroups: double.parse(totalPaidAllGroups),
      totalOwedToOthers: double.parse(totalOwedToOthers),
      totalOthersOweUser: double.parse(totalOthersOweUser),
      netBalance: double.parse(netBalance),
      totalGroupsCount: totalGroupsCount,
      totalExpenseCount: totalExpenseCount,
      mostExpensiveGroupName: mostExpensiveGroupName,
      groups: groups.map((g) => g.toEntity()).toList(),
      monthlySpending: monthlySpending.map((m) => m.toEntity()).toList(),
    );
  }
}
