import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/groups/domain/repositories/i_group_repository.dart';
import 'package:splito_flutter/features/groups/domain/usecases/remove_member_usecase.dart';

class MockIGroupRepository extends Mock implements IGroupRepository {}

void main() {
  late MockIGroupRepository mockRepository;
  late RemoveMemberUseCase usecase;

  setUp(() {
    mockRepository = MockIGroupRepository();
    usecase = RemoveMemberUseCase(repository: mockRepository);
  });

  group('RemoveMemberUseCase', () {
    test('completes without error on success', () async {
      when(
        () => mockRepository.removeMember(groupId: 'group-1', userId: 'user-2'),
      ).thenAnswer((_) async => {});

      await usecase(groupId: 'group-1', userId: 'user-2');

      verify(
        () => mockRepository.removeMember(groupId: 'group-1', userId: 'user-2'),
      ).called(1);
    });

    test('throws BusinessRuleFailure on BusinessRuleException', () async {
      const exception = BusinessRuleException(
        message: 'Cannot remove this member.',
        errors: {'code': 'RULE_VIOLATION'},
      );

      when(
        () => mockRepository.removeMember(groupId: 'group-1', userId: 'user-2'),
      ).thenThrow(exception);

      expect(
        () => usecase(groupId: 'group-1', userId: 'user-2'),
        throwsA(
          isA<BusinessRuleFailure>().having(
            (f) => f.fieldErrors,
            'fieldErrors',
            exception.errors,
          ),
        ),
      );
    });

    test('throws ServerFailure with FORBIDDEN on ForbiddenException', () async {
      when(
        () => mockRepository.removeMember(groupId: 'group-1', userId: 'user-2'),
      ).thenThrow(const ForbiddenException('Forbidden action.'));

      expect(
        () => usecase(groupId: 'group-1', userId: 'user-2'),
        throwsA(
          isA<ServerFailure>().having((f) => f.code, 'code', 'FORBIDDEN'),
        ),
      );
    });
  });
}
