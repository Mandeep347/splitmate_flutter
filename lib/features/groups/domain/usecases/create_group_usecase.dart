import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/group.dart';
import '../repositories/i_group_repository.dart';

/// Usecase to create a new group.
class CreateGroupUseCase {
  /// The groups repository dependency.
  final IGroupRepository repository;

  /// Creates a new [CreateGroupUseCase] instance.
  const CreateGroupUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<Group> call({required String name, required String currency}) async {
    try {
      return await repository.createGroup(name: name, currency: currency);
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
