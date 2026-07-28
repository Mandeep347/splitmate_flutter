import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/environment.dart';
import '../../storage/secure_storage_service.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/logging_interceptor.dart';
import '../interceptors/retry_interceptor.dart';

/// Provider for a lightweight, isolated [Dio] client used only for token refreshing.
/// Avoids attaching [AuthInterceptor] to prevent infinite recursive credential-refresh loops.
final refreshDioProvider = Provider<Dio>((ref) {
  final dioClient = Dio(
    BaseOptions(
      baseUrl: AppEnvironment.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dioClient.interceptors.addAll([
    const LoggingInterceptor(),
    RetryInterceptor(dio: dioClient),
  ]);

  return dioClient;
});

/// Main provider for the application's authenticated [Dio] client.
/// Automatically injects JWT keys, retries transient timeouts, and logs debug stats.
final dioProvider = Provider<Dio>((ref) {
  final dioClient = Dio(
    BaseOptions(
      baseUrl: AppEnvironment.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  final secureStorage = ref.watch(secureStorageServiceProvider);
  final refreshDio = ref.watch(refreshDioProvider);

  dioClient.interceptors.addAll([
    AuthInterceptor(secureStorage: secureStorage, refreshDio: refreshDio),
    const LoggingInterceptor(),
    RetryInterceptor(dio: dioClient),
  ]);

  return dioClient;
});
