import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_split_input.dart';
import 'package:splito_flutter/features/expenses/domain/entities/paginated_expenses.dart';
import 'package:splito_flutter/features/expenses/domain/usecases/create_expense_usecase.dart';
import 'package:splito_flutter/features/expenses/domain/usecases/get_expense_by_id_usecase.dart';
import 'package:splito_flutter/features/expenses/domain/usecases/get_group_expenses_usecase.dart';
import 'package:splito_flutter/features/expenses/domain/usecases/reverse_expense_usecase.dart';
import 'package:splito_flutter/features/expenses/domain/usecases/update_expense_usecase.dart';
import 'package:splito_flutter/features/activity/presentation/providers/activity_providers.dart';
import 'package:splito_flutter/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:splito_flutter/features/balances/presentation/providers/balance_providers.dart';
import 'package:splito_flutter/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';

// ============================================================================
// SECTION A — UseCase Providers
// ============================================================================

/// Provider exposing [GetGroupExpensesUseCase].
final getGroupExpensesUseCaseProvider = Provider<GetGroupExpensesUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return GetGroupExpensesUseCase(repository: repository);
});

/// Provider exposing [GetExpenseByIdUseCase].
final getExpenseByIdUseCaseProvider = Provider<GetExpenseByIdUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return GetExpenseByIdUseCase(repository: repository);
});

/// Provider exposing [CreateExpenseUseCase].
final createExpenseUseCaseProvider = Provider<CreateExpenseUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return CreateExpenseUseCase(repository: repository);
});

/// Provider exposing [UpdateExpenseUseCase].
final updateExpenseUseCaseProvider = Provider<UpdateExpenseUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return UpdateExpenseUseCase(repository: repository);
});

/// Provider exposing [ReverseExpenseUseCase].
final reverseExpenseUseCaseProvider = Provider<ReverseExpenseUseCase>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return ReverseExpenseUseCase(repository: repository);
});

// ============================================================================
// SECTION B — Group Expenses List (Paginated)
// ============================================================================

/// Notifier that manages retrieving and listing paginated expenses for a group.
class GroupExpensesNotifier extends FamilyAsyncNotifier<PaginatedExpenses, String> {
  @override
  FutureOr<PaginatedExpenses> build(String groupId) {
    final useCase = ref.watch(getGroupExpensesUseCaseProvider);
    return useCase(groupId: groupId, page: 1);
  }

  /// Triggers loading the next page of expenses.
  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (state.isLoading || current == null || !current.hasMore) {
      return;
    }

    final newPage = current.page + 1;
    final useCase = ref.read(getGroupExpensesUseCaseProvider);

    try {
      final nextData = await useCase(
        groupId: arg,
        page: newPage,
        limit: current.limit,
      );

      state = AsyncData(PaginatedExpenses(
        items: [...current.items, ...nextData.items],
        page: newPage,
        limit: nextData.limit,
        totalPages: nextData.totalPages,
        totalItems: nextData.totalItems,
      ));
    } catch (e) {
      // Re-throw so UI can intercept and present the pagination fault,
      // keeping the current loaded state intact.
      rethrow;
    }
  }

  /// Refreshes the list by invalidating the notifier.
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Family provider exposing the paginated expenses state of a group.
final groupExpensesProvider =
    AsyncNotifierProvider.family<GroupExpensesNotifier, PaginatedExpenses, String>(() {
  return GroupExpensesNotifier();
});

// ============================================================================
// SECTION C — Single Expense Detail
// ============================================================================

/// Notifier fetching and managing detailed records for a single expense by ID.
class ExpenseDetailNotifier extends FamilyAsyncNotifier<Expense, String> {
  @override
  FutureOr<Expense> build(String expenseId) {
    final useCase = ref.watch(getExpenseByIdUseCaseProvider);
    return useCase(expenseId: expenseId);
  }

  /// Refreshes the detailed expense data.
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Family provider exposing detailed expense states.
final expenseDetailProvider =
    AsyncNotifierProvider.family<ExpenseDetailNotifier, Expense, String>(() {
  return ExpenseDetailNotifier();
});

// ============================================================================
// SECTION D — Create Expense
// ============================================================================

/// Notifier executing the creation of a new group expense.
class CreateExpenseNotifier extends AsyncNotifier<Expense?> {
  @override
  FutureOr<Expense?> build() {
    return null;
  }

