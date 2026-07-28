import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_participant.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'package:splito_flutter/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:splito_flutter/features/expenses/domain/usecases/reverse_expense_usecase.dart';

class MockIExpenseRepository extends Mock implements IExpenseRepository {}

void main() {
  late MockIExpenseRepository mockRepository;
  late ReverseExpenseUseCase useCase;

  const tParticipant = ExpenseParticipant(
    userId: 'user-1',
    name: 'Mandeep Singh',
    owedAmount: 1000.0,
    percentage: null,
    shares: null,
  );

  setUp(() {
    mockRepository = MockIExpenseRepository();
    useCase = ReverseExpenseUseCase(repository: mockRepository);
  });

  group('ReverseExpenseUseCase', () {
    test('returns reversed Expense on success', () async {
      final tReversedExpense = Expense(
        id: 'expense-1',
        groupId: 'group-1',
        paidByUserId: 'user-1',
        paidByName: 'Mandeep Singh',
        title: 'Dinner',
        description: null,
        totalAmount: 3000.0,
        currency: 'INR',
        splitType: SplitType.equal,
        status: 'REVERSED',
        createdAt: DateTime(2026, 1, 1),
        participants: const [tParticipant],
      );

      when(
        () => mockRepository.reverseExpense(expenseId: 'expense-1'),
      ).thenAnswer((_) async => tReversedExpense);

      final result = await useCase(expenseId: 'expense-1');

      expect(result.isReversed, true);
      expect(result.isActive, false);
      verify(
        () => mockRepository.reverseExpense(expenseId: 'expense-1'),
      ).called(1);
    });

    test(
      'maps NotFoundException to ServerFailure with NOT_FOUND code',
      () async {
        when(
          () => mockRepository.reverseExpense(expenseId: 'expense-1'),
        ).thenThrow(const NotFoundException('Not found'));

        expect(
          () => useCase(expenseId: 'expense-1'),
          throwsA(
            isA<ServerFailure>().having((f) => f.code, 'code', 'NOT_FOUND'),
          ),
        );
      },
    );

    test('maps BusinessRuleException to BusinessRuleFailure', () async {
      when(
        () => mockRepository.reverseExpense(expenseId: 'expense-1'),
      ).thenThrow(const BusinessRuleException(message: 'Cannot reverse'));

      expect(
        () => useCase(expenseId: 'expense-1'),
        throwsA(isA<BusinessRuleFailure>()),
      );
    });

    test('maps NetworkException to NetworkFailure', () async {
      when(
        () => mockRepository.reverseExpense(expenseId: 'expense-1'),
      ).thenThrow(const NetworkException('No connection'));

      expect(
        () => useCase(expenseId: 'expense-1'),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });
}
