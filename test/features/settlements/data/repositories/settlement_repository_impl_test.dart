import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/features/settlements/data/datasources/settlement_remote_datasource.dart';
import 'package:splito_flutter/features/settlements/data/models/settlement_model.dart';
import 'package:splito_flutter/features/settlements/data/repositories/settlement_repository_impl.dart';

class MockISettlementRemoteDatasource extends Mock
    implements ISettlementRemoteDatasource {}

void main() {
  late MockISettlementRemoteDatasource mockDatasource;
  late SettlementRepositoryImpl repository;

  const tSettlementModel = SettlementModel(
    id: 'settlement-1',
    groupId: 'group-1',
    fromUserId: 'user-1',
    fromUserName: 'Mandeep Singh',
    toUserId: 'user-2',
    toUserName: 'Rahul Kumar',
    amount: '500.00',
    currency: 'INR',
    note: 'Paid via UPI',
    status: 'COMPLETED',
    createdAt: '2026-01-01T00:00:00.000Z',
  );

  setUp(() {
    mockDatasource = MockISettlementRemoteDatasource();
    repository = SettlementRepositoryImpl(datasource: mockDatasource);
  });

  group('createSettlement', () {
    test('calls datasource with correctly formatted amount string', () async {
      when(
        () => mockDatasource.createSettlement(
          groupId: 'group-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          amount: any(named: 'amount'),
          currency: 'INR',
          note: 'Paid via UPI',
        ),
      ).thenAnswer((_) async => tSettlementModel);

      await repository.createSettlement(
        groupId: 'group-1',
        fromUserId: 'user-1',
        toUserId: 'user-2',
        amount: 500.0,
        currency: 'INR',
        note: 'Paid via UPI',
      );

      final capturedAmount =
          verify(
                () => mockDatasource.createSettlement(
                  groupId: 'group-1',
                  fromUserId: 'user-1',
                  toUserId: 'user-2',
                  amount: captureAny(named: 'amount'),
                  currency: 'INR',
                  note: 'Paid via UPI',
                ),
              ).captured.first
              as double;

      // The repository forwards the double amount directly to the remote datasource,
      // where the remote datasource serializes it using toStringAsFixed(2) inside the API call.
      // So we expect the repository to pass the double 500.0 to the remote datasource.
      expect(capturedAmount, closeTo(500.0, 0.001));
    });

    test('returns mapped entity on success', () async {
      when(
        () => mockDatasource.createSettlement(
          groupId: 'group-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          amount: 500.0,
          currency: 'INR',
          note: 'Paid via UPI',
        ),
      ).thenAnswer((_) async => tSettlementModel);

      final result = await repository.createSettlement(
        groupId: 'group-1',
        fromUserId: 'user-1',
        toUserId: 'user-2',
        amount: 500.0,
        currency: 'INR',
        note: 'Paid via UPI',
      );

      expect(result.id, 'settlement-1');
      expect(result.amount, closeTo(500.0, 0.001));
    });

    test('note is passed when provided', () async {
      when(
        () => mockDatasource.createSettlement(
          groupId: 'group-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          amount: 500.0,
          currency: 'INR',
          note: 'Custom Note',
        ),
      ).thenAnswer((_) async => tSettlementModel.copyWith(note: 'Custom Note'));

      final result = await repository.createSettlement(
        groupId: 'group-1',
        fromUserId: 'user-1',
        toUserId: 'user-2',
        amount: 500.0,
        currency: 'INR',
        note: 'Custom Note',
      );

      expect(result.note, 'Custom Note');
    });

    test('note is not included in body when null', () async {
      when(
        () => mockDatasource.createSettlement(
          groupId: 'group-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          amount: 500.0,
          currency: 'INR',
          note: null,
        ),
      ).thenAnswer((_) async => tSettlementModel.copyWith(note: null));

      final result = await repository.createSettlement(
        groupId: 'group-1',
        fromUserId: 'user-1',
        toUserId: 'user-2',
        amount: 500.0,
        currency: 'INR',
        note: null,
      );

      expect(result.note, isNull);
      verify(
        () => mockDatasource.createSettlement(
          groupId: 'group-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          amount: 500.0,
          currency: 'INR',
          note: null,
        ),
      ).called(1);
    });
  });

  group('getGroupSettlements', () {
    test('maps list of models to entities', () async {
      when(
        () => mockDatasource.getGroupSettlements(groupId: 'group-1'),
      ).thenAnswer((_) async => [tSettlementModel]);

      final result = await repository.getGroupSettlements(groupId: 'group-1');

      expect(result.length, 1);
      expect(result.first.id, 'settlement-1');
      expect(result.first.amount, closeTo(500.0, 0.001));
    });

    test('parses created_at ISO string to DateTime correctly', () async {
      when(
        () => mockDatasource.getGroupSettlements(groupId: 'group-1'),
      ).thenAnswer((_) async => [tSettlementModel]);

      final result = await repository.getGroupSettlements(groupId: 'group-1');
      expect(
        result.first.createdAt,
        DateTime.parse('2026-01-01T00:00:00.000Z'),
      );
    });

    test('propagates NetworkException without catching', () async {
      when(
        () => mockDatasource.getGroupSettlements(groupId: 'group-1'),
      ).thenThrow(const NetworkException('Remote error'));

      expect(
        () => repository.getGroupSettlements(groupId: 'group-1'),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