  /// Creates a new expense in a group.
  Future<Expense> create({
    required String groupId,
    required String title,
    String? description,
    required double totalAmount,
    required String currency,
    required String paidByUserId,
    required ExpenseSplitInput splitInput,
    String? idempotencyKey,
  }) async {
    state = const AsyncLoading<Expense?>();
    try {
      final useCase = ref.read(createExpenseUseCaseProvider);
      final expense = await useCase(
        groupId: groupId,
        title: title,
        description: description,
        totalAmount: totalAmount,
        currency: currency,
        paidByUserId: paidByUserId,
        splitInput: splitInput,
        idempotencyKey: idempotencyKey,
      );

      ref.invalidate(groupExpensesProvider(groupId));
      ref.invalidate(groupBalancesProvider(groupId));
      ref.invalidate(simplifiedBalancesProvider(groupId));
      ref.invalidate(groupActivityProvider(groupId));
      ref.invalidate(myOverallBalancesProvider);
      ref.invalidate(dashboardStatsProvider);
      ref.invalidate(groupTotalSpentProvider(groupId));
      ref.invalidate(groupDetailProvider(groupId));
      state = AsyncData<Expense?>(expense);
      return expense;
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<Expense?>(failure, stackTrace);
      rethrow;
    }
  }
}

/// Provider exposing [CreateExpenseNotifier].
final createExpenseProvider =
    AsyncNotifierProvider<CreateExpenseNotifier, Expense?>(() {
  return CreateExpenseNotifier();
});

// ============================================================================
// SECTION E — Update Expense
// ============================================================================

/// Notifier executing updates to an existing expense's details.
class UpdateExpenseNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Default initialization, returns nothing
  }

  /// Updates details of an existing expense.
  Future<void> updateExpense({
    required String expenseId,
    required String groupId,
    String? title,
    String? description,
  }) async {
    state = const AsyncLoading<void>();
    try {
      final useCase = ref.read(updateExpenseUseCaseProvider);
      await useCase(
        expenseId: expenseId,
        title: title,
        description: description,
      );

      ref.invalidate(expenseDetailProvider(expenseId));
      ref.invalidate(groupExpensesProvider(groupId));
      ref.invalidate(groupActivityProvider(groupId));
      state = const AsyncData<void>(null);
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<void>(failure, stackTrace);
      rethrow;
    }
  }
}

/// Provider exposing [UpdateExpenseNotifier].
final updateExpenseProvider =
    AsyncNotifierProvider<UpdateExpenseNotifier, void>(() {
  return UpdateExpenseNotifier();
});

// ============================================================================
// SECTION F — Reverse Expense
// ============================================================================

/// Notifier executing reversing actions on active expenses.
class ReverseExpenseNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Default initialization, returns nothing
  }

  /// Reverses an active expense.
  Future<void> reverse({
    required String expenseId,
    required String groupId,
  }) async {
    state = const AsyncLoading<void>();
    try {
      final useCase = ref.read(reverseExpenseUseCaseProvider);
      await useCase(expenseId: expenseId);

      ref.invalidate(expenseDetailProvider(expenseId));
      ref.invalidate(groupExpensesProvider(groupId));
      ref.invalidate(groupBalancesProvider(groupId));
      ref.invalidate(simplifiedBalancesProvider(groupId));
      ref.invalidate(groupActivityProvider(groupId));
      ref.invalidate(myOverallBalancesProvider);
      ref.invalidate(dashboardStatsProvider);
      ref.invalidate(groupTotalSpentProvider(groupId));
      ref.invalidate(groupDetailProvider(groupId));
      state = const AsyncData<void>(null);
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<void>(failure, stackTrace);
      rethrow;
    }
  }
}

/// Provider exposing [ReverseExpenseNotifier].
final reverseExpenseProvider =
    AsyncNotifierProvider<ReverseExpenseNotifier, void>(() {
  return ReverseExpenseNotifier();
});
