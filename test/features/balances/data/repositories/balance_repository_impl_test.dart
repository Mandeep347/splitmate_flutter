import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/features/balances/data/datasources/balance_remote_datasource.dart';
import 'package:splito_flutter/features/balances/data/models/group_balances_model.dart';
import 'package:splito_flutter/features/balances/data/models/pairwise_balance_model.dart';
import 'package:splito_flutter/features/balances/data/models/simplified_balances_model.dart';
import 'package:splito_flutter/features/balances/data/repositories/balance_repository_impl.dart';

class MockIBalanceRemoteDatasource extends Mock
    implements IBalanceRemoteDatasource {}

void main() {
  late MockIBalanceRemoteDatasource mockDatasource;
  late BalanceRepositoryImpl repository;

  const tPairwiseModel = PairwiseBalanceModel(
    fromUserId: 'user-1',
    fromUserName: 'Mandeep Singh',
    toUserId: 'user-2',
    toUserName: 'Rahul Kumar',
    amount: '500.00',
    currency: 'INR',
  );

  const tGroupBalancesModel = GroupBalancesModel(
    groupId: 'group-1',
    currency: 'INR',
    balances: [tPairwiseModel],
  );

  const tSimplifiedModel = SimplifiedBalancesModel(
    groupId: 'group-1',
    currency: 'INR',
    transactions: [tPairwiseModel],
  );

  setUp(() {
    mockDatasource = MockIBalanceRemoteDatasource();
    repository = BalanceRepositoryImpl(datasource: mockDatasource);
  });

  group('getGroupBalances', () {
    test('calls datasource and maps to entity', () async {
      when(
        () => mockDatasource.getGroupBalances(groupId: 'group-1'),
      ).thenAnswer((_) async => tGroupBalancesModel);

      final result = await repository.getGroupBalances(groupId: 'group-1');

      expect(result.balances.first.amount, closeTo(500.0, 0.001));
      expect(result.balances.first.fromUserName, 'Mandeep Singh');
      verify(
        () => mockDatasource.getGroupBalances(groupId: 'group-1'),
      ).called(1);
    });

    test('amount string "500.00" parses to double 500.0', () async {
      when(
        () => mockDatasource.getGroupBalances(groupId: 'group-1'),
      ).thenAnswer((_) async => tGroupBalancesModel);

      final result = await repository.getGroupBalances(groupId: 'group-1');
      expect(result.balances.first.amount, 500.0);
    });

    test('propagates NetworkException without catching', () async {
      when(
        () => mockDatasource.getGroupBalances(groupId: 'group-1'),
      ).thenThrow(const NetworkException('Remote error'));

      expect(
        () => repository.getGroupBalances(groupId: 'group-1'),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('getSimplifiedBalances', () {
    test('calls datasource and maps transactions to entities', () async {
      when(
        () => mockDatasource.getSimplifiedBalances(groupId: 'group-1'),
      ).thenAnswer((_) async => tSimplifiedModel);

      final result = await repository.getSimplifiedBalances(groupId: 'group-1');

      expect(result.transactions.first.amount, closeTo(500.0, 0.001));
      expect(result.transactions.first.fromUserName, 'Mandeep Singh');
      expect(result.isAllSettled, isFalse);
      verify(
        () => mockDatasource.getSimplifiedBalances(groupId: 'group-1'),
      ).called(1);
    });

    test('empty transactions list maps to isAllSettled = true', () async {
      const tEmptyModel = SimplifiedBalancesModel(
        groupId: 'group-1',
        currency: 'INR',
        transactions: [],
      );

      when(
        () => mockDatasource.getSimplifiedBalances(groupId: 'group-1'),
      ).thenAnswer((_) async => tEmptyModel);

      final result = await repository.getSimplifiedBalances(groupId: 'group-1');
      expect(result.isAllSettled, isTrue);
      expect(result.transactions.isEmpty, isTrue);
    });
  });
}
