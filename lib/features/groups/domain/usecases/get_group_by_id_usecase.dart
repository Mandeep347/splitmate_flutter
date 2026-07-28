import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/group.dart';
import '../repositories/i_group_repository.dart';

/// Usecase to retrieve detailed group profile records.
class GetGroupByIdUseCase {
  /// The groups repository dependency.
  final IGroupRepository repository;

  /// Creates a new [GetGroupByIdUseCase] instance.
  const GetGroupByIdUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<Group> call({required String groupId}) async {
    try {
      return await repository.getGroupById(groupId: groupId);
    } on Failure {
      rethrow;
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on NotFoundException {
      throw const ServerFailure('Group not found.');
    } on NetworkClientException catch (e) {
      throw UnknownFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
