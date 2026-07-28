import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/features/groups/data/datasources/group_local_datasource.dart';
import 'package:splito_flutter/features/groups/data/datasources/group_remote_datasource.dart';
import 'package:splito_flutter/features/groups/data/models/group_model.dart';
import 'package:splito_flutter/features/groups/data/repositories/group_repository_impl.dart';
import 'package:splito_flutter/features/groups/domain/entities/group.dart';
import 'package:splito_flutter/features/groups/domain/entities/group_member.dart';

class MockIGroupRemoteDatasource extends Mock
    implements IGroupRemoteDatasource {}

class MockIGroupLocalDatasource extends Mock implements IGroupLocalDatasource {}

void main() {
  late MockIGroupRemoteDatasource mockRemote;
  late MockIGroupLocalDatasource mockLocal;
  late GroupRepositoryImpl repository;

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

  const tGroupModel = GroupModel(
    id: 'group-1',
    name: 'Goa Trip',
    defaultCurrency: 'INR',
    status: 'ACTIVE',
    createdBy: 'user-1',
    createdAt: '2026-01-01T00:00:00.000Z',
    membersCount: 1,
  );

  setUp(() {
    mockRemote = MockIGroupRemoteDatasource();
    mockLocal = MockIGroupLocalDatasource();
    repository = GroupRepositoryImpl(
      datasource: mockRemote,
      localDatasource: mockLocal,
    );
  });

  group('GroupRepositoryImpl.getMyGroups', () {
    test('fetches from remote, caches, and returns entities', () async {
      when(
        () => mockRemote.getMyGroups(),
      ).thenAnswer((_) async => [tGroupModel]);
      when(
        () => mockLocal.cacheGroups([tGroupModel]),
      ).thenAnswer((_) async => {});

      final result = await repository.getMyGroups();

      expect(result.first.id, equals(tGroup.id));
      verify(() => mockRemote.getMyGroups()).called(1);
      verify(() => mockLocal.cacheGroups([tGroupModel])).called(1);
    });

    test('returns cached data on NetworkException', () async {
      when(() => mockRemote.getMyGroups()).thenThrow(const NetworkException());
      when(
        () => mockLocal.getCachedGroups(),
      ).thenAnswer((_) async => [tGroupModel]);

      final result = await repository.getMyGroups();

      expect(result.first.id, equals(tGroup.id));
      verify(() => mockRemote.getMyGroups()).called(1);
      verify(() => mockLocal.getCachedGroups()).called(1);
    });

    test('throws NetworkException when remote fails and cache empty', () async {
      when(() => mockRemote.getMyGroups()).thenThrow(const NetworkException());
      when(() => mockLocal.getCachedGroups()).thenAnswer((_) async => null);

      expect(() => repository.getMyGroups(), throwsA(isA<NetworkException>()));
    });
  });

  group('GroupRepositoryImpl.getGroupById', () {
    test('fetches from remote and caches single group', () async {
      when(
        () => mockRemote.getGroupById(groupId: 'group-1'),
      ).thenAnswer((_) async => tGroupModel);
      when(() => mockLocal.cacheGroup(tGroupModel)).thenAnswer((_) async => {});

      final result = await repository.getGroupById(groupId: 'group-1');

      expect(result.id, equals(tGroup.id));
      verify(() => mockRemote.getGroupById(groupId: 'group-1')).called(1);
      verify(() => mockLocal.cacheGroup(tGroupModel)).called(1);
    });

    test('returns cached group on NetworkException', () async {
      when(
        () => mockRemote.getGroupById(groupId: 'group-1'),
      ).thenThrow(const NetworkException());
      when(
        () => mockLocal.getCachedGroup('group-1'),
      ).thenAnswer((_) async => tGroupModel);

      final result = await repository.getGroupById(groupId: 'group-1');

      expect(result.id, equals(tGroup.id));
      verify(() => mockRemote.getGroupById(groupId: 'group-1')).called(1);
      verify(() => mockLocal.getCachedGroup('group-1')).called(1);
    });

    test(
      'throws NetworkException when remote fails and no cached group',
      () async {
        when(
          () => mockRemote.getGroupById(groupId: 'group-1'),
        ).thenThrow(const NetworkException());
        when(
          () => mockLocal.getCachedGroup('group-1'),
        ).thenAnswer((_) async => null);

        expect(
          () => repository.getGroupById(groupId: 'group-1'),
          throwsA(isA<NetworkException>()),
        );
      },
    );
  });
}
