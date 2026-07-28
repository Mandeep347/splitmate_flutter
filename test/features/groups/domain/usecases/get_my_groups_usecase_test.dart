import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/groups/domain/entities/group.dart';
import 'package:splito_flutter/features/groups/domain/entities/group_member.dart';
import 'package:splito_flutter/features/groups/domain/repositories/i_group_repository.dart';
import 'package:splito_flutter/features/groups/domain/usecases/get_my_groups_usecase.dart';

class MockIGroupRepository extends Mock implements IGroupRepository {}

void main() {
  late MockIGroupRepository mockRepository;
  late GetMyGroupsUseCase usecase;

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
    usecase = GetMyGroupsUseCase(repository: mockRepository);
  });

  group('GetMyGroupsUseCase', () {
    test('returns list of groups on success', () async {
      when(
        () => mockRepository.getMyGroups(),
      ).thenAnswer((_) async => [tGroup]);

      final result = await usecase();

      expect(result, equals([tGroup]));
      verify(() => mockRepository.getMyGroups()).called(1);
    });

    test('throws NetworkFailure on NetworkException', () async {
      when(
        () => mockRepository.getMyGroups(),
      ).thenThrow(const NetworkException());

      expect(() => usecase(), throwsA(isA<NetworkFailure>()));
    });

    test('throws UnknownFailure on unexpected exception', () async {
      when(
        () => mockRepository.getMyGroups(),
      ).thenThrow(Exception('unexpected'));

      expect(() => usecase(), throwsA(isA<UnknownFailure>()));
    });

    test('does not re-wrap Failure subclasses', () async {
      when(
        () => mockRepository.getMyGroups(),
      ).thenThrow(const ServerFailure('Already a failure'));

      expect(() => usecase(), throwsA(isA<ServerFailure>()));
    });
  });
}
