import 'package:splito_flutter/core/errors/failures.dart';

/// Centralized utility class to map domain failures to user-friendly strings.
class AppErrorHandler {
  const AppErrorHandler._();

  /// Maps an error/failure to a user-friendly string message.
  static String toUserMessage(Object? error) {
    if (error == null) {
      return 'An unexpected error occurred.';
    }
    if (error is Failure) {
      final code = error.code?.toUpperCase();
      final msg = error.message.toLowerCase();

      if (code == 'USER_ALREADY_EXISTS' ||
          msg.contains('already registered') ||
          msg.contains('already exists')) {
        return 'User already registered';
      }
      if (code == 'EMAIL_NOT_VERIFIED' || msg.contains('verify your email')) {
        return 'Please verify your email address before logging in.';
      }
      if (code == 'INVALID_TOKEN') {
        return 'This link has expired or has already been used.';
      }
    }
    if (error is AuthFailure) {
      final code = error.code?.toUpperCase();
      if (code == 'USER_ALREADY_EXISTS') {
        return 'User already registered';
      }
      if (code == 'UNAUTHORIZED') {
        return error.message.isNotEmpty && error.message != 'An HTTP error occurred'
            ? error.message
            : 'Incorrect email or password.';
      }
      return error.message.isNotEmpty ? error.message : 'Authentication failed.';
    }
    if (error is NetworkFailure) {
      return 'No internet connection. Please try again.';
    }
    if (error is ServerFailure) {
      final code = error.code?.toUpperCase();
      if (code == 'USER_ALREADY_EXISTS') {
        return 'User already registered';
      }
      if (code == 'VALIDATION_ERROR') {
        return error.message;
      }
      return error.message.isNotEmpty && error.message != 'An HTTP error occurred'
          ? error.message
          : 'Something went wrong. Please try again.';
    }
    if (error is UnknownFailure) {
      return 'An unexpected error occurred.';
    }
    if (error is Failure) {
      return error.message.isNotEmpty ? error.message : 'An unexpected error occurred.';
    }
    return 'An unexpected error occurred.';
  }
}
