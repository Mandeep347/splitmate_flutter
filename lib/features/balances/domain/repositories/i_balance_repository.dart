import '../entities/group_balances.dart';
import '../entities/simplified_balances.dart';
import '../entities/user_overall_balance.dart';

/// Repository interface governing retrieval of group and user balances.
abstract interface class IBalanceRepository {
  /// Fetches pairwise group balances.
  Future<GroupBalances> getGroupBalances({required String groupId});

  /// Fetches optimized simplified group balances.
  Future<SimplifiedBalances> getSimplifiedBalances({required String groupId});

  /// Fetches net balances across all groups for the currently logged in user.
  Future<List<UserOverallBalance>> getMyOverallBalances();
}
