import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/group_balances.dart';
import '../../domain/entities/simplified_balances.dart';
import '../../domain/entities/user_overall_balance.dart';
import '../../domain/repositories/i_balance_repository.dart';
import '../datasources/balance_remote_datasource.dart';

/// Repository implementation handling balance data serialization mappings.
class BalanceRepositoryImpl implements IBalanceRepository {
  /// The remote datasource dependency.
  final IBalanceRemoteDatasource datasource;

  /// Creates a new [BalanceRepositoryImpl] instance.
  const BalanceRepositoryImpl({required this.datasource});

  @override
  Future<GroupBalances> getGroupBalances({required String groupId}) async {
    final model = await datasource.getGroupBalances(groupId: groupId);
    return model.toEntity();
  }

  @override
  Future<SimplifiedBalances> getSimplifiedBalances({
    required String groupId,
  }) async {
    final model = await datasource.getSimplifiedBalances(groupId: groupId);
    return model.toEntity();
  }

  @override
  Future<List<UserOverallBalance>> getMyOverallBalances() async {
    final list = await datasource.getMyOverallBalances();
    return list.map((b) => b.toEntity()).toList();
  }
}

/// Provider exposing [IBalanceRepository].
final balanceRepositoryProvider = Provider<IBalanceRepository>((ref) {
  final datasource = ref.watch(balanceRemoteDatasourceProvider);
  return BalanceRepositoryImpl(datasource: datasource);
});
