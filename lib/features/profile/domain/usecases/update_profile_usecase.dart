import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/auth/domain/entities/logged_in_user.dart';
import 'package:splito_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Usecase to handle updating the authenticated user's profile.
class UpdateProfileUseCase {
  /// The authentication repository.
  final IAuthRepository repository;

  /// Creates a new [UpdateProfileUseCase] instance.
  const UpdateProfileUseCase({required this.repository});

  /// Executes the profile update.
  /// Throws a [Failure] on error.
  Future<LoggedInUser> call({String? name, String? preferredCurrency}) async {
    try {
      return await repository.updateMe(
        name: name,
        preferredCurrency: preferredCurrency,
      );
    } on UnauthorizedException catch (e) {
      throw AuthFailure(e.message, 'UNAUTHORIZED');
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message, 'NETWORK_ERROR');
    } on NetworkClientException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
