import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/groups/domain/entities/group_member.dart';
import 'package:splito_flutter/features/groups/domain/repositories/i_group_repository.dart';
import 'package:splito_flutter/features/groups/domain/usecases/add_member_usecase.dart';

class MockIGroupRepository extends Mock implements IGroupRepository {}

void main() {
  late MockIGroupRepository mockRepository;
  late AddMemberUseCase usecase;

  final tGroupMember = GroupMember(
    userId: 'user-1',
    name: 'Mandeep Singh',
    email: 'mandeep@test.com',
    role: 'ADMIN',
    status: 'ACTIVE',
    joinedAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    mockRepository = MockIGroupRepository();
    usecase = AddMemberUseCase(repository: mockRepository);
  });

  group('AddMemberUseCase', () {
    test('returns GroupMember on success', () async {
      when(
        () => mockRepository.addMember(
          groupId: 'group-1',
          email: 'mandeep@test.com',
        ),
      ).thenAnswer((_) async => tGroupMember);

      final result = await usecase(
        groupId: 'group-1',
        email: 'mandeep@test.com',
      );

      expect(result, equals(tGroupMember));
      verify(
        () => mockRepository.addMember(
          groupId: 'group-1',
          email: 'mandeep@test.com',
        ),
      ).called(1);
    });

    test(
      'throws ServerFailure with USER_NOT_FOUND on NotFoundException',
      () async {
        when(
          () => mockRepository.addMember(
            groupId: 'group-1',
            email: 'mandeep@test.com',
          ),
        ).thenThrow(const NotFoundException());

        expect(
          () => usecase(groupId: 'group-1', email: 'mandeep@test.com'),
          throwsA(
            isA<ServerFailure>().having(
              (f) => f.code,
              'code',
              'USER_NOT_FOUND',
            ),
          ),
        );
      },
    );

    test(
      'throws ServerFailure with USER_ALREADY_IN_GROUP on ConflictException',
      () async {
        when(
          () => mockRepository.addMember(
            groupId: 'group-1',
            email: 'mandeep@test.com',
          ),
        ).thenThrow(const ConflictException());

        expect(
          () => usecase(groupId: 'group-1', email: 'mandeep@test.com'),
          throwsA(
            isA<ServerFailure>().having(
              (f) => f.code,
              'code',
              'USER_ALREADY_IN_GROUP',
            ),
          ),
        );
      },
    );

    test('throws NetworkFailure on NetworkException', () async {
      when(
        () => mockRepository.addMember(
          groupId: 'group-1',
          email: 'mandeep@test.com',
        ),
      ).thenThrow(const NetworkException());

      expect(
        () => usecase(groupId: 'group-1', email: 'mandeep@test.com'),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });
}
