import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/logger/app_logger.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/groups/data/datasources/group_local_datasource.dart';
import 'package:splito_flutter/features/groups/data/repositories/group_repository_impl.dart';
import 'package:splito_flutter/features/groups/domain/entities/group.dart';
import 'package:splito_flutter/features/groups/domain/entities/group_member.dart';
import 'package:splito_flutter/features/groups/domain/repositories/i_group_repository.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';

class MockIGroupRepository extends Mock implements IGroupRepository {}

class MockIGroupLocalDatasource extends Mock implements IGroupLocalDatasource {}

class MockILogger extends Mock implements ILogger {}

void main() {
  late MockIGroupRepository mockRepository;
  late MockIGroupLocalDatasource mockLocalDatasource;
  late MockILogger mockLogger;
  late ProviderContainer container;

  final tGroupMember = GroupMember(
    userId: 'user-1',
    name: 'Mandeep Singh',
    email: 'mandeep@test.com',
    role: 'ADMIN',
    status: 'ACTIVE',
    joinedAt: DateTime(2026, 1, 1),
  );

  final tGroup = Group(
    id: 'group-1',
    name: 'Goa Trip',
    defaultCurrency: 'INR',
    status: 'ACTIVE',
    createdBy: 'user-1',
    createdAt: DateTime(2026, 1, 1),
    membersCount: 1,
    members: [tGroupMember],
  );

  setUp(() {
    mockRepository = MockIGroupRepository();
    mockLocalDatasource = MockIGroupLocalDatasource();
    mockLogger = MockILogger();

    // Stub local datasource groups cache get to prevent type errors on null fallback triggers
    when(
      () => mockLocalDatasource.getCachedGroups(),
    ).thenAnswer((_) async => null);

    container = ProviderContainer(
      overrides: [
        // Simulate authenticated state so MyGroupsNotifier.build() proceeds
        // to call the usecase instead of short-circuiting with [].
        authStateProvider.overrideWithValue(true),
        groupRepositoryProvider.overrideWithValue(mockRepository),
        groupLocalDatasourceProvider.overrideWithValue(mockLocalDatasource),
        loggerProvider.overrideWithValue(mockLogger),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('MyGroupsNotifier', () {
    test('emits AsyncData with groups list on successful build', () async {
      when(
        () => mockRepository.getMyGroups(),
      ).thenAnswer((_) async => [tGroup]);

      final result = await container.read(myGroupsProvider.future);

      expect(result, equals([tGroup]));
      verify(() => mockRepository.getMyGroups()).called(1);
    });

    test('emits AsyncError when usecase throws Failure', () async {
      when(
        () => mockRepository.getMyGroups(),
      ).thenThrow(const NetworkFailure('No Internet'));

      expect(
        () => container.read(myGroupsProvider.future),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('refresh() rebuilds provider', () async {
      when(
        () => mockRepository.getMyGroups(),
      ).thenAnswer((_) async => [tGroup]);

      // Listen to the provider to keep it active and rebuild immediately upon invalidation
      container.listen(myGroupsProvider, (_, __) {});

      // Initial load
      await container.read(myGroupsProvider.future);
      verify(() => mockRepository.getMyGroups()).called(1);

      // Trigger refresh
      container.read(myGroupsProvider.notifier).refresh();

      // Await the new future
      await container.read(myGroupsProvider.future);
      verify(() => mockRepository.getMyGroups()).called(1);
    });
  });
}
