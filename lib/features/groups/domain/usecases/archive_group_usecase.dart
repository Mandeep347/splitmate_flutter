import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/group.dart';
import '../repositories/i_group_repository.dart';

/// Usecase to archive an active group.
class ArchiveGroupUseCase {
  /// The groups repository dependency.
  final IGroupRepository repository;

  /// Creates a new [ArchiveGroupUseCase] instance.
  const ArchiveGroupUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<Group> call({required String groupId}) async {
    try {
      return await repository.archiveGroup(groupId: groupId);
    } on Failure {
      rethrow;
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ForbiddenException catch (e) {
      throw ServerFailure(e.message, 'FORBIDDEN');
    } on NotFoundException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkClientException catch (e) {
      throw UnknownFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
