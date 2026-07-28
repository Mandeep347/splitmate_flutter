import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_participant.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_split_input.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'package:splito_flutter/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:splito_flutter/features/expenses/domain/usecases/create_expense_usecase.dart';

class MockIExpenseRepository extends Mock implements IExpenseRepository {}

void main() {
  late MockIExpenseRepository mockRepository;
  late CreateExpenseUseCase useCase;

  const tParticipant = ExpenseParticipant(
    userId: 'user-1',
    name: 'Mandeep Singh',
    owedAmount: 1000.0,
    percentage: null,
    shares: null,
  );

  final tExpense = Expense(
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

  setUpAll(() {
    registerFallbackValue(const EqualSplitInput(participants: []));
  });

  setUp(() {
    mockRepository = MockIExpenseRepository();
    useCase = CreateExpenseUseCase(repository: mockRepository);
  });

  group('CreateExpenseUseCase — local validation', () {
    test(
      'throws BusinessRuleFailure EMPTY_PARTICIPANTS for EqualSplitInput with empty participants list',
      () async {
        const input = EqualSplitInput(participants: []);

        expect(
          () => useCase(
            groupId: 'group-1',
            title: 'Dinner',
            totalAmount: 3000.0,
            currency: 'INR',
            paidByUserId: 'user-1',
            splitInput: input,
          ),
          throwsA(
            isA<BusinessRuleFailure>().having(
              (f) => f.code,
              'code',
              'EMPTY_PARTICIPANTS',
            ),
          ),
        );

        verifyNever(
          () => mockRepository.createExpense(
            groupId: any(named: 'groupId'),
            title: any(named: 'title'),
            totalAmount: any(named: 'totalAmount'),
            currency: any(named: 'currency'),
            paidByUserId: any(named: 'paidByUserId'),
            splitInput: any(named: 'splitInput'),
          ),
        );
      },
    );

    test(
      'throws BusinessRuleFailure INVALID_SPLIT_TOTAL for ExactSplitInput where amounts do not sum to totalAmount',
      () async {
        const input = ExactSplitInput(
          participants: [
            ExactParticipantInput(userId: 'u1', owedAmount: 1000.0),
            ExactParticipantInput(userId: 'u2', owedAmount: 500.0),
          ],
        );

        expect(
          () => useCase(
            groupId: 'group-1',
            title: 'Dinner',
            totalAmount: 3000.0,
            currency: 'INR',
            paidByUserId: 'user-1',
            splitInput: input,
          ),
          throwsA(
            isA<BusinessRuleFailure>().having(
              (f) => f.code,
              'code',
              'INVALID_SPLIT_TOTAL',
            ),
          ),
        );

        verifyNever(
          () => mockRepository.createExpense(
            groupId: any(named: 'groupId'),
            title: any(named: 'title'),
            totalAmount: any(named: 'totalAmount'),
            currency: any(named: 'currency'),
            paidByUserId: any(named: 'paidByUserId'),
            splitInput: any(named: 'splitInput'),
          ),
        );
      },
    );

    test(
      'throws BusinessRuleFailure INVALID_SPLIT_PERCENTAGE for PercentageSplitInput where percentages do not sum to 100',
      () async {
        const input = PercentageSplitInput(
          participants: [
            PercentageParticipantInput(userId: 'u1', percentage: 40.0),
            PercentageParticipantInput(userId: 'u2', percentage: 30.0),
          ],
        );

        expect(
          () => useCase(
            groupId: 'group-1',
            title: 'Dinner',
            totalAmount: 3000.0,
            currency: 'INR',
            paidByUserId: 'user-1',
            splitInput: input,
          ),
          throwsA(
            isA<BusinessRuleFailure>().having(
              (f) => f.code,
              'code',
              'INVALID_SPLIT_PERCENTAGE',
            ),
          ),
        );

        verifyNever(
          () => mockRepository.createExpense(
            groupId: any(named: 'groupId'),
            title: any(named: 'title'),
            totalAmount: any(named: 'totalAmount'),
            currency: any(named: 'currency'),
            paidByUserId: any(named: 'paidByUserId'),
            splitInput: any(named: 'splitInput'),
          ),
        );
      },
    );

    test('calls repository and returns Expense when valid', () async {
      const input = EqualSplitInput(
        participants: [
          EqualParticipantInput(userId: 'u1'),
          EqualParticipantInput(userId: 'u2'),
        ],
      );

      when(
        () => mockRepository.createExpense(
          groupId: 'group-1',
          title: 'Dinner',
          totalAmount: 2000.0,
          currency: 'INR',
          paidByUserId: 'user-1',
          splitInput: input,
        ),
      ).thenAnswer((_) async => tExpense);

      final result = await useCase(
        groupId: 'group-1',
        title: 'Dinner',
        totalAmount: 2000.0,
        currency: 'INR',
        paidByUserId: 'user-1',
        splitInput: input,
      );

      expect(result, tExpense);
      verify(
        () => mockRepository.createExpense(
          groupId: 'group-1',
          title: 'Dinner',
          totalAmount: 2000.0,
          currency: 'INR',
          paidByUserId: 'user-1',
          splitInput: input,
        ),
      ).called(1);
    });
  });

  group('CreateExpenseUseCase — exception mapping', () {
    test('maps BusinessRuleException to BusinessRuleFailure', () async {
      const input = EqualSplitInput(
        participants: [EqualParticipantInput(userId: 'u1')],
      );

      when(
        () => mockRepository.createExpense(
          groupId: 'group-1',
          title: 'Dinner',
          totalAmount: 2000.0,
          currency: 'INR',
          paidByUserId: 'user-1',
          splitInput: input,
        ),
      ).thenThrow(
        const BusinessRuleException(
          message: 'Invalid input',
          errors: {'code': 'SOME_ERROR'},
        ),
      );

      expect(
        () => useCase(
          groupId: 'group-1',
          title: 'Dinner',
          totalAmount: 2000.0,
          currency: 'INR',
          paidByUserId: 'user-1',
          splitInput: input,
        ),
        throwsA(isA<BusinessRuleFailure>()),
      );
    });

    test('maps NetworkException to NetworkFailure', () async {
      const input = EqualSplitInput(
        participants: [EqualParticipantInput(userId: 'u1')],
      );

      when(
        () => mockRepository.createExpense(
          groupId: 'group-1',
          title: 'Dinner',
          totalAmount: 2000.0,
          currency: 'INR',
          paidByUserId: 'user-1',
          splitInput: input,
        ),
      ).thenThrow(const NetworkException('No Internet'));

      expect(
        () => useCase(
          groupId: 'group-1',
          title: 'Dinner',
          totalAmount: 2000.0,
          currency: 'INR',
          paidByUserId: 'user-1',
          splitInput: input,
        ),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('does not re-wrap Failure subtypes', () async {
      const input = EqualSplitInput(
        participants: [EqualParticipantInput(userId: 'u1')],
      );

      when(
        () => mockRepository.createExpense(
          groupId: 'group-1',
          title: 'Dinner',
          totalAmount: 2000.0,
          currency: 'INR',
          paidByUserId: 'user-1',
          splitInput: input,
        ),
      ).thenThrow(const AuthFailure('Unauthorized'));

      expect(
        () => useCase(
          groupId: 'group-1',
          title: 'Dinner',
          totalAmount: 2000.0,
          currency: 'INR',
          paidByUserId: 'user-1',
          splitInput: input,
        ),
        throwsA(isA<AuthFailure>()),
      );
    });
  });
}
