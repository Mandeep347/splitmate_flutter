import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/balances/presentation/providers/balance_providers.dart';
import 'package:splito_flutter/features/activity/presentation/providers/activity_providers.dart';
import 'package:splito_flutter/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:splito_flutter/features/settlements/data/repositories/settlement_repository_impl.dart';
import 'package:splito_flutter/features/settlements/domain/entities/settlement.dart';
import 'package:splito_flutter/features/settlements/domain/usecases/create_settlement_usecase.dart';
import 'package:splito_flutter/features/settlements/domain/usecases/get_group_settlements_usecase.dart';

// ============================================================================
// SECTION A — UseCase Providers
// ============================================================================

/// Provider exposing [GetGroupSettlementsUseCase].
final getGroupSettlementsUseCaseProvider = Provider<GetGroupSettlementsUseCase>((ref) {
  final repository = ref.watch(settlementRepositoryProvider);
  return GetGroupSettlementsUseCase(repository: repository);
});

/// Provider exposing [CreateSettlementUseCase].
final createSettlementUseCaseProvider = Provider<CreateSettlementUseCase>((ref) {
  final repository = ref.watch(settlementRepositoryProvider);
  return CreateSettlementUseCase(repository: repository);
});

// ============================================================================
// SECTION B — Group Settlements List
// ============================================================================

/// Notifier that manages retrieving and listing settlements history for a group.
class GroupSettlementsNotifier extends FamilyAsyncNotifier<List<Settlement>, String> {
  @override
  FutureOr<List<Settlement>> build(String groupId) {
    final isAuthenticated = ref.watch(authStateProvider);
    if (!isAuthenticated) {
      return const [];
    }

    final useCase = ref.watch(getGroupSettlementsUseCaseProvider);
    return useCase(groupId: groupId);
  }

  /// Invalidates this notifier to trigger a manual refresh.
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Family provider exposing the settlement logs of a group.
final groupSettlementsProvider =
    AsyncNotifierProvider.family<GroupSettlementsNotifier, List<Settlement>, String>(() {
  return GroupSettlementsNotifier();
});

// ============================================================================
// SECTION C — Create Settlement
// ============================================================================

/// Notifier executing the creation of a new debt settlement transaction.
class CreateSettlementNotifier extends AsyncNotifier<Settlement?> {
  @override
  FutureOr<Settlement?> build() {
    return null;
  }

  /// Creates and posts a new settlement.
  Future<Settlement> create({
    required String groupId,
    required String fromUserId,
    required String toUserId,
    required double amount,
    required String currency,
    String? note,
  }) async {
    state = const AsyncLoading<Settlement?>();
    try {
      final useCase = ref.read(createSettlementUseCaseProvider);
      final settlement = await useCase(
        groupId: groupId,
        fromUserId: fromUserId,
        toUserId: toUserId,
        amount: amount,
        currency: currency,
        note: note,
      );

      // On successful creation, invalidate group balances, simplified balances,
      // group settlements logs, group activity, dashboard analytics, and overall net user balances.
      ref.invalidate(groupBalancesProvider(groupId));
      ref.invalidate(simplifiedBalancesProvider(groupId));
      ref.invalidate(groupSettlementsProvider(groupId));
      ref.invalidate(groupActivityProvider(groupId));
      ref.invalidate(myOverallBalancesProvider);
      ref.invalidate(dashboardStatsProvider);

      state = AsyncData<Settlement?>(settlement);
      return settlement;
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<Settlement?>(failure, stackTrace);
      rethrow;
    }
  }
}

/// Provider exposing [CreateSettlementNotifier].
final createSettlementProvider =
    AsyncNotifierProvider<CreateSettlementNotifier, Settlement?>(() {
  return CreateSettlementNotifier();
});
