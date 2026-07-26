import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/errors/error_handler.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';

/// Generic widget to handle [AsyncValue] states automatically.
class AsyncValueWidget<T> extends StatelessWidget {
  /// The [AsyncValue] state to watch.
  final AsyncValue<T> value;

  /// The builder function to build UI when data is available.
  final Widget Function(T data) data;

  /// Optional override for the loading state widget.
  final Widget Function()? loading;

  /// Optional override for the error state widget.
  final Widget Function(Object error, StackTrace? stackTrace)? error;

  /// Optional callback to retry the async operation on failure.
  final VoidCallback? onRetry;

  /// Creates a const [AsyncValueWidget] instance.
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return value.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: data,
      loading: loading ??
          () => const Center(
                child: CircularProgressIndicator(),
              ),
      error: error ??
          (err, stack) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Something went wrong',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppErrorHandler.toUserMessage(err),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (onRetry != null) ...[
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.refresh_outlined),
                        label: const Text('Try Again'),
                        onPressed: onRetry,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
    );
  }
}
