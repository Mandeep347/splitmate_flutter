import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/activity_feed.dart';
import '../repositories/i_activity_repository.dart';

/// Usecase to fetch paginated activities of a group.
class GetGroupActivitiesUseCase {
  /// The activity repository.
  final IActivityRepository repository;

  /// Creates a new [GetGroupActivitiesUseCase] instance.
  const GetGroupActivitiesUseCase({required this.repository});

  /// Executes the usecase.
  Future<ActivityFeed> call({
    required String groupId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await repository.getGroupActivities(
        groupId: groupId,
        page: page,
        limit: limit,
      );
    } on Failure {
      rethrow;
    } on NotFoundException {
      throw const ServerFailure('Group not found.', 'NOT_FOUND');
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on NetworkClientException catch (e) {
      throw ServerFailure(e.message, e.errorCode);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}

extension on NetworkClientException {
  String? get errorCode {
    if (this is BusinessRuleException) {
      final br = this as BusinessRuleException;
      return br.errors?['code'] as String? ??
          br.errors?['errorCode'] as String?;
    }
    return null;
  }
}
