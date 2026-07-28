import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:splito_flutter/features/expenses/data/datasources/expense_remote_datasource.dart';
import 'package:splito_flutter/features/expenses/data/models/expense_model.dart';
import 'package:splito_flutter/features/expenses/data/models/paginated_expenses_model.dart';
import 'package:splito_flutter/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_split_input.dart';

class MockIExpenseRemoteDatasource extends Mock
    implements IExpenseRemoteDatasource {}

class MockIExpenseLocalDatasource extends Mock
    implements IExpenseLocalDatasource {}

void main() {
  late MockIExpenseRemoteDatasource mockRemoteDatasource;
  late MockIExpenseLocalDatasource mockLocalDatasource;
  late ExpenseRepositoryImpl repository;

  const tExpenseModel = ExpenseModel(
    id: 'expense-1',
    groupId: 'group-1',
    paidByUserId: 'user-1',
    paidByName: 'Mandeep Singh',
    title: 'Dinner',
    description: null,
    totalAmount: '3000.00',
    currency: 'INR',
    splitType: 'EQUAL',
    status: 'ACTIVE',
    createdAt: '2026-01-01T00:00:00.000Z',
    participants: [],
  );

  setUpAll(() {
    registerFallbackValue(
      const ExpenseModel(
        id: '',
        groupId: '',
        paidByUserId: '',
        paidByName: '',
        title: '',
        totalAmount: '',
        currency: '',
        splitType: '',
        status: '',
        createdAt: '',
      ),
    );
    registerFallbackValue(<ExpenseModel>[]);
  });

  setUp(() {
    mockRemoteDatasource = MockIExpenseRemoteDatasource();
    mockLocalDatasource = MockIExpenseLocalDatasource();
    repository = ExpenseRepositoryImpl(
      mockRemoteDatasource,
      mockLocalDatasource,
    );
  });

  group('getGroupExpenses', () {
    test('fetches from remote, caches page 1, returns entities', () async {
      const tPaginatedModel = PaginatedExpensesModel(
        items: [tExpenseModel],
        page: 1,
        limit: 20,
        totalPages: 1,
        totalItems: 1,
      );

      when(
        () => mockRemoteDatasource.getGroupExpenses(
          groupId: 'group-1',
          page: 1,
          limit: 20,
        ),
      ).thenAnswer((_) async => tPaginatedModel);

      when(
        () => mockLocalDatasource.cacheGroupExpenses(
          groupId: 'group-1',
          expenses: any(named: 'expenses'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.getGroupExpenses(
        groupId: 'group-1',
        page: 1,
        limit: 20,
      );

      expect(result.items.first.title, 'Dinner');
      verify(
        () => mockLocalDatasource.cacheGroupExpenses(
          groupId: 'group-1',
          expenses: const [tExpenseModel],
        ),
      ).called(1);
    });

    test('returns cached list on NetworkException for page 1', () async {
      when(
        () => mockRemoteDatasource.getGroupExpenses(
          groupId: 'group-1',
          page: 1,
          limit: 20,
        ),
      ).thenThrow(const NetworkException('Offline'));

      when(
        () => mockLocalDatasource.getCachedGroupExpenses('group-1'),
      ).thenAnswer((_) async => const [tExpenseModel]);

      final result = await repository.getGroupExpenses(
        groupId: 'group-1',
        page: 1,
        limit: 20,
      );

      expect(result.items.length, 1);
      expect(result.totalPages, 1);
      verify(
        () => mockLocalDatasource.getCachedGroupExpenses('group-1'),
      ).called(1);
    });

    test('throws NetworkException on NetworkException for page > 1', () async {
      when(
        () => mockRemoteDatasource.getGroupExpenses(
          groupId: 'group-1',
          page: 2,
          limit: 20,
        ),
      ).thenThrow(const NetworkException('Offline'));

      expect(
        () =>
            repository.getGroupExpenses(groupId: 'group-1', page: 2, limit: 20),
        throwsA(isA<NetworkException>()),
      );

      verifyNever(() => mockLocalDatasource.getCachedGroupExpenses(any()));
    });

    test('throws when remote fails and cache empty for page 1', () async {
      when(
        () => mockRemoteDatasource.getGroupExpenses(
          groupId: 'group-1',
          page: 1,
          limit: 20,
        ),
      ).thenThrow(const NetworkException('Offline'));

      when(
        () => mockLocalDatasource.getCachedGroupExpenses('group-1'),
      ).thenAnswer((_) async => null);

      expect(
        () =>
            repository.getGroupExpenses(groupId: 'group-1', page: 1, limit: 20),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('getExpenseById', () {
    test('fetches from remote and caches', () async {
      when(
        () => mockRemoteDatasource.getExpenseById(expenseId: 'expense-1'),
      ).thenAnswer((_) async => tExpenseModel);

      when(
        () => mockLocalDatasource.cacheExpense(any()),
      ).thenAnswer((_) async {});

      final result = await repository.getExpenseById(expenseId: 'expense-1');

      expect(result.title, 'Dinner');
      verify(() => mockLocalDatasource.cacheExpense(tExpenseModel)).called(1);
    });

    test('returns cached expense on NetworkException', () async {
      when(
        () => mockRemoteDatasource.getExpenseById(expenseId: 'expense-1'),
      ).thenThrow(const NetworkException('Offline'));

      when(
        () => mockLocalDatasource.getCachedExpense('expense-1'),
      ).thenAnswer((_) async => tExpenseModel);

      final result = await repository.getExpenseById(expenseId: 'expense-1');

      expect(result.title, 'Dinner');
      verify(() => mockLocalDatasource.getCachedExpense('expense-1')).called(1);
    });

    test('throws when remote fails and no cache', () async {
      when(
        () => mockRemoteDatasource.getExpenseById(expenseId: 'expense-1'),
      ).thenThrow(const NetworkException('Offline'));

      when(
        () => mockLocalDatasource.getCachedExpense('expense-1'),
      ).thenAnswer((_) async => null);

      expect(
        () => repository.getExpenseById(expenseId: 'expense-1'),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('createExpense', () {
    test('calls datasource with correct EQUAL body structure', () async {
      const splitInput = EqualSplitInput(
        participants: [EqualParticipantInput(userId: 'u1')],
      );

      when(
        () => mockRemoteDatasource.createExpense(
          groupId: 'group-1',
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => tExpenseModel);

      await repository.createExpense(
        groupId: 'group-1',
        title: 'Dinner',
        totalAmount: 3000.0,
        currency: 'INR',
        paidByUserId: 'user-1',
        splitInput: splitInput,
      );

      final captured =
          verify(
                () => mockRemoteDatasource.createExpense(
                  groupId: 'group-1',
                  body: captureAny(named: 'body'),
                ),
              ).captured.first
              as Map<String, dynamic>;

      expect(captured['split_type'], 'EQUAL');
      expect(captured['participants_equal'], [
        {'user_id': 'u1'},
      ]);
      expect(captured['total_amount'], '3000.00');
    });

    test('calls datasource with correct EXACT body structure', () async {
      const splitInput = ExactSplitInput(
        participants: [ExactParticipantInput(userId: 'u1', owedAmount: 1500.0)],
      );

      when(
        () => mockRemoteDatasource.createExpense(
          groupId: 'group-1',
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => tExpenseModel);

      await repository.createExpense(
        groupId: 'group-1',
        title: 'Dinner',
        totalAmount: 3000.0,
        currency: 'INR',
        paidByUserId: 'user-1',
        splitInput: splitInput,
      );

      final captured =
          verify(
                () => mockRemoteDatasource.createExpense(
                  groupId: 'group-1',
                  body: captureAny(named: 'body'),
                ),
              ).captured.first
              as Map<String, dynamic>;

      expect(captured['split_type'], 'EXACT');
      expect(captured['participants_exact'], [
        {'user_id': 'u1', 'owed_amount': '1500.00'},
      ]);
    });
  });
}
