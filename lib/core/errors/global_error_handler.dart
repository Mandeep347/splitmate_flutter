import 'package:flutter/foundation.dart';
import 'package:splito_flutter/core/logger/crash_reporter.dart';

/// Centralized global error initialization and crash reporting handler.
class GlobalErrorHandler {
  /// Initializes Flutter framework and Dart asynchronous error hooks.
  static void initialize() {
    // Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _report(details.exception, details.stack);
    };

    // Dart async errors outside Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      _report(error, stack);
      return true; // handled
    };
  }

  static void _report(Object error, StackTrace? stack) {
    if (kReleaseMode) {
      const CrashReporter().report(
        error.toString(),
        error: error,
        stackTrace: stack,
      );
    } else {
      debugPrint('ERROR: $error\n$stack');
    }
  }
}
