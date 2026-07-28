import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/logged_in_user.dart';
import '../repositories/auth_repository.dart';

/// Usecase retrieving the active user's details.
class GetMeUseCase {
  /// The auth repository dependency.
  final IAuthRepository repository;

  /// Creates a new [GetMeUseCase] instance.
  const GetMeUseCase({required this.repository});

  /// Retrieves user profile details.
  /// Throws a [Failure] on error.
  Future<LoggedInUser> call() async {
    try {
      return await repository.getMe();
    } on UnauthorizedException catch (e) {
      throw AuthFailure(e.message, 'UNAUTHORIZED');
    } on ForbiddenException catch (e) {
      throw AuthFailure(e.message, 'FORBIDDEN');
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message, 'NETWORK_ERROR');
    } on ServerException catch (e) {
      throw ServerFailure(e.message, e.statusCode?.toString());
    } on NetworkClientException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
