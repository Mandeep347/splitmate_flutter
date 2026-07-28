import 'package:flutter/material.dart';
import '../utils/design_tokens.dart';

/// Standard confirmation alert dialog.
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
    this.onCancel,
  });

  /// Static helper to display the dialog.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesignTokens.radiusLG),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            if (onCancel != null) onCancel!();
          },
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

/// Non-dismissible dialog displaying a loading spinner.
class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({super.key, this.message = 'Loading...'});

  /// Static helper to display the loading modal.
  static void show(BuildContext context, {String message = 'Loading...'}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(message: message),
    );
  }

  /// Static helper to dismiss the modal.
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false, // Prevent dismissing with back button
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMD),
        ),
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: AppDesignTokens.spaceXL),
            Expanded(child: Text(message, style: theme.textTheme.bodyLarge)),
          ],
        ),
      ),
    );
  }
}

/// Modal dialog displaying fatal errors.
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String closeLabel;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.closeLabel = 'Dismiss',
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String closeLabel = 'Dismiss',
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) =>
          ErrorDialog(title: title, message: message, closeLabel: closeLabel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: AppDesignTokens.spaceSM),
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesignTokens.radiusLG),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(closeLabel),
        ),
      ],
    );
  }
}

/// Modal dialog indicating success state.
class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String closeLabel;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.closeLabel = 'Great',
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String closeLabel = 'Great',
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) =>
          SuccessDialog(title: title, message: message, closeLabel: closeLabel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.check_circle_outline, color: theme.colorScheme.secondary),
          const SizedBox(width: AppDesignTokens.spaceSM),
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesignTokens.radiusLG),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(closeLabel),
        ),
      ],
    );
  }
}
