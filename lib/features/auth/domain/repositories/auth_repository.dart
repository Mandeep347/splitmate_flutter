import '../entities/auth_tokens.dart';
import '../entities/logged_in_user.dart';

/// Abstract contract defining authentication repository operations.
abstract interface class IAuthRepository {
  /// Authenticates user credentials and returns JWT credentials.
  Future<AuthTokens> login({required String email, required String password});

  /// Registers a new user account profile.
  Future<LoggedInUser> register({
    required String name,
    required String email,
    required String password,
  });

  /// Renews an expired access token using a refresh token.
  Future<AuthTokens> refreshTokens({required String refreshToken});

  /// Fetches details of the currently authenticated user.
  Future<LoggedInUser> getMe();

  /// Logs out the user and clears all cached data.
  Future<void> logout();

  /// Checks if the user is authenticated (e.g. holds valid session keys).
  Future<bool> isAuthenticated();

  /// Updates details of the currently authenticated user profile.
  Future<LoggedInUser> updateMe({String? name, String? preferredCurrency});

  /// Verifies user email address.
  Future<void> verifyEmail({required String token});

  /// Resends verification email.
  Future<void> resendVerification({required String email});

  /// Requests a password reset email.
  Future<void> forgotPassword({required String email});

  /// Resets user password using a token.
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });
}
