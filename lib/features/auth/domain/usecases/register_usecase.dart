import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/logged_in_user.dart';
import '../repositories/auth_repository.dart';

/// Usecase executing the user registration flow.
class RegisterUseCase {
  /// The auth repository dependency.
  final IAuthRepository repository;

  /// Creates a new [RegisterUseCase] instance.
  const RegisterUseCase({
    required this.repository,
  });

  /// Executes registration of a new user.
  /// Throws a [Failure] on error.
  Future<LoggedInUser> call({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      return await repository.register(
        name: name,
        email: email,
        password: password,
      );
    } on UnauthorizedException catch (e) {
      throw AuthFailure(e.message, e.code ?? 'UNAUTHORIZED');
    } on ForbiddenException catch (e) {
      throw AuthFailure(e.message, e.code ?? 'FORBIDDEN');
    } on ConflictException catch (e) {
      throw AuthFailure(e.message, e.code ?? 'USER_ALREADY_EXISTS');
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message, e.code ?? 'NETWORK_ERROR');
    } on ServerException catch (e) {
      throw ServerFailure(e.message, e.code ?? e.statusCode?.toString());
    } on BusinessRuleException catch (e) {
      throw AuthFailure(e.message, e.code ?? 'VALIDATION_ERROR');
    } on NetworkClientException catch (e) {
      throw ServerFailure(e.message, e.code);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
