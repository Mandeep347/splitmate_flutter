import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/balances/data/repositories/balance_repository_impl.dart';
import 'package:splito_flutter/features/balances/domain/entities/group_balances.dart';
import 'package:splito_flutter/features/balances/domain/entities/pairwise_balance.dart';
import 'package:splito_flutter/features/balances/domain/entities/user_overall_balance.dart';
import 'package:splito_flutter/features/balances/domain/repositories/i_balance_repository.dart';
import 'package:splito_flutter/features/balances/presentation/providers/balance_providers.dart';

class MockIBalanceRepository extends Mock implements IBalanceRepository {}

class FakeMyOverallBalancesNotifier extends MyOverallBalancesNotifier {
  final List<UserOverallBalance>? data;
  final bool isLoading;

  FakeMyOverallBalancesNotifier({this.data, this.isLoading = false});

  @override
  FutureOr<List<UserOverallBalance>> build() {
    if (isLoading) {
      return Completer<List<UserOverallBalance>>().future;
    }
    return data ?? const [];
  }
}

void main() {
  late MockIBalanceRepository mockRepository;
  late ProviderContainer container;

  const tBalance = PairwiseBalance(
    fromUserId: 'user-1',
    fromUserName: 'Mandeep Singh',
    toUserId: 'user-2',
    toUserName: 'Rahul Kumar',
    amount: 500.0,
    currency: 'INR',
  );

  const tGroupBalances = GroupBalances(
    groupId: 'group-1',
    currency: 'INR',
    balances: [tBalance],
  );

  setUp(() {
    mockRepository = MockIBalanceRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('GroupBalancesNotifier', () {
    test('returns GroupBalances on successful build', () async {
      when(
        () => mockRepository.getGroupBalances(groupId: 'group-1'),
      ).thenAnswer((_) async => tGroupBalances);

      container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(true),
          balanceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final result = await container.read(
        groupBalancesProvider('group-1').future,
      );

      expect(result.balances.length, 1);
      expect(result.balances.first.amount, closeTo(500.0, 0.001));
      verify(
        () => mockRepository.getGroupBalances(groupId: 'group-1'),
      ).called(1);
    });

    test('returns empty GroupBalances when not authenticated', () async {
      container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(false),
          balanceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final result = await container.read(
        groupBalancesProvider('group-1').future,
      );

      expect(result.balances.isEmpty, isTrue);
      expect(result.groupId, 'group-1');
      verifyNever(
        () => mockRepository.getGroupBalances(groupId: any(named: 'groupId')),
      );
    });

    test('emits AsyncError when usecase throws', () async {
      when(
        () => mockRepository.getGroupBalances(groupId: 'group-1'),
      ).thenThrow(const NetworkFailure('Network issue'));

      container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(true),
          balanceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      expect(
        () => container.read(groupBalancesProvider('group-1').future),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });

  group('totalOwedProvider', () {
    test('sums youOwe balances correctly', () async {
      const positiveBalance = UserOverallBalance(
        counterpartUserId: 'user-2',
        counterpartName: 'Rahul Kumar',
        netAmount: 500.0, // positive means we owe (youOwe is true)
        currency: 'INR',
      );
      const negativeBalance = UserOverallBalance(
        counterpartUserId: 'user-3',
        counterpartName: 'Raj Singh',
        netAmount: -300.0, // negative means they owe (theyOwe is true)
        currency: 'INR',
      );

      container = ProviderContainer(
        overrides: [
          myOverallBalancesProvider.overrideWith(
            () => FakeMyOverallBalancesNotifier(
              data: const [positiveBalance, negativeBalance],
            ),
          ),
        ],
      );

      final result = container.read(totalOwedProvider);
      expect(result, closeTo(500.0, 0.001));
    });

    test('returns 0.0 when loading', () async {
      container = ProviderContainer(
        overrides: [
          myOverallBalancesProvider.overrideWith(
            () => FakeMyOverallBalancesNotifier(isLoading: true),
          ),
        ],
      );

      final result = container.read(totalOwedProvider);
      expect(result, closeTo(0.0, 0.001));
    });
  });

  group('totalOwedToMeProvider', () {
    test('sums theyOwe balances correctly', () async {
      const positiveBalance = UserOverallBalance(
        counterpartUserId: 'user-2',
        counterpartName: 'Rahul Kumar',
        netAmount: 500.0, // youOwe is true
        currency: 'INR',
      );
      const negativeBalance = UserOverallBalance(
        counterpartUserId: 'user-3',
        counterpartName: 'Raj Singh',
        netAmount: -300.0, // theyOwe is true
        currency: 'INR',
      );

      container = ProviderContainer(
        overrides: [
          myOverallBalancesProvider.overrideWith(
            () => FakeMyOverallBalancesNotifier(
              data: const [positiveBalance, negativeBalance],
            ),
          ),
        ],
      );

      final result = container.read(totalOwedToMeProvider);
      expect(result, closeTo(300.0, 0.001));
    });
  });
}
