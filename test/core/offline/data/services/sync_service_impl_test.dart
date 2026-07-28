import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/offline/data/services/sync_service_impl.dart';
import 'package:splito_flutter/core/offline/domain/entities/offline_action.dart';
import 'package:splito_flutter/core/offline/domain/repositories/i_offline_queue_repository.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_split_input.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'package:splito_flutter/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:splito_flutter/features/groups/domain/repositories/i_group_repository.dart';
import 'package:splito_flutter/features/settlements/domain/entities/settlement.dart';
import 'package:splito_flutter/features/settlements/domain/repositories/i_settlement_repository.dart';

import 'package:splito_flutter/core/offline/domain/services/sync_service.dart';

class MockIOfflineQueueRepository extends Mock
    implements IOfflineQueueRepository {}

class MockIExpenseRepository extends Mock implements IExpenseRepository {}

class MockISettlementRepository extends Mock implements ISettlementRepository {}

class MockIGroupRepository extends Mock implements IGroupRepository {}

void main() {
  late MockIOfflineQueueRepository mockQueue;
  late MockIExpenseRepository mockExpenseRepo;
  late MockISettlementRepository mockSettlementRepo;
  late MockIGroupRepository mockGroupRepo;
  late SyncServiceImpl syncService;

  setUpAll(() {
    registerFallbackValue(const EqualSplitInput(participants: []));
  });

  final tCreateExpenseAction = CreateExpenseAction(
    id: 'action-1',
    createdAt: DateTime(2026, 1, 1),
    retryCount: 0,
    maxRetries: 3,
    groupId: 'group-1',
    title: 'Dinner',
    description: null,
    totalAmount: 3000.0,
    currency: 'INR',
    paidByUserId: 'user-1',
    splitType: 'EQUAL',
    participantsJson: '[{"user_id":"user-1"},{"user_id":"user-2"}]',
    idempotencyKey: 'idem-1',
  );

  final tSettlementAction = CreateSettlementAction(
    id: 'action-2',
    createdAt: DateTime(2026, 1, 1, 11, 0),
    retryCount: 0,
    maxRetries: 3,
    groupId: 'group-1',
    fromUserId: 'user-1',
    toUserId: 'user-2',
    amount: 500.0,
    currency: 'INR',
    note: null,
    idempotencyKey: 'idem-2',
  );

  final tAddMemberAction = AddMemberAction(
    id: 'action-3',
    createdAt: DateTime(2026, 1, 1, 12, 0),
    retryCount: 0,
    maxRetries: 3,
    groupId: 'group-1',
    email: 'newuser@example.com',
    idempotencyKey: 'idem-3',
  );

  final tExpense = Expense(
    id: 'exp-1',
    groupId: 'group-1',
    paidByUserId: 'user-1',
    paidByName: 'User 1',
    title: 'Dinner',
    totalAmount: 3000.0,
    currency: 'INR',
    splitType: SplitType.equal,
    status: 'ACTIVE',
    createdAt: DateTime(2026, 1, 1),
  );

  final tSettlement = Settlement(
    id: 'settle-1',
    groupId: 'group-1',
    fromUserId: 'user-1',
    fromUserName: 'User 1',
    toUserId: 'user-2',
    toUserName: 'User 2',
    amount: 500.0,
    currency: 'INR',
    status: 'COMPLETED',
    createdAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    mockQueue = MockIOfflineQueueRepository();
    mockExpenseRepo = MockIExpenseRepository();
    mockSettlementRepo = MockISettlementRepository();
    mockGroupRepo = MockIGroupRepository();

    syncService = SyncServiceImpl(
      queue: mockQueue,
      expenseRepository: mockExpenseRepo,
      settlementRepository: mockSettlementRepo,
      groupRepository: mockGroupRepo,
    );
  });

  group('sync — empty queue', () {
    test('returns SyncResult(0,0,0) with no pending actions', () async {
      when(() => mockQueue.getPending()).thenAnswer((_) async => []);

      final result = await syncService.sync();

      expect(result.succeeded, equals(0));
      expect(result.failed, equals(0));
      expect(result.exhausted, equals(0));
      expect(result.allSucceeded, isTrue);
    });

    test('does not call any repository', () async {
      when(() => mockQueue.getPending()).thenAnswer((_) async => []);

      await syncService.sync();

      verifyNever(
        () => mockExpenseRepo.createExpense(
          groupId: any(named: 'groupId'),
          title: any(named: 'title'),
          totalAmount: any(named: 'totalAmount'),
          currency: any(named: 'currency'),
          paidByUserId: any(named: 'paidByUserId'),
          splitInput: any(named: 'splitInput'),
        ),
      );
      verifyNever(
        () => mockSettlementRepo.createSettlement(
          groupId: any(named: 'groupId'),
          fromUserId: any(named: 'fromUserId'),
          toUserId: any(named: 'toUserId'),
          amount: any(named: 'amount'),
          currency: any(named: 'currency'),
        ),
      );
      verifyNever(
        () => mockGroupRepo.addMember(
          groupId: any(named: 'groupId'),
          email: any(named: 'email'),
        ),
      );
    });
  });

  group('sync — successful processing', () {
    test(
      'calls expenseRepository.createExpense for CreateExpenseAction with correct idempotencyKey',
      () async {
        when(
          () => mockQueue.getPending(),
        ).thenAnswer((_) async => [tCreateExpenseAction]);
        when(
          () => mockExpenseRepo.createExpense(
            groupId: 'group-1',
            title: 'Dinner',
            description: null,
            totalAmount: 3000.0,
            currency: 'INR',
            paidByUserId: 'user-1',
            splitInput: any(named: 'splitInput'),
            idempotencyKey: 'idem-1',
          ),
        ).thenAnswer((_) async => tExpense);
        when(
          () => mockQueue.markCompleted('action-1'),
        ).thenAnswer((_) async {});

        final result = await syncService.sync();

        expect(result.succeeded, equals(1));
        verify(
          () => mockExpenseRepo.createExpense(
            groupId: 'group-1',
            title: 'Dinner',
            description: null,
            totalAmount: 3000.0,
            currency: 'INR',
            paidByUserId: 'user-1',
            splitInput: any(named: 'splitInput'),
            idempotencyKey: 'idem-1',
          ),
        ).called(1);
      },
    );

    test('calls queue.markCompleted after success', () async {
      when(
        () => mockQueue.getPending(),
      ).thenAnswer((_) async => [tCreateExpenseAction]);
      when(
        () => mockExpenseRepo.createExpense(
          groupId: any(named: 'groupId'),
          title: any(named: 'title'),
          totalAmount: any(named: 'totalAmount'),
          currency: any(named: 'currency'),
          paidByUserId: any(named: 'paidByUserId'),
          splitInput: any(named: 'splitInput'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) async => tExpense);
      when(() => mockQueue.markCompleted('action-1')).thenAnswer((_) async {});

      await syncService.sync();

      verify(() => mockQueue.markCompleted('action-1')).called(1);
    });

    test('returns succeeded: 1 for one successful action', () async {
      when(
        () => mockQueue.getPending(),
      ).thenAnswer((_) async => [tCreateExpenseAction]);
      when(
        () => mockExpenseRepo.createExpense(
          groupId: any(named: 'groupId'),
          title: any(named: 'title'),
          totalAmount: any(named: 'totalAmount'),
          currency: any(named: 'currency'),
          paidByUserId: any(named: 'paidByUserId'),
          splitInput: any(named: 'splitInput'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) async => tExpense);
      when(() => mockQueue.markCompleted('action-1')).thenAnswer((_) async {});

      final result = await syncService.sync();

      expect(result.succeeded, equals(1));
      expect(result.failed, equals(0));
      expect(result.exhausted, equals(0));
    });
  });

  group('sync — failure handling', () {
    test('increments retry on NetworkException', () async {
      when(
        () => mockQueue.getPending(),
      ).thenAnswer((_) async => [tCreateExpenseAction]);
      when(
        () => mockExpenseRepo.createExpense(
          groupId: any(named: 'groupId'),
          title: any(named: 'title'),
          totalAmount: any(named: 'totalAmount'),
          currency: any(named: 'currency'),
          paidByUserId: any(named: 'paidByUserId'),
          splitInput: any(named: 'splitInput'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(const NetworkException('Network timeout'));
      when(() => mockQueue.incrementRetry('action-1')).thenAnswer((_) async {});

      final result = await syncService.sync();

      expect(result.failed, equals(1));
      verify(() => mockQueue.incrementRetry('action-1')).called(1);
    });

    test('continues processing remaining actions after failure', () async {
      when(
        () => mockQueue.getPending(),
      ).thenAnswer((_) async => [tCreateExpenseAction, tSettlementAction]);

      // Action 1 fails with NetworkException
      when(
        () => mockExpenseRepo.createExpense(
          groupId: any(named: 'groupId'),
          title: any(named: 'title'),
          totalAmount: any(named: 'totalAmount'),
          currency: any(named: 'currency'),
          paidByUserId: any(named: 'paidByUserId'),
          splitInput: any(named: 'splitInput'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(const NetworkException('Server down'));
      when(() => mockQueue.incrementRetry('action-1')).thenAnswer((_) async {});

      // Action 2 succeeds
      when(
        () => mockSettlementRepo.createSettlement(
          groupId: 'group-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          amount: 500.0,
          currency: 'INR',
          note: null,
          idempotencyKey: 'idem-2',
        ),
      ).thenAnswer((_) async => tSettlement);
      when(() => mockQueue.markCompleted('action-2')).thenAnswer((_) async {});

      final result = await syncService.sync();

      expect(result.succeeded, equals(1));
      expect(result.failed, equals(1));
      expect(result.hasFailures, isTrue);
    });

    test('treats 409 ConflictException on AddMember as success', () async {
      when(
        () => mockQueue.getPending(),
      ).thenAnswer((_) async => [tAddMemberAction]);
      when(
        () => mockGroupRepo.addMember(
          groupId: 'group-1',
          email: 'newuser@example.com',
        ),
      ).thenThrow(const ConflictException('Member already in group'));
      when(() => mockQueue.markCompleted('action-3')).thenAnswer((_) async {});

      final result = await syncService.sync();

      expect(result.succeeded, equals(1));
      expect(result.failed, equals(0));
      verify(() => mockQueue.markCompleted('action-3')).called(1);
      verifyNever(() => mockQueue.incrementRetry('action-3'));
    });
  });

  group('sync — exhausted actions', () {
    test('exhausted count incremented when action hits max retries', () async {
      final nearExhaustedAction = tCreateExpenseAction.copyWith(retryCount: 2);
      when(
        () => mockQueue.getPending(),
      ).thenAnswer((_) async => [nearExhaustedAction]);
      when(
        () => mockExpenseRepo.createExpense(
          groupId: any(named: 'groupId'),
          title: any(named: 'title'),
          totalAmount: any(named: 'totalAmount'),
          currency: any(named: 'currency'),
          paidByUserId: any(named: 'paidByUserId'),
          splitInput: any(named: 'splitInput'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(const NetworkException('Connection reset'));
      when(() => mockQueue.incrementRetry('action-1')).thenAnswer((_) async {});

      final result = await syncService.sync();

      expect(result.exhausted, equals(1));
      expect(result.failed, equals(0));
      expect(result.hasFailures, isTrue);
    });

    test('SyncResult.hasFailures true when exhausted > 0', () {
      const result = SyncResult(0, 0, 1);
      expect(result.hasFailures, isTrue);
      expect(result.allSucceeded, isFalse);
    });
  });
}
