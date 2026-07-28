import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'crash_reporter.dart';

/// Levels of logging details.
enum LogLevel { debug, info, warning, error }

/// Abstract contract for logging across the application.
abstract class ILogger {
  /// Logs diagnostic information for developers.
  void debug(String message);

  /// Logs informational notices.
  void info(String message);

  /// Logs non-fatal warning messages.
  void warning(String message);

  /// Logs severe exceptions and error details.
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, String>? context,
  });
}

/// Production implementation of [ILogger].
/// Prints pretty-formatted console outputs in debug builds, and routes errors to remote trackers in release mode.
class AppLogger implements ILogger {
  final ICrashReporter _crashReporter;

  const AppLogger(this._crashReporter);

  @override
  void debug(String message) {
    _printLog(LogLevel.debug, message);
  }

  @override
  void info(String message) {
    _printLog(LogLevel.info, message);
  }

  @override
  void warning(String message) {
    _printLog(LogLevel.warning, message);
  }

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, String>? context,
  }) {
    _printLog(
      LogLevel.error,
      message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );

    // In production/release builds, forward severe errors to the remote reporter
    if (kReleaseMode) {
      _crashReporter.report(
        message,
        error: error,
        stackTrace: stackTrace,
        context: context,
      );
    }
  }

  /// Formats and outputs logs to terminal in debug mode.
  void _printLog(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, String>? context,
  }) {
    if (!kReleaseMode) {
      final emoji = _getEmoji(level);
      final timestamp = DateTime.now().toIso8601String();
      final tag = level.name.toUpperCase();

      final buffer = StringBuffer()
        ..write('$emoji [$timestamp] [$tag]: $message');

      if (context != null && context.isNotEmpty) {
        final sensitiveKeys = {
          'password',
          'token',
          'authorization',
          'secret',
          'refresh',
        };
        final sanitized = context.map(
          (k, v) => MapEntry(
            k,
            sensitiveKeys.any((s) => k.toLowerCase().contains(s)) ? '***' : v,
          ),
        );
        buffer.write('\nContext: $sanitized');
      }
      if (error != null) {
        buffer.write('\nError Detail: $error');
      }
      if (stackTrace != null) {
        buffer.write('\nStackTrace:\n$stackTrace');
      }

      debugPrint(buffer.toString());
    }
  }

  /// Resolves graphical emojis to visually represent log severities in developer consoles.
  String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return '💡';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }
}

/// Provider for [ILogger] interface.
final loggerProvider = Provider<ILogger>((ref) {
  final crashReporter = ref.watch(crashReporterProvider);
  return AppLogger(crashReporter);
});
