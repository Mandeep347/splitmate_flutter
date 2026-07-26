import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/features/analytics/domain/entities/group_analytics.dart';
import 'package:splito_flutter/features/analytics/domain/entities/member_contribution.dart';
import 'package:splito_flutter/features/analytics/domain/entities/user_analytics.dart';
import 'package:splito_flutter/features/analytics/domain/usecases/compute_group_analytics_usecase.dart';
import 'package:splito_flutter/features/analytics/domain/usecases/get_expense_search_results_usecase.dart';
import 'package:splito_flutter/features/analytics/domain/usecases/get_user_analytics_usecase.dart';
import 'package:splito_flutter/features/analytics/data/repositories/analytics_repository_impl.dart';

// ============================================================================
// SECTION A — Infrastructure Providers
// ============================================================================

/// Provider exposing [ComputeGroupAnalyticsUseCase].
final computeGroupAnalyticsUseCaseProvider = Provider<ComputeGroupAnalyticsUseCase>((ref) {
  return ComputeGroupAnalyticsUseCase(
    repository: ref.watch(analyticsRepositoryProvider),
  );
});

/// Provider exposing [GetExpenseSearchResultsUseCase].
final getExpenseSearchResultsUseCaseProvider = Provider<GetExpenseSearchResultsUseCase>((ref) {
  return GetExpenseSearchResultsUseCase(
    expenseRepository: ref.watch(expenseRepositoryProvider),
  );
});

/// Provider exposing [GetUserAnalyticsUseCase].
final getUserAnalyticsUseCaseProvider = Provider<GetUserAnalyticsUseCase>((ref) {
  return GetUserAnalyticsUseCase(
    repository: ref.watch(analyticsRepositoryProvider),
  );
});

// ============================================================================
// SECTION B — Group Analytics Notifier & User Analytics Notifier
// ============================================================================

/// Notifier managing group analytics state.
class GroupAnalyticsNotifier extends FamilyAsyncNotifier<GroupAnalytics, String> {
  @override
  FutureOr<GroupAnalytics> build(String groupId) {
    final isAuthenticated = ref.watch(authStateProvider);
    if (!isAuthenticated) {
      return GroupAnalytics(
        groupId: groupId,
        groupName: '',
        currency: 'INR',
        totalExpenses: 0.0,
        totalExpenseCount: 0,
        totalSettled: 0.0,
        averageExpenseAmount: 0.0,
        largestExpense: 0.0,
        settlementRate: 0.0,
        memberContributions: const [],
        monthlySpending: const [],
      );
    }

    // Watch group details to derive default currency
    final groupAsync = ref.watch(groupDetailProvider(groupId));
    final currency = groupAsync.valueOrNull?.defaultCurrency ?? 'INR';

    final useCase = ref.watch(computeGroupAnalyticsUseCaseProvider);
    return useCase(groupId: groupId, currency: currency);
  }

  /// Invalidates this notifier to trigger a manual refresh.
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Provider family exposing remote analytics for a specific group.
final groupAnalyticsProvider =
    AsyncNotifierProvider.family<GroupAnalyticsNotifier, GroupAnalytics, String>(() {
  return GroupAnalyticsNotifier();
});

/// Notifier managing personal analytics state.
class UserAnalyticsNotifier extends AsyncNotifier<UserAnalytics> {
  @override
  FutureOr<UserAnalytics> build() {
    final isAuthenticated = ref.watch(authStateProvider);
    if (!isAuthenticated) {
      return const UserAnalytics(
        userId: '',
        userName: '',
        totalPaidAllGroups: 0.0,
        totalOwedToOthers: 0.0,
        totalOthersOweUser: 0.0,
        netBalance: 0.0,
        totalGroupsCount: 0,
        totalExpenseCount: 0,
        groups: [],
        monthlySpending: [],
      );
    }

    final useCase = ref.watch(getUserAnalyticsUseCaseProvider);
    return useCase();
  }

  void refresh() {
    ref.invalidateSelf();
  }
}

/// Provider exposing personal cross-group analytics.
final userAnalyticsProvider = AsyncNotifierProvider<UserAnalyticsNotifier, UserAnalytics>(() {
  return UserAnalyticsNotifier();
});

// ============================================================================
// SECTION C — Expense Search + Filter Notifier
// ============================================================================

/// State configuration holding all selected search parameters and filters.
class ExpenseSearchState {
  /// The search query term.
  final String searchQuery;

  /// The optional inclusive start date of the search filter.
  final DateTime? fromDate;

  /// The optional inclusive end date of the search filter.
  final DateTime? toDate;

  /// The optional user ID filter of the person who paid.
  final String? paidByUserId;

  /// The optional split strategy filter.
  final SplitType? splitType;

