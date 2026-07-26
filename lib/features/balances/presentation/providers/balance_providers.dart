import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/balances/data/repositories/balance_repository_impl.dart';
import 'package:splito_flutter/features/balances/domain/entities/group_balances.dart';
import 'package:splito_flutter/features/balances/domain/entities/simplified_balances.dart';
import 'package:splito_flutter/features/balances/domain/entities/user_overall_balance.dart';
import 'package:splito_flutter/features/balances/domain/usecases/get_group_balances_usecase.dart';
import 'package:splito_flutter/features/balances/domain/usecases/get_my_overall_balances_usecase.dart';
import 'package:splito_flutter/features/balances/domain/usecases/get_simplified_balances_usecase.dart';
import 'package:splito_flutter/core/utils/provider_ttl.dart';

// ============================================================================
// SECTION A — UseCase Providers
// ============================================================================

/// Provider exposing [GetGroupBalancesUseCase].
final getGroupBalancesUseCaseProvider = Provider<GetGroupBalancesUseCase>((ref) {
  final repository = ref.watch(balanceRepositoryProvider);
  return GetGroupBalancesUseCase(repository: repository);
});

/// Provider exposing [GetSimplifiedBalancesUseCase].
final getSimplifiedBalancesUseCaseProvider = Provider<GetSimplifiedBalancesUseCase>((ref) {
  final repository = ref.watch(balanceRepositoryProvider);
  return GetSimplifiedBalancesUseCase(repository: repository);
});

/// Provider exposing [GetMyOverallBalancesUseCase].
final getMyOverallBalancesUseCaseProvider = Provider<GetMyOverallBalancesUseCase>((ref) {
  final repository = ref.watch(balanceRepositoryProvider);
  return GetMyOverallBalancesUseCase(repository: repository);
});

// ============================================================================
// SECTION B — Group Balances (raw pairwise)
// ============================================================================

/// Notifier that manages retrieving and listing non-simplified group balances.
class GroupBalancesNotifier extends FamilyAsyncNotifier<GroupBalances, String> {
  @override
  FutureOr<GroupBalances> build(String groupId) {
    final isAuthenticated = ref.watch(authStateProvider);
    if (!isAuthenticated) {
      return GroupBalances(
        groupId: groupId,
        currency: 'INR',
        balances: const [],
      );
    }

    final useCase = ref.watch(getGroupBalancesUseCaseProvider);
    return useCase(groupId: groupId);
  }

  /// Invalidates this notifier to trigger a manual refresh.
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Family provider exposing the non-simplified pairwise balances of a group.
final groupBalancesProvider =
    AsyncNotifierProvider.family<GroupBalancesNotifier, GroupBalances, String>(() {
  return GroupBalancesNotifier();
});

// ============================================================================
// SECTION C — Simplified Balances (debt minimisation)
// ============================================================================

/// Notifier that manages retrieving and listing simplified optimized group balances.
class SimplifiedBalancesNotifier extends FamilyAsyncNotifier<SimplifiedBalances, String> {
  @override
  FutureOr<SimplifiedBalances> build(String groupId) {
    final isAuthenticated = ref.watch(authStateProvider);
    if (!isAuthenticated) {
      return SimplifiedBalances(
        groupId: groupId,
        currency: 'INR',
        transactions: const [],
      );
    }

    final useCase = ref.watch(getSimplifiedBalancesUseCaseProvider);
    return useCase(groupId: groupId);
  }

  /// Invalidates this notifier to trigger a manual refresh.
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Family provider exposing the simplified group balances.
final simplifiedBalancesProvider =
    AsyncNotifierProvider.family<SimplifiedBalancesNotifier, SimplifiedBalances, String>(() {
  return SimplifiedBalancesNotifier();
});

// ============================================================================
// SECTION D — User Overall Balances (cross-group dashboard)
// ============================================================================

/// Notifier that manages retrieving the current user's net overall balances across all groups.
class MyOverallBalancesNotifier extends AsyncNotifier<List<UserOverallBalance>> {
  @override
  FutureOr<List<UserOverallBalance>> build() {
    final isAuthenticated = ref.watch(authStateProvider);
    if (!isAuthenticated) {
      return const [];
    }

    ref.cacheWithTTL(ProviderTTL.shortTTL);

    final useCase = ref.watch(getMyOverallBalancesUseCaseProvider);
    return useCase();
  }

  /// Invalidates this notifier to trigger a manual refresh.
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Provider exposing the net balances of the current user across all groups.
final myOverallBalancesProvider =
    AsyncNotifierProvider<MyOverallBalancesNotifier, List<UserOverallBalance>>(() {
  return MyOverallBalancesNotifier();
});

// ============================================================================
// SECTION E — Derived providers for the dashboard
// ============================================================================

/// Total amount the current user owes across all groups.
final totalOwedProvider = Provider<double>((ref) {
  final balancesAsync = ref.watch(myOverallBalancesProvider);
  final balances = balancesAsync.hasValue ? balancesAsync.requireValue : <UserOverallBalance>[];
  return balances
      .where((b) => b.youOwe)
      .fold(0.0, (double sum, b) => sum + b.absAmount);
});

/// Total amount owed TO the current user across all groups.
final totalOwedToMeProvider = Provider<double>((ref) {
  final balancesAsync = ref.watch(myOverallBalancesProvider);
  final balances = balancesAsync.hasValue ? balancesAsync.requireValue : <UserOverallBalance>[];
  return balances
      .where((b) => b.theyOwe)
      .fold(0.0, (double sum, b) => sum + b.absAmount);
});
