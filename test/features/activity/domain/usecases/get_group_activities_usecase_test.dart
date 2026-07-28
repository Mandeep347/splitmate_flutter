import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/activity/domain/entities/activity_feed.dart';
import 'package:splito_flutter/features/activity/domain/repositories/i_activity_repository.dart';
import 'package:splito_flutter/features/activity/domain/usecases/get_group_activities_usecase.dart';

class MockIActivityRepository extends Mock implements IActivityRepository {}

class CustomFailure extends Failure {
  const CustomFailure(super.message);
}

void main() {
  late MockIActivityRepository mockRepository;
  late GetGroupActivitiesUseCase usecase;

  const tFeed = ActivityFeed(
    groupId: 'group-1',
    items: [],
    page: 1,
    limit: 20,
    totalPages: 1,
    totalItems: 0,
  );

  setUp(() {
    mockRepository = MockIActivityRepository();
    usecase = GetGroupActivitiesUseCase(repository: mockRepository);
  });

  group('GetGroupActivitiesUseCase', () {
    test('returns ActivityFeed on success', () async {
      when(
        () => mockRepository.getGroupActivities(
          groupId: 'group-1',
          page: 1,
          limit: 20,
        ),
      ).thenAnswer((_) async => tFeed);

      final result = await usecase(groupId: 'group-1', page: 1, limit: 20);

      expect(result, equals(tFeed));
      verify(
        () => mockRepository.getGroupActivities(
          groupId: 'group-1',
          page: 1,
          limit: 20,
        ),
      ).called(1);
    });

    test('maps NetworkException to NetworkFailure', () async {
      when(
        () => mockRepository.getGroupActivities(
          groupId: 'group-1',
          page: 1,
          limit: 20,
        ),
      ).thenThrow(const NetworkException('No connection'));

      expect(
        () => usecase(groupId: 'group-1', page: 1, limit: 20),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('maps NotFoundException to ServerFailure NOT_FOUND', () async {
      when(
        () => mockRepository.getGroupActivities(
          groupId: 'group-1',
          page: 1,
          limit: 20,
        ),
      ).thenThrow(const NotFoundException('Not found'));

      expect(
        () => usecase(groupId: 'group-1', page: 1, limit: 20),
        throwsA(
          isA<ServerFailure>().having((f) => f.code, 'code', 'NOT_FOUND'),
        ),
      );
    });

    test('does not re-wrap Failure subtypes', () async {
      when(
        () => mockRepository.getGroupActivities(
          groupId: 'group-1',
          page: 1,
          limit: 20,
        ),
      ).thenThrow(const CustomFailure('Cache error'));

      expect(
        () => usecase(groupId: 'group-1', page: 1, limit: 20),
        throwsA(isA<CustomFailure>()),
      );
    });
  });
}
