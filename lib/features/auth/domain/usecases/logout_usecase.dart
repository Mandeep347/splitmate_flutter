import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Usecase executing the user logout sequence.
class LogoutUseCase {
  /// The auth repository dependency.
  final IAuthRepository repository;

  /// Creates a new [LogoutUseCase] instance.
  const LogoutUseCase({required this.repository});

  /// Executes logout, purging local credentials and remote sessions.
  /// Throws a [Failure] on error.
  Future<void> call() async {
    try {
      await repository.logout();
    } on NetworkClientException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
