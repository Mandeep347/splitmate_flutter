import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/constants/storage_keys.dart';
import 'package:splito_flutter/core/offline/data/repositories/offline_queue_repository_impl.dart';
import 'package:splito_flutter/core/offline/domain/entities/offline_action.dart';
import 'package:splito_flutter/core/storage/hive_storage_service.dart';

class MockIHiveStorageService extends Mock implements IHiveStorageService {}

void main() {
  late MockIHiveStorageService mockStorage;
  late OfflineQueueRepositoryImpl repository;

  const boxName = StorageKeys.offlineQueueBox;

  final tAction1 = CreateExpenseAction(
    id: 'action-1',
    createdAt: DateTime(2026, 1, 1, 10, 0),
    retryCount: 0,
    maxRetries: 3,
    groupId: 'group-1',
    title: 'Dinner',
    description: null,
    totalAmount: 1000.0,
    currency: 'INR',
    paidByUserId: 'user-1',
    splitType: 'EQUAL',
    participantsJson: '[]',
    idempotencyKey: 'idem-1',
  );

  final tAction2 = CreateSettlementAction(
    id: 'action-2',
    createdAt: DateTime(2026, 1, 1, 12, 0),
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

  final tExhaustedAction = CreateExpenseAction(
    id: 'action-3',
    createdAt: DateTime(2026, 1, 1, 8, 0),
    retryCount: 3,
    maxRetries: 3,
    groupId: 'group-1',
    title: 'Lunch',
    description: null,
    totalAmount: 200.0,
    currency: 'INR',
    paidByUserId: 'user-1',
    splitType: 'EQUAL',
    participantsJson: '[]',
    idempotencyKey: 'idem-3',
  );

  setUp(() {
    mockStorage = MockIHiveStorageService();
    repository = OfflineQueueRepositoryImpl(mockStorage);
  });

  group('enqueue', () {
    test('writes jsonEncoded action with action_ key prefix', () async {
      when(() => mockStorage.write<String>(any(), any(), any())).thenAnswer((_) async {});

      await repository.enqueue(tAction1);

      verify(() => mockStorage.write<String>(
            boxName,
            'action_action-1',
            jsonEncode(tAction1.toJson()),
          )).called(1);
    });

    test('key contains action id', () async {
      when(() => mockStorage.write<String>(any(), any(), any())).thenAnswer((_) async {});

      await repository.enqueue(tAction2);

      verify(() => mockStorage.write<String>(
            boxName,
            'action_action-2',
            any(),
          )).called(1);
    });
  });

  group('getPending', () {
    test('returns decoded actions sorted by createdAt asc', () async {
      when(() => mockStorage.getKeys(boxName)).thenReturn(['action_action-2', 'action_action-1']);
      when(() => mockStorage.read<String>(boxName, 'action_action-1'))
          .thenReturn(jsonEncode(tAction1.toJson()));
      when(() => mockStorage.read<String>(boxName, 'action_action-2'))
          .thenReturn(jsonEncode(tAction2.toJson()));

      final pending = await repository.getPending();

      expect(pending.length, equals(2));
      expect(pending.first.id, equals('action-1')); // 10:00 AM comes before 12:00 PM
      expect(pending.last.id, equals('action-2'));
    });

    test('excludes exhausted actions', () async {
      when(() => mockStorage.getKeys(boxName)).thenReturn(['action_action-1', 'action_action-3']);
      when(() => mockStorage.read<String>(boxName, 'action_action-1'))
          .thenReturn(jsonEncode(tAction1.toJson()));
      when(() => mockStorage.read<String>(boxName, 'action_action-3'))
          .thenReturn(jsonEncode(tExhaustedAction.toJson()));

      final pending = await repository.getPending();

      expect(pending.length, equals(1));
      expect(pending.first.id, equals('action-1'));
    });

    test('returns empty list on storage error', () async {
      when(() => mockStorage.getKeys(boxName)).thenThrow(Exception('Hive read error'));

      final pending = await repository.getPending();

      expect(pending, isEmpty);
    });
  });

  group('markCompleted', () {
    test('deletes action_ key', () async {
      when(() => mockStorage.read<String>(boxName, 'action_action-1'))
          .thenReturn(jsonEncode(tAction1.toJson()));
      when(() => mockStorage.delete(boxName, 'action_action-1')).thenAnswer((_) async {});
      when(() => mockStorage.write<String>(boxName, 'done_action-1', any()))
          .thenAnswer((_) async {});

      await repository.markCompleted('action-1');

      verify(() => mockStorage.delete(boxName, 'action_action-1')).called(1);
    });

    test('writes done_ key with timestamp', () async {
      when(() => mockStorage.read<String>(boxName, 'action_action-1'))
          .thenReturn(jsonEncode(tAction1.toJson()));
      when(() => mockStorage.delete(boxName, 'action_action-1')).thenAnswer((_) async {});
      when(() => mockStorage.write<String>(boxName, 'done_action-1', any()))
          .thenAnswer((_) async {});

      await repository.markCompleted('action-1');

      verify(() => mockStorage.write<String>(boxName, 'done_action-1', any())).called(1);
    });
  });

  group('incrementRetry', () {
    test('increments retryCount by 1', () async {
      when(() => mockStorage.read<String>(boxName, 'action_action-1'))
          .thenReturn(jsonEncode(tAction1.toJson()));
      when(() => mockStorage.write<String>(boxName, 'action_action-1', any()))
          .thenAnswer((_) async {});

      await repository.incrementRetry('action-1');

      verify(() => mockStorage.write<String>(
            boxName,
            'action_action-1',
            any(that: predicate<String>((str) {
              final map = jsonDecode(str) as Map<String, dynamic>;
              return map['retryCount'] == 1;
            })),
          )).called(1);
    });

    test('calls markExhausted when new count >= maxRetries', () async {
      final nearExhausted = tAction1.copyWith(retryCount: 2);
      when(() => mockStorage.read<String>(boxName, 'action_action-1'))
          .thenReturn(jsonEncode(nearExhausted.toJson()));
      when(() => mockStorage.delete(boxName, 'action_action-1')).thenAnswer((_) async {});
      when(() => mockStorage.write<String>(boxName, 'exhausted_action-1', any()))
          .thenAnswer((_) async {});

      await repository.incrementRetry('action-1');

      verify(() => mockStorage.delete(boxName, 'action_action-1')).called(1);
      verify(() => mockStorage.write<String>(boxName, 'exhausted_action-1', any())).called(1);
    });
  });
}
