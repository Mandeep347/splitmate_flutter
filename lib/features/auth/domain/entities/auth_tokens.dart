/// Pure domain entity representing authentication credentials.
class AuthTokens {
  /// The JWT access token used to authenticate requests.
  final String accessToken;

  /// The JWT refresh token used to renew expired access tokens.
  final String refreshToken;

  /// Creates a new [AuthTokens] instance.
  const AuthTokens({required this.accessToken, required this.refreshToken});
}
