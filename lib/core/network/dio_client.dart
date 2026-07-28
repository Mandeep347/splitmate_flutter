import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:splito_flutter/core/constants/app_constants.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/storage/token_storage_service.dart';
// Changed: Replace auth_provider import with session_invalidator to avoid inverted dependencies
import 'package:splito_flutter/core/network/session_invalidator.dart';

/// Wrapped network client providing REST API operations with automatic
/// error unwrapping.
///
/// Datasources should call [get], [post], [patch], [delete] instead of
/// accessing [dio] directly. These methods catch the [DioException] produced
/// by the interceptor chain and re-throw the inner typed exception
/// (e.g. [ForbiddenException], [NetworkException]) so that repositories
/// and usecases can catch them with plain `on ForbiddenException` clauses.
class DioClient {
  /// The underlying pre-configured [Dio] client.
  ///
  /// Prefer using the typed helper methods ([get], [post], …) which
  /// automatically unwrap [DioException.error].  Access [dio] directly
  /// only when you need low-level Dio features (e.g. streaming).
  final Dio dio;

  const DioClient(this.dio);

  // ──────────────────────────────────────────────────────────────
  //  Typed helper methods — catch DioException, rethrow inner error
  // ──────────────────────────────────────────────────────────────

  /// Sends a GET request to [path] and unwraps errors.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      _rethrowTyped(e);
    }
  }

  /// Sends a POST request to [path] and unwraps errors.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await dio.post<T>(path, data: data, options: options);
    } on DioException catch (e) {
      _rethrowTyped(e);
    }
  }

  /// Sends a PATCH request to [path] and unwraps errors.
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await dio.patch<T>(path, data: data, options: options);
    } on DioException catch (e) {
      _rethrowTyped(e);
    }
  }

  /// Sends a DELETE request to [path] and unwraps errors.
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await dio.delete<T>(path, data: data, options: options);
    } on DioException catch (e) {
      _rethrowTyped(e);
    }
  }

  /// Extracts the typed exception stored in [DioException.error] by the
  /// [_ErrorInterceptor] and rethrows it.  Falls back to rethrowing the
  /// original [DioException] when no inner error is present.
  Never _rethrowTyped(DioException e) {
    final inner = e.error;
    if (inner is Exception) throw inner;
    throw e;
  }
}

/// Interceptor to automatically inject JWT access tokens and run transparent token refreshes.
class _AuthInterceptor extends QueuedInterceptor {
  final Ref _ref;
  final Dio _refreshDio;

  _AuthInterceptor(this._ref)
    : _refreshDio = Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrl,
          connectTimeout: Duration(milliseconds: AppConstants.connectTimeoutMs),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeoutMs),
        ),
      );

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Changed: Added refresh endpoints to auth route skip list to prevent recursive auth interceptor loops
    if (options.path == ApiEndpoints.login ||
        options.path == ApiEndpoints.register ||
        options.path == ApiEndpoints.refresh) {
      return handler.next(options);
    }

    // Wrapped in try-catch: if token read fails for any reason (e.g.
    // OperationError on emulators), we still call handler.next() so the
    // Dio request doesn't hang forever. The request proceeds without
    // an Authorization header — the server will return 401 which is
    // handled normally by the error interceptor / refresh flow.
    try {
      final tokenStorage = _ref.read(tokenStorageServiceProvider);
      final accessToken = await tokenStorage.getAccessToken();

      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    } catch (e) {
      // ignore: avoid_print
      debugPrint('Warning: Failed to read access token in interceptor: $e');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    if (response != null &&
        response.statusCode == 401 &&
        err.requestOptions.path != ApiEndpoints.refresh &&
        err.requestOptions.path != ApiEndpoints.login &&
        err.requestOptions.path != ApiEndpoints.register) {
      try {
        final tokenStorage = _ref.read(tokenStorageServiceProvider);
        final refreshToken = await tokenStorage.getRefreshToken();
        if (refreshToken != null) {
          try {
            final refreshResponse = await _refreshDio.post<dynamic>(
              ApiEndpoints.refresh,
              data: {'refresh_token': refreshToken},
            );
            if (refreshResponse.statusCode == 200 ||
                refreshResponse.statusCode == 201) {
              final data = refreshResponse.data as Map<String, dynamic>;
              final newAccessToken = data['access_token'] as String;
              final newRefreshToken =
                  data['refresh_token'] as String? ?? refreshToken;
              await tokenStorage.saveTokens(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
              );
              final options = err.requestOptions;
              options.headers['Authorization'] = 'Bearer $newAccessToken';
              final dio = _ref.read(_rawDioProvider);
              final retryResponse = await dio.fetch<dynamic>(options);
              return handler.resolve(retryResponse);
            }
          } catch (e) {
            // Token refresh failed — expire the session.
            await tokenStorage.clearTokens();
            // Changed: replaced _ref.invalidate(authProvider) with
            // sessionExpiredCallbackProvider to remove the dependency
            // from core/network on features/auth/presentation.
            _ref.read(sessionExpiredCallbackProvider)?.call();
          }
        } else {
          await tokenStorage.clearTokens();
          // Changed: replaced _ref.invalidate(authProvider) with
          // sessionExpiredCallbackProvider to remove the dependency
          // from core/network on features/auth/presentation.
          _ref.read(sessionExpiredCallbackProvider)?.call();
        }
      } catch (e) {
        // ignore: avoid_print
        debugPrint('Warning: Token storage error during 401 handling: $e');
        // Changed: replaced _ref.invalidate(authProvider) with
        // sessionExpiredCallbackProvider to remove the dependency
        // from core/network on features/auth/presentation.
        _ref.read(sessionExpiredCallbackProvider)?.call();
      }
    }
    return handler.next(err);
  }
}

