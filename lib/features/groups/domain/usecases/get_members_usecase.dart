import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/group_member.dart';
import '../repositories/i_group_repository.dart';

/// Usecase to retrieve all members associated with a group.
class GetMembersUseCase {
  /// The groups repository dependency.
  final IGroupRepository repository;

  /// Creates a new [GetMembersUseCase] instance.
  const GetMembersUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<List<GroupMember>> call({required String groupId}) async {
    try {
      return await repository.getMembers(groupId: groupId);
    } on Failure {
      rethrow;
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on NotFoundException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkClientException catch (e) {
      throw UnknownFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
