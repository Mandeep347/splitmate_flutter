import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../repositories/i_group_repository.dart';

/// Usecase to remove a member from a group.
class RemoveMemberUseCase {
  /// The groups repository dependency.
  final IGroupRepository repository;

  /// Creates a new [RemoveMemberUseCase] instance.
  const RemoveMemberUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<void> call({required String groupId, required String userId}) async {
    try {
      await repository.removeMember(groupId: groupId, userId: userId);
    } on Failure {
      rethrow;
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on BusinessRuleException catch (e) {
      throw BusinessRuleFailure(e.message, null, e.errors);
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
