/// Base class for all remote HTTP or network client exceptions.
abstract class NetworkClientException implements Exception {
  /// User-friendly explanation of the exception.
  final String message;

  /// Optional error code categorizing the fault.
  final String? code;

  /// Creates a const [NetworkClientException] instance.
  const NetworkClientException(this.message, [this.code]);

  @override
  String toString() => '$runtimeType: $message (code: $code)';
}

/// Thrown when credentials are invalid or the authentication session has expired (HTTP 401).
class UnauthorizedException extends NetworkClientException {
  /// Creates a const [UnauthorizedException] instance.
  const UnauthorizedException([
    super.message = 'Unauthorized access. Please login again.',
    super.code,
  ]);
}

/// Thrown when the authenticated user does not have permission for the requested action (HTTP 403).
class ForbiddenException extends NetworkClientException {
  /// Creates a const [ForbiddenException] instance.
  const ForbiddenException([
    super.message =
        'Access denied. You do not have permissions for this action.',
    super.code,
  ]);
}

/// Thrown when the requested resource is not found on the backend (HTTP 404).
class NotFoundException extends NetworkClientException {
  /// Creates a const [NotFoundException] instance.
  const NotFoundException([
    super.message = 'Requested resource not found.',
    super.code,
  ]);
}

/// Thrown when a conflict state occurs on the database or resource (HTTP 409).
class ConflictException extends NetworkClientException {
  /// Creates a const [ConflictException] instance.
  const ConflictException([
    super.message = 'Resource conflict occurred.',
    super.code,
  ]);
}

/// Thrown when request payload fails validation or violates rules (HTTP 422).
class BusinessRuleException extends NetworkClientException {
  /// Validation errors map.
  final Map<String, dynamic>? errors;

  /// Creates a const [BusinessRuleException] instance.
  const BusinessRuleException({
    String message = 'Validation and business rule check failed.',
    String? code,
    this.errors,
  }) : super(message, code);
}

/// Thrown when the server reports internal faults (HTTP 500 range, or general 4xx exception).
class ServerException extends NetworkClientException {
  /// HTTP status code.
  final int? statusCode;

  /// Creates a const [ServerException] instance.
  const ServerException({
    required String message,
    String? code,
    this.statusCode,
  }) : super(message, code);
}

/// Thrown when socket connection drops or timeouts occur.
class NetworkException extends NetworkClientException {
  /// Creates a const [NetworkException] instance.
  const NetworkException([
    super.message = 'Network connection failed. Please check your internet.',
    super.code,
  ]);
}
