import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

/// Custom network traffic logging interceptor for Splito.
/// Formats request and response data, suppressing outputs in production mode.
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('--> HTTP ${options.method} ${options.uri}');
      if (options.headers.isNotEmpty) {
        debugPrint('Headers: ${options.headers}');
      }
      if (options.data != null) {
        debugPrint('Body: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(
        '<-- HTTP ${response.statusCode} ${response.requestOptions.uri}',
      );
      debugPrint('Response Body: ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '<-- HTTP ERROR [${err.response?.statusCode}] ${err.requestOptions.uri}',
      );
      debugPrint('Error Message: ${err.message}');
      if (err.response?.data != null) {
        debugPrint('Error Body: ${err.response?.data}');
      }
    }
    super.onError(err, handler);
  }
}
