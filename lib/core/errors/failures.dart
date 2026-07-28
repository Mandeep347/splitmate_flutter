/// Base class for all domain-level failures returned or thrown by usecases.
abstract class Failure {
  /// User-friendly message explaining the error.
  final String message;

  /// Optional error code categorizing the fault.
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  String toString() => '$runtimeType: $message (code: $code)';
}

/// Returned when authentication or authorization operations fail (e.g. invalid credentials).
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.code]);
}

/// Returned when transient connection or network timeout issues occur.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.code]);
}

/// Returned when the remote server returns internal faults or general HTTP errors.
class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.code]);
}

// Added BusinessRuleFailure to represent business violations (HTTP 422) for UI pattern-matching
/// Returned when the backend rejects a request due to a business
/// rule violation (HTTP 422). Carries the machine-readable [code]
/// from the API error response and optional [fieldErrors] map.
class BusinessRuleFailure extends Failure {
  final Map<String, dynamic>? fieldErrors;
  const BusinessRuleFailure(super.message, [super.code, this.fieldErrors]);
}

/// Fallback failure when an unhandled or unknown exception is caught.
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.code]);
}
