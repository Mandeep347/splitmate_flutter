import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/group.dart';
import '../repositories/i_group_repository.dart';

/// Usecase to retrieve all groups associated with the current user session.
class GetMyGroupsUseCase {
  /// The groups repository dependency.
  final IGroupRepository repository;

  /// Creates a new [GetMyGroupsUseCase] instance.
  const GetMyGroupsUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<List<Group>> call() async {
    try {
      return await repository.getMyGroups();
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
