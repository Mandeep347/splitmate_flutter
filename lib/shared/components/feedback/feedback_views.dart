import 'package:flutter/material.dart';
import '../buttons/app_buttons.dart';
import '../utils/design_tokens.dart';
import '../utils/spacing_and_animation.dart';

/// Base layout template for empty states.
class EmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const EmptyView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onActionPressed,
  });

  /// Factory constructor for No Internet State.
  factory EmptyView.noInternet({required VoidCallback onRetry}) {
    return EmptyView(
      icon: Icons.wifi_off_outlined,
      title: 'No Internet Connection',
      subtitle: 'Please check your connection and try again.',
      actionLabel: 'Retry',
      onActionPressed: onRetry,
    );
  }

  /// Factory constructor for No Data State.
  factory EmptyView.noData({
    required String title,
    required String subtitle,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    return EmptyView(
      icon: Icons.folder_open_outlined,
      title: title,
      subtitle: subtitle,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Factory constructor for No Search Results State.
  factory EmptyView.noSearchResult({
    required String query,
    VoidCallback? onClearSearch,
  }) {
    return EmptyView(
      icon: Icons.search_off_outlined,
      title: 'No Search Results',
      subtitle: 'We couldn\'t find any matches for "$query".',
      actionLabel: onClearSearch != null ? 'Clear Search' : null,
      onActionPressed: onClearSearch,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDesignTokens.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppDesignTokens.iconXL * 1.5,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const VerticalSpace.md(),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const VerticalSpace.xs(),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const VerticalSpace.xl(),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onActionPressed!,
                size: ButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Base layout template for rendering errors.
class ErrorView extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.title,
    required this.description,
    this.onRetry,
  });

  /// Factory constructor for Network/Connection Failure.
  factory ErrorView.network({required VoidCallback onRetry}) {
    return ErrorView(
      title: 'Network Error',
      description:
          'A network problem occurred. Please check your connectivity and try again.',
      onRetry: onRetry,
    );
  }

  /// Factory constructor for Backend Server Exception.
  factory ErrorView.server({String? message, VoidCallback? onRetry}) {
    return ErrorView(
      title: 'Server Error',
      description:
          message ??
          'An unexpected error occurred on the server. Please try again later.',
      onRetry: onRetry,
    );
  }

  /// Factory constructor for standard Fallback Error.
  factory ErrorView.generic({String? message, VoidCallback? onRetry}) {
    return ErrorView(
      title: 'Something Went Wrong',
      description: message ?? 'An unexpected error occurred. Please try again.',
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDesignTokens.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppDesignTokens.iconXL * 1.5,
              color: theme.colorScheme.error,
            ),
            const VerticalSpace.md(),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const VerticalSpace.xs(),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const VerticalSpace.xl(),
              SecondaryButton(
                label: 'Retry',
                onPressed: onRetry!,
                icon: Icons.refresh,
                size: ButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
