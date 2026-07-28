import 'dart:io';
import 'package:dio/dio.dart';

/// Interceptor that automatically retries failed network operations
/// when transient problems occur (e.g. timeouts, offline drops, SocketExceptions).
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration initialDelay;

  const RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final extra = requestOptions.extra;

    // Track retry count in the request metadata
    var retryCount = extra['retry_count'] as int? ?? 0;

    // Check if error is transient and we haven't reached limits
    final isTransient =
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.error is SocketException);

    if (isTransient && retryCount < maxRetries) {
      retryCount++;
      extra['retry_count'] = retryCount;

      // Calculate exponential backoff delay (1s, 2s, 3s...)
      final delay = initialDelay * retryCount;
      await Future<void>.delayed(delay);

      try {
        // Re-execute request
        final response = await dio.fetch<dynamic>(requestOptions);
        return handler.resolve(response);
      } on DioException catch (newErr) {
        // Forward nested failures to trigger subsequent retry attempts
        return super.onError(newErr, handler);
      }
    }

    super.onError(err, handler);
  }
}
