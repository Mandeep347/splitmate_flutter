import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/group.dart';
import '../repositories/i_group_repository.dart';

/// Usecase to update an existing group details.
class UpdateGroupUseCase {
  /// The groups repository dependency.
  final IGroupRepository repository;

  /// Creates a new [UpdateGroupUseCase] instance.
  const UpdateGroupUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<Group> call({required String groupId, required String name}) async {
    try {
      return await repository.updateGroup(groupId: groupId, name: name);
    } on Failure {
      rethrow;
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ForbiddenException {
      throw const ServerFailure(
        'You do not have permission to update this group.',
        'FORBIDDEN',
      );
    } on NotFoundException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkClientException catch (e) {
      throw UnknownFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
