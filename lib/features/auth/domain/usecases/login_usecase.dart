import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

/// Usecase executing the user login flow.
class LoginUseCase {
  /// The auth repository dependency.
  final IAuthRepository repository;

  /// Creates a new [LoginUseCase] instance.
  const LoginUseCase({required this.repository});

  /// Executes the login operation with email and password.
  /// Throws a [Failure] on error.
  Future<AuthTokens> call({
    required String email,
    required String password,
  }) async {
    try {
      return await repository.login(email: email, password: password);
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
