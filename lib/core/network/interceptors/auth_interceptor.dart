import 'package:dio/dio.dart';
import '../../constants/storage_keys.dart';
import '../../storage/secure_storage_service.dart';

/// Interceptor that attaches the OAuth Bearer Access Token to all outgoing requests.
/// Performs automatic JWT Refresh Token flow if a 401 Unauthorized status is returned.
class AuthInterceptor extends Interceptor {
  final ISecureStorageService secureStorage;
  final Dio refreshDio;

  const AuthInterceptor({
    required this.secureStorage,
    required this.refreshDio,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // If the request already has an Authorization header, don't overwrite it
    if (!options.headers.containsKey('Authorization')) {
      final accessToken = await secureStorage.read(
        StorageKeys.secureAccessToken,
      );
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error is 401 Unauthorized (invalid/expired access token)
    if (err.response?.statusCode == 401) {
      final refreshToken = await secureStorage.read(
        StorageKeys.secureRefreshToken,
      );

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Call the refresh API route using the clean refresh-only Dio instance
          final response = await refreshDio.post<dynamic>(
            '/auth/refresh',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200 && response.data != null) {
            final payload = response.data as Map<String, dynamic>;
            final newAccessToken = payload['access_token'] as String;
            final newRefreshToken = payload['refresh_token'] as String;

            // Cache the fresh tokens
            await secureStorage.write(
              StorageKeys.secureAccessToken,
              newAccessToken,
            );
            await secureStorage.write(
              StorageKeys.secureRefreshToken,
              newRefreshToken,
            );

            // Re-attempt original request with the fresh token
            final requestOptions = err.requestOptions;
            requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            // Create temporary client to retry
            final retryDio = Dio(BaseOptions(baseUrl: requestOptions.baseUrl));
            final retryResponse = await retryDio.fetch<dynamic>(requestOptions);

            return handler.resolve(retryResponse);
          }
        } catch (_) {
          // Token refresh failed (refresh token expired/revoked) -> Wipe credentials to force log in
          await secureStorage.delete(StorageKeys.secureAccessToken);
          await secureStorage.delete(StorageKeys.secureRefreshToken);
        }
      }
    }
    super.onError(err, handler);
  }
}