/// Interceptor to map network and backend status codes to structured exceptions.
///
/// Stores typed exceptions (e.g. [UnauthorizedException], [ForbiddenException])
/// inside [DioException.error] via [handler.next].  The [DioClient] wrapper
/// methods then unwrap these so callers receive the raw typed exception.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.badResponse) {
      final response = err.response;
      final statusCode = response?.statusCode;
      final data = response?.data;

      final messageVal = data is Map<String, dynamic> ? data['message'] : null;
      final detailVal = data is Map<String, dynamic> ? data['detail'] : null;
      final codeVal = data is Map<String, dynamic> ? data['code'] : null;
      final errorVal = data is Map<String, dynamic> ? data['error'] : null;
      final String? code = (codeVal is String && codeVal.isNotEmpty)
          ? codeVal
          : (errorVal is String && errorVal.isNotEmpty ? errorVal : null);

      String message = 'An HTTP error occurred';
      if (messageVal is String) {
        message = messageVal;
      } else if (detailVal is String) {
        message = detailVal;
      } else if (detailVal is List && detailVal.isNotEmpty) {
        final first = detailVal.first;
        if (first is String) {
          message = first;
        } else if (first is Map && first.containsKey('msg')) {
          message = first['msg']?.toString() ?? message;
        } else {
          message = detailVal.toString();
        }
      } else if (detailVal != null) {
        message = detailVal.toString();
      }

      switch (statusCode) {
        case 401:
          return handler.next(
            err.copyWith(error: UnauthorizedException(message, code)),
          );
        case 403:
          return handler.next(
            err.copyWith(error: ForbiddenException(message, code)),
          );
        case 404:
          return handler.next(
            err.copyWith(error: NotFoundException(message, code)),
          );
        case 409:
          return handler.next(
            err.copyWith(error: ConflictException(message, code)),
          );
        case 422:
          final errors = data is Map<String, dynamic>
              ? data['errors'] as Map<String, dynamic>?
              : null;
          return handler.next(
            err.copyWith(
              error: BusinessRuleException(
                message: message,
                code: code,
                errors: errors,
              ),
            ),
          );
        default:
          return handler.next(
            err.copyWith(
              error: ServerException(
                message: message,
                code: code,
                statusCode: statusCode,
              ),
            ),
          );
      }
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return handler.next(
        err.copyWith(
          error: const NetworkException(
            'Connection timed out or network error occurred.',
          ),
        ),
      );
    }

    return handler.next(err);
  }
}

/// Internal provider exposing raw pre-configured Dio instance.
final _rawDioProvider = Provider<Dio>((ref) {
  // Dio must persist for the app lifetime — requests in-flight
  // must not be orphaned by provider disposal during navigation.
  ref.keepAlive();
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: Duration(milliseconds: AppConstants.connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeoutMs),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    _AuthInterceptor(ref),
    _ErrorInterceptor(),
    // Changed: Conditionally add PrettyDioLogger in debug mode to prevent leaking tokens or data in production environments
    if (kDebugMode)
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
  ]);

  return dio;
});

/// Provider exposing pre-configured [DioClient] instance.
final dioClientProvider = Provider<DioClient>((ref) {
  final dio = ref.watch(_rawDioProvider);
  return DioClient(dio);
});
