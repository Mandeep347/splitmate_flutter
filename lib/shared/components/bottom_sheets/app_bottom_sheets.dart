import 'package:flutter/material.dart';
import '../utils/design_tokens.dart';

/// Standard layout wrapper for bottom sheets.
class AppBottomSheetWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool showDragHandle;

  const AppBottomSheetWrapper({
    super.key,
    required this.child,
    this.padding,
    this.showDragHandle = true,
  });

  /// Static helper to display the bottom sheet.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    EdgeInsetsGeometry? padding,
    bool showDragHandle = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDesignTokens.radiusXL),
        ),
      ),
      builder: (context) => AppBottomSheetWrapper(
        padding: padding,
        showDragHandle: showDragHandle,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset =
        mediaQuery.viewInsets.bottom; // Support keyboard offsets

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDragHandle) ...[
              const SizedBox(height: AppDesignTokens.spaceSM),
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(
                    AppDesignTokens.radiusRound,
                  ),
                ),
              ),
              const SizedBox(height: AppDesignTokens.spaceSM),
            ],
            Padding(
              padding:
                  padding ??
                  const EdgeInsets.all(AppDesignTokens.screenPadding),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// A bottom sheet that contains a scrollable view (e.g. lists).
/// Uses [DraggableScrollableSheet] to grow/shrink based on user drag gestures.
class ScrollableBottomSheet extends StatelessWidget {
  final String title;
  final ScrollableWidgetBuilder builder;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  const ScrollableBottomSheet({
    super.key,
    required this.title,
    required this.builder,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.9,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required ScrollableWidgetBuilder builder,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 0.9,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDesignTokens.radiusXL),
        ),
      ),
      builder: (context) => ScrollableBottomSheet(
        title: title,
        builder: builder,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: AppDesignTokens.spaceSM),
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(
                  AppDesignTokens.radiusRound,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDesignTokens.screenPadding),
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(child: builder(context, scrollController)),
          ],
        );
      },
    );
  }
}

/// Action confirmation sheet designed as a bottom-up callout.
class ConfirmationBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    required VoidCallback onConfirm,
  }) {
    return AppBottomSheetWrapper.show<bool>(
      context,
      child: ConfirmationBottomSheet(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDesignTokens.spaceMD),
        Text(
          message,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDesignTokens.spaceXL),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          child: Text(confirmLabel),
        ),
        const SizedBox(height: AppDesignTokens.spaceSM),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
      ],
    );
  }
}
