import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/constants/app_constants.dart';
import 'package:splito_flutter/core/network/dio_client.dart';
import '../models/group_balances_model.dart';
import '../models/simplified_balances_model.dart';
import '../models/user_overall_balance_model.dart';

/// Abstract contract for retrieving group and overall user balances from API endpoints.
abstract interface class IBalanceRemoteDatasource {
  /// Fetches pairwise group balances.
  Future<GroupBalancesModel> getGroupBalances({required String groupId});

  /// Fetches optimized simplified group balances.
  Future<SimplifiedBalancesModel> getSimplifiedBalances({
    required String groupId,
  });

  /// Fetches net balances across all groups for the currently logged in user.
  Future<List<UserOverallBalanceModel>> getMyOverallBalances();
}

/// Remote datasource implementation using [DioClient].
class BalanceRemoteDatasource implements IBalanceRemoteDatasource {
  /// The HTTP client dependency.
  final DioClient client;

  /// Creates a new [BalanceRemoteDatasource] instance.
  const BalanceRemoteDatasource({required this.client});

  @override
  Future<GroupBalancesModel> getGroupBalances({required String groupId}) async {
    final response = await client.get<Map<String, dynamic>>(
      ApiEndpoints.groupBalances(groupId),
    );
    return GroupBalancesModel.fromJson(response.data!);
  }

  @override
  Future<SimplifiedBalancesModel> getSimplifiedBalances({
    required String groupId,
  }) async {
    final response = await client.get<Map<String, dynamic>>(
      ApiEndpoints.simplifiedBalances(groupId),
    );
    return SimplifiedBalancesModel.fromJson(response.data!);
  }

  @override
  Future<List<UserOverallBalanceModel>> getMyOverallBalances() async {
    final response = await client.get<List<dynamic>>(ApiEndpoints.myBalances);
    return response.data!
        .map(
          (item) =>
              UserOverallBalanceModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}

/// Provider exposing [IBalanceRemoteDatasource].
final balanceRemoteDatasourceProvider = Provider<IBalanceRemoteDatasource>((
  ref,
) {
  final client = ref.watch(dioClientProvider);
  return BalanceRemoteDatasource(client: client);
});
