/// Base class for all domain failures. Failures are immutable and used
/// in the presentation layer to display user-friendly error messages.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Represents failures returned by backend services (API errors).
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode});
}

/// Represents failures caused by network issues (no internet connection).
class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

/// Represents local storage reading or writing failures.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Represents user form or API payload field-validation failures.
class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  const ValidationFailure(super.message, {required this.errors});
}
