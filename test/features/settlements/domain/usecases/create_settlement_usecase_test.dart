import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/settlements/domain/entities/settlement.dart';
import 'package:splito_flutter/features/settlements/domain/repositories/i_settlement_repository.dart';
import 'package:splito_flutter/features/settlements/domain/usecases/create_settlement_usecase.dart';

class MockISettlementRepository extends Mock implements ISettlementRepository {}

void main() {
  late MockISettlementRepository mockRepo;
  late CreateSettlementUseCase usecase;

  final tSettlement = Settlement(
    id: 'settlement-1',
    groupId: 'group-1',
    fromUserId: 'user-1',
    fromUserName: 'Mandeep Singh',
    toUserId: 'user-2',
    toUserName: 'Rahul Kumar',
    amount: 500.0,
    currency: 'INR',
    note: 'Paid via UPI',
    status: 'COMPLETED',
    createdAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    mockRepo = MockISettlementRepository();
    usecase = CreateSettlementUseCase(repository: mockRepo);
  });

  group('CreateSettlementUseCase — local validation', () {
    test(
      'throws BusinessRuleFailure INVALID_AMOUNT when amount is 0',
      () async {
        expect(
          () => usecase.call(
            groupId: 'group-1',
            fromUserId: 'user-1',
            toUserId: 'user-2',
            amount: 0.0,
            currency: 'INR',
          ),
          throwsA(
            isA<BusinessRuleFailure>().having(
              (f) => f.code,
              'code',
              'INVALID_AMOUNT',
            ),
          ),
        );
      },
    );

    test(
      'throws BusinessRuleFailure INVALID_AMOUNT when amount is negative',
      () async {
        expect(
          () => usecase.call(
            groupId: 'group-1',
            fromUserId: 'user-1',
            toUserId: 'user-2',
            amount: -100.0,
            currency: 'INR',
          ),
          throwsA(
            isA<BusinessRuleFailure>().having(
              (f) => f.code,
              'code',
              'INVALID_AMOUNT',
            ),
          ),
        );
      },
    );

    test(
      'throws BusinessRuleFailure SELF_SETTLEMENT_INVALID when fromUserId equals toUserId',
      () async {
        expect(
          () => usecase.call(
            groupId: 'group-1',
            fromUserId: 'user-1',
            toUserId: 'user-1',
            amount: 500.0,
            currency: 'INR',
          ),
          throwsA(
            isA<BusinessRuleFailure>().having(
              (f) => f.code,
              'code',
              'SELF_SETTLEMENT_INVALID',
            ),
          ),
        );
      },
    );

    test('does NOT call repository when local validation fails', () async {
      try {
        await usecase.call(
          groupId: 'group-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          amount: 0.0,
          currency: 'INR',
        );
      } catch (_) {}

      verifyNever(
        () => mockRepo.createSettlement(
          groupId: any(named: 'groupId'),
          fromUserId: any(named: 'fromUserId'),
          toUserId: any(named: 'toUserId'),
          amount: any(named: 'amount'),
          currency: any(named: 'currency'),
          note: any(named: 'note'),
        ),
      );
    });

    test('calls repository and returns Settlement when valid', () async {
      when(
        () => mockRepo.createSettlement(
          groupId: 'group-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          amount: 500.0,
          currency: 'INR',
          note: 'Paid via UPI',
        ),
      ).thenAnswer((_) async => tSettlement);

      final result = await usecase.call(
        groupId: 'group-1',
        fromUserId: 'user-1',
        toUserId: 'user-2',
        amount: 500.0,
        currency: 'INR',
        note: 'Paid via UPI',
      );

      expect(result, equals(tSettlement));
      verify(
        () => mockRepo.createSettlement(
          groupId: 'group-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          amount: 500.0,
          currency: 'INR',
          note: 'Paid via UPI',
        ),
      ).called(1);
    });
  });

  group('CreateSettlementUseCase — exception mapping', () {
    test('maps BusinessRuleException to BusinessRuleFailure', () async {
      when(
        () => mockRepo.createSettlement(
          groupId: any(named: 'groupId'),
          fromUserId: any(named: 'fromUserId'),
          toUserId: any(named: 'toUserId'),
          amount: any(named: 'amount'),
          currency: any(named: 'currency'),
          note: any(named: 'note'),
        ),
      ).thenThrow(
        const BusinessRuleException(
          message: 'Invalid split rule',
          errors: {'code': 'RULE_ERR'},
        ),
      );

      expect(
        () => usecase.call(
          groupId: 'group-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          amount: 500.0,
          currency: 'INR',
        ),
        throwsA(
          isA<BusinessRuleFailure>().having((f) => f.code, 'code', 'RULE_ERR'),
        ),
      );
    });

    test('maps NetworkException to NetworkFailure', () async {
      when(
        () => mockRepo.createSettlement(
          groupId: any(named: 'groupId'),
          fromUserId: any(named: 'fromUserId'),
          toUserId: any(named: 'toUserId'),
          amount: any(named: 'amount'),
          currency: any(named: 'currency'),
          note: any(named: 'note'),
        ),
      ).thenThrow(const NetworkException('Connection timed out'));

      expect(
        () => usecase.call(
          groupId: 'group-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          amount: 500.0,
          currency: 'INR',
        ),
        throwsA(
          isA<NetworkFailure>().having(
            (f) => f.message,
            'message',
            'Connection timed out',
          ),
        ),
      );
    });

    test('does not re-wrap Failure subtypes', () async {
      when(
        () => mockRepo.createSettlement(
          groupId: any(named: 'groupId'),
          fromUserId: any(named: 'fromUserId'),
          toUserId: any(named: 'toUserId'),
          amount: any(named: 'amount'),
          currency: any(named: 'currency'),
          note: any(named: 'note'),
        ),
      ).thenThrow(const BusinessRuleFailure('Auth fail', 'AUTH_FAILED'));

      expect(
        () => usecase.call(
          groupId: 'group-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          amount: 500.0,
          currency: 'INR',
        ),
        throwsA(
          isA<BusinessRuleFailure>().having(
            (f) => f.code,
            'code',
            'AUTH_FAILED',
          ),
        ),
      );
    });
  });
}
