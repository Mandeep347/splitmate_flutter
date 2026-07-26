import 'package:flutter_test/flutter_test.dart';
import 'package:splito_flutter/core/offline/domain/entities/offline_action.dart';

void main() {
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
    createdAt: DateTime(2026, 1, 1),
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
    createdAt: DateTime(2026, 1, 1),
    retryCount: 0,
    maxRetries: 3,
    groupId: 'group-1',
    email: 'test@example.com',
    idempotencyKey: 'idem-3',
  );

  group('OfflineAction', () {
    test('canRetry true when retryCount < maxRetries', () {
      final action = tCreateExpenseAction.copyWith(retryCount: 2);
      expect(action.canRetry, isTrue);
      expect(action.isExhausted, isFalse);
    });

    test('isExhausted true when retryCount == maxRetries', () {
      final action = tCreateExpenseAction.copyWith(retryCount: 3);
      expect(action.isExhausted, isTrue);
      expect(action.canRetry, isFalse);
    });

    test('copyWith increments retryCount correctly', () {
      final updated = tCreateExpenseAction.copyWith(retryCount: 1);
      expect(updated.retryCount, equals(1));
      expect(updated.id, equals(tCreateExpenseAction.id));
      expect(updated.title, equals('Dinner'));
    });

    test('toJson includes type field', () {
      final expenseJson = tCreateExpenseAction.toJson();
      final settlementJson = tSettlementAction.toJson();
      final addMemberJson = tAddMemberAction.toJson();

      expect(expenseJson['type'], equals('CREATE_EXPENSE'));
      expect(settlementJson['type'], equals('CREATE_SETTLEMENT'));
      expect(addMemberJson['type'], equals('ADD_MEMBER'));
    });

    test('fromJson round-trips correctly for all 3 types', () {
      final expenseFromJson = OfflineAction.fromJson(tCreateExpenseAction.toJson());
      final settlementFromJson = OfflineAction.fromJson(tSettlementAction.toJson());
      final addMemberFromJson = OfflineAction.fromJson(tAddMemberAction.toJson());

      expect(expenseFromJson, isA<CreateExpenseAction>());
      expect(settlementFromJson, isA<CreateSettlementAction>());
      expect(addMemberFromJson, isA<AddMemberAction>());

      expect(expenseFromJson.id, equals('action-1'));
      expect(settlementFromJson.id, equals('action-2'));
      expect(addMemberFromJson.id, equals('action-3'));
    });

    test('fromJson CreateExpenseAction preserves all fields', () {
      final json = tCreateExpenseAction.toJson();
      final result = OfflineAction.fromJson(json) as CreateExpenseAction;

      expect(result.id, equals('action-1'));
      expect(result.groupId, equals('group-1'));
      expect(result.title, equals('Dinner'));
      expect(result.totalAmount, closeTo(3000.0, 0.001));
      expect(result.currency, equals('INR'));
      expect(result.paidByUserId, equals('user-1'));
      expect(result.splitType, equals('EQUAL'));
      expect(result.participantsJson, equals('[{"user_id":"user-1"},{"user_id":"user-2"}]'));
      expect(result.idempotencyKey, equals('idem-1'));
    });
  });
}