  /// Creates a new [ExpenseSearchState] instance.
  ExpenseSearchState({
    this.searchQuery = '',
    this.fromDate,
    this.toDate,
    this.paidByUserId,
    this.splitType,
  });

  /// Returns true if at least one search query or filter is active.
  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      fromDate != null ||
      toDate != null ||
      paidByUserId != null ||
      splitType != null;

  /// Hand-written copyWith helper supporting explicit value clearing to null.
  ExpenseSearchState copyWith({
    String? searchQuery,
    Object? fromDate = const Object(),
    Object? toDate = const Object(),
    Object? paidByUserId = const Object(),
    Object? splitType = const Object(),
  }) {
    return ExpenseSearchState(
      searchQuery: searchQuery ?? this.searchQuery,
      fromDate: fromDate == const Object() ? this.fromDate : fromDate as DateTime?,
      toDate: toDate == const Object() ? this.toDate : toDate as DateTime?,
      paidByUserId: paidByUserId == const Object() ? this.paidByUserId : paidByUserId as String?,
      splitType: splitType == const Object() ? this.splitType : splitType as SplitType?,
    );
  }
}

/// Provider family exposing the reactive filter configuration state.
final expenseSearchFiltersProvider =
    StateProvider.family<ExpenseSearchState, String>((ref, groupId) {
  return ExpenseSearchState();
});

/// Notifier executing client-side expense searches and filters.
class ExpenseSearchNotifier extends FamilyAsyncNotifier<List<Expense>, String> {
  late ExpenseSearchState _filters;

  @override
  FutureOr<List<Expense>> build(String groupId) async {
    _filters = ExpenseSearchState();
    
    // Sync the filter configuration provider state initially
    ref.read(expenseSearchFiltersProvider(groupId).notifier).state = _filters;

    final isAuthenticated = ref.watch(authStateProvider);
    if (!isAuthenticated) return const [];

    return await _runSearch(groupId);
  }

  /// Updates the query and re-runs search.
  Future<void> updateQuery(String query) async {
    _filters = _filters.copyWith(searchQuery: query);
    ref.read(expenseSearchFiltersProvider(arg).notifier).state = _filters;
    state = const AsyncLoading();
    state = AsyncData(await _runSearch(arg));
  }

  /// Updates the date range filters and re-runs search.
  Future<void> updateDateRange(DateTime? from, DateTime? to) async {
    _filters = _filters.copyWith(fromDate: from, toDate: to);
    ref.read(expenseSearchFiltersProvider(arg).notifier).state = _filters;
    state = const AsyncLoading();
    state = AsyncData(await _runSearch(arg));
  }

  /// Filters by the user who paid for the expense and re-runs search.
  Future<void> updatePaidBy(String? userId) async {
    _filters = _filters.copyWith(paidByUserId: userId);
    ref.read(expenseSearchFiltersProvider(arg).notifier).state = _filters;
    state = const AsyncLoading();
    state = AsyncData(await _runSearch(arg));
  }

  /// Filters by the split strategy type and re-runs search.
  Future<void> updateSplitType(SplitType? type) async {
    _filters = _filters.copyWith(splitType: type);
    ref.read(expenseSearchFiltersProvider(arg).notifier).state = _filters;
    state = const AsyncLoading();
    state = AsyncData(await _runSearch(arg));
  }

  /// Clears all parameters and invalidates search results.
  void clearFilters() {
    _filters = ExpenseSearchState();
    ref.read(expenseSearchFiltersProvider(arg).notifier).state = _filters;
    ref.invalidateSelf();
  }

  Future<List<Expense>> _runSearch(String groupId) async {
    final useCase = ref.read(getExpenseSearchResultsUseCaseProvider);
    return useCase(
      groupId: groupId,
      searchQuery: _filters.searchQuery.isEmpty ? null : _filters.searchQuery,
      fromDate: _filters.fromDate,
      toDate: _filters.toDate,
      paidByUserId: _filters.paidByUserId,
      splitType: _filters.splitType,
    );
  }
}

/// Provider family exposing search results for a group.
final expenseSearchProvider =
    AsyncNotifierProvider.family<ExpenseSearchNotifier, List<Expense>, String>(() {
  return ExpenseSearchNotifier();
});

// ============================================================================
// SECTION D — Derived Summary Providers
// ============================================================================

/// Derived provider family for the total spent in a group (returns 0.0 on loading/error).
final groupTotalSpentProvider = Provider.family<double, String>((ref, groupId) {
  return ref.watch(groupAnalyticsProvider(groupId)).valueOrNull?.totalExpenses ?? 0.0;
});

/// Derived provider family for the top payer in a group (returns null on loading/error).
final groupTopPayerProvider = Provider.family<MemberContribution?, String>((ref, groupId) {
  return ref.watch(groupAnalyticsProvider(groupId)).valueOrNull?.topPayer;
});
