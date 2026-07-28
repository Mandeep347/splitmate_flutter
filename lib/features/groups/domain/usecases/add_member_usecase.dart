import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/group_member.dart';
import '../repositories/i_group_repository.dart';

/// Usecase to add a new member to a group by their email address.
class AddMemberUseCase {
  /// The groups repository dependency.
  final IGroupRepository repository;

  /// Creates a new [AddMemberUseCase] instance.
  const AddMemberUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<GroupMember> call({
    required String groupId,
    required String email,
  }) async {
    try {
      return await repository.addMember(groupId: groupId, email: email);
    } on Failure {
      rethrow;
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on NotFoundException {
      throw const ServerFailure(
        'No Splito account found with that email.',
        'USER_NOT_FOUND',
      );
    } on ConflictException {
      throw const ServerFailure(
        'This person is already in the group.',
        'USER_ALREADY_IN_GROUP',
      );
    } on NetworkClientException catch (e) {
      throw UnknownFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
