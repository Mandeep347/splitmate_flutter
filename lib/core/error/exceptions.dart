/// Base class for all domain-specific internal application exceptions.
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when backend server returns status codes outside the 2xx range.
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(super.message, {this.statusCode});
}

/// Thrown when a transient network connection drop occurs (no DNS, timeout, socket error).
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Thrown when a local database read/write operation fails (Hive box corrupt/missing).
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Thrown when request payload fields fail API validation requirements (e.g. 422 Unprocessable Entity).
class ValidationException extends AppException {
  final Map<String, List<String>> errors;

  const ValidationException(super.message, {required this.errors});
}
