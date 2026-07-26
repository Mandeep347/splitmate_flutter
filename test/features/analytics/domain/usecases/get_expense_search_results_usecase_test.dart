import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/features/analytics/domain/usecases/get_expense_search_results_usecase.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_participant.dart';
import 'package:splito_flutter/features/expenses/domain/entities/paginated_expenses.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'package:splito_flutter/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:splito_flutter/features/settlements/domain/entities/settlement.dart';

class MockIExpenseRepository extends Mock implements IExpenseRepository {}

const tParticipant1 = ExpenseParticipant(
  userId: 'user-1',
  name: 'Mandeep',
  owedAmount: 1000.0,
);
const tParticipant2 = ExpenseParticipant(
  userId: 'user-2',
  name: 'Rahul',
  owedAmount: 2000.0,
);

final tExpense1 = Expense(
  id: 'exp-1',
  groupId: 'group-1',
  paidByUserId: 'user-1',
  paidByName: 'Mandeep',
  title: 'Dinner',
  totalAmount: 3000.0,
  currency: 'INR',
  splitType: SplitType.equal,
  status: 'ACTIVE',
  createdAt: DateTime(2026, 1, 15),
  participants: [tParticipant1, tParticipant2],
);

final tExpense2 = Expense(
  id: 'exp-2',
  groupId: 'group-1',
  paidByUserId: 'user-2',
  paidByName: 'Rahul',
  title: 'Hotel',
  totalAmount: 6000.0,
  currency: 'INR',
  splitType: SplitType.exact,
  status: 'ACTIVE',
  createdAt: DateTime(2026, 2, 10),
  participants: [tParticipant1, tParticipant2],
);

final tReversedExpense = Expense(
  id: 'exp-3',
  groupId: 'group-1',
  paidByUserId: 'user-1',
  paidByName: 'Mandeep',
  title: 'Cancelled',
  totalAmount: 500.0,
  currency: 'INR',
  splitType: SplitType.equal,
  status: 'REVERSED',
  createdAt: DateTime(2026, 1, 20),
  participants: const [],
);

final tSettlement = Settlement(
  id: 'set-1',
  groupId: 'group-1',
  fromUserId: 'user-2',
  fromUserName: 'Rahul',
  toUserId: 'user-1',
  toUserName: 'Mandeep',
  amount: 1000.0,
  currency: 'INR',
  status: 'COMPLETED',
  createdAt: DateTime(2026, 2, 1),
);

void main() {
  late GetExpenseSearchResultsUseCase useCase;
  late MockIExpenseRepository mockExpenseRepository;

  setUp(() {
    mockExpenseRepository = MockIExpenseRepository();
    useCase = GetExpenseSearchResultsUseCase(expenseRepository: mockExpenseRepository);

    when(() => mockExpenseRepository.getGroupExpenses(
          groupId: 'group-1',
          page: 1,
          limit: 1000,
        )).thenAnswer(
      (_) async => PaginatedExpenses(
        items: [tExpense1, tExpense2, tReversedExpense],
        page: 1,
        limit: 1000,
        totalPages: 1,
        totalItems: 3,
      ),
    );
  });

  group('GetExpenseSearchResultsUseCase', () {
    test('returns all when no filters', () async {
      final result = await useCase(groupId: 'group-1');
      expect(result.length, 3);
    });

    test('filters by searchQuery case-insensitive', () async {
      final result = await useCase(
        groupId: 'group-1',
        searchQuery: 'dinner',
      );
      expect(result.length, 1);
      expect(result.first.title, 'Dinner');
    });

    test('filters by fromDate', () async {
      final result = await useCase(
        groupId: 'group-1',
        fromDate: DateTime(2026, 2, 1),
      );
      expect(result.length, 1);
      expect(result.first.id, 'exp-2');
    });

    test('filters by paidByUserId', () async {
      final result = await useCase(
        groupId: 'group-1',
        paidByUserId: 'user-1',
      );
      expect(result.length, 2);
      expect(result.map((e) => e.id), containsAll(['exp-1', 'exp-3']));
      expect(result.map((e) => e.id), isNot(contains('exp-2')));
    });

    test('filters by splitType', () async {
      final result = await useCase(
        groupId: 'group-1',
        splitType: SplitType.exact,
      );
      expect(result.length, 1);
      expect(result.first.id, 'exp-2');
    });

    test('combined filters — query + paidBy', () async {
      final result = await useCase(
        groupId: 'group-1',
        searchQuery: 'dinner',
        paidByUserId: 'user-1',
      );
      expect(result.length, 1);
      expect(result.first.id, 'exp-1');
    });

    test('returns sorted by createdAt descending', () async {
      final result = await useCase(groupId: 'group-1');
      expect(result.first.createdAt.isAfter(result.last.createdAt), isTrue);
    });
  });
}
