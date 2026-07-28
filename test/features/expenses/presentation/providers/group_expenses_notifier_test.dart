import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_participant.dart';
import 'package:splito_flutter/features/expenses/domain/entities/paginated_expenses.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'package:splito_flutter/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:splito_flutter/features/expenses/presentation/providers/expense_providers.dart';

class MockIExpenseRepository extends Mock implements IExpenseRepository {}

void main() {
  late MockIExpenseRepository mockRepository;
  late ProviderContainer container;

  const tParticipant = ExpenseParticipant(
    userId: 'user-1',
    name: 'Mandeep Singh',
    owedAmount: 1000.0,
    percentage: null,
    shares: null,
  );

  final tExpense1 = Expense(
    id: 'expense-1',
    groupId: 'group-1',
    paidByUserId: 'user-1',
    paidByName: 'Mandeep Singh',
    title: 'Dinner',
    description: null,
    totalAmount: 3000.0,
    currency: 'INR',
    splitType: SplitType.equal,
    status: 'ACTIVE',
    createdAt: DateTime(2026, 1, 1),
    participants: const [tParticipant],
  );

  final tExpense2 = Expense(
    id: 'expense-2',
    groupId: 'group-1',
    paidByUserId: 'user-1',
    paidByName: 'Mandeep Singh',
    title: 'Lunch',
    description: null,
    totalAmount: 1500.0,
    currency: 'INR',
    splitType: SplitType.equal,
    status: 'ACTIVE',
    createdAt: DateTime(2026, 1, 2),
    participants: const [tParticipant],
  );

  final tPaginatedPage1 = PaginatedExpenses(
    items: [tExpense1],
    page: 1,
    limit: 20,
    totalPages: 2,
    totalItems: 2,
  );

  final tPaginatedPage2 = PaginatedExpenses(
    items: [tExpense2],
    page: 2,
    limit: 20,
    totalPages: 2,
    totalItems: 2,
  );

  setUp(() {
    mockRepository = MockIExpenseRepository();
    container = ProviderContainer(
      overrides: [expenseRepositoryProvider.overrideWithValue(mockRepository)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('GroupExpensesNotifier', () {
    test('emits PaginatedExpenses on successful build', () async {
      when(
        () => mockRepository.getGroupExpenses(
          groupId: 'group-1',
          page: 1,
          limit: 20,
        ),
      ).thenAnswer((_) async => tPaginatedPage1);

      final result = await container.read(
        groupExpensesProvider('group-1').future,
      );

      expect(result.items.length, 1);
      expect(result.items.first, tExpense1);
      expect(result.hasMore, true);
    });

    test('loadNextPage merges new items with existing', () async {
      when(
        () => mockRepository.getGroupExpenses(
          groupId: 'group-1',
          page: 1,
          limit: 20,
        ),
      ).thenAnswer((_) async => tPaginatedPage1);

      when(
        () => mockRepository.getGroupExpenses(
          groupId: 'group-1',
          page: 2,
          limit: 20,
        ),
      ).thenAnswer((_) async => tPaginatedPage2);

      // Wait for initial build to complete
      await container.read(groupExpensesProvider('group-1').future);

      // Trigger loadNextPage
      await container
          .read(groupExpensesProvider('group-1').notifier)
          .loadNextPage();

      final state = container.read(groupExpensesProvider('group-1'));

      expect(state.value?.items, [tExpense1, tExpense2]);
      expect(state.value?.page, 2);
      expect(state.value?.hasMore, false);
    });

    test('loadNextPage does not wipe existing list on failure', () async {
      when(
        () => mockRepository.getGroupExpenses(
          groupId: 'group-1',
          page: 1,
          limit: 20,
        ),
      ).thenAnswer((_) async => tPaginatedPage1);

      when(
        () => mockRepository.getGroupExpenses(
          groupId: 'group-1',
          page: 2,
          limit: 20,
        ),
      ).thenThrow(const NetworkFailure('Offline'));

      // Wait for initial build
      await container.read(groupExpensesProvider('group-1').future);

      // Trigger loadNextPage and catch expected exception
      try {
        await container
            .read(groupExpensesProvider('group-1').notifier)
            .loadNextPage();
      } catch (_) {
        // Expected exception
      }

      final state = container.read(groupExpensesProvider('group-1'));

      // Ensure state is still AsyncData and items are preserved
      expect(state.hasError, false);
      expect(state.value?.items, [tExpense1]);
      expect(state.value?.page, 1);
    });

    test('emits AsyncError when initial load throws', () async {
      when(
        () => mockRepository.getGroupExpenses(
          groupId: 'group-1',
          page: 1,
          limit: 20,
        ),
      ).thenThrow(const NetworkFailure('Offline'));

      expect(
        () => container.read(groupExpensesProvider('group-1').future),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });
}
