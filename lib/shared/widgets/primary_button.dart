import 'package:flutter/material.dart';

/// A Material 3 styled primary action button.
class PrimaryButton extends StatelessWidget {
  /// The label displayed on the button.
  final String label;

  /// Callback executed when the button is tapped.
  final VoidCallback? onPressed;

  /// Flag indicating if the button is in a loading state.
  final bool isLoading;

  /// Flag indicating if the button should expand to fill horizontal space.
  final bool isFullWidth;

  /// Optional icon to display before the label.
  final IconData? icon;

  /// Creates a standard [PrimaryButton].
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
  }) : icon = null;

  /// Creates a [PrimaryButton] with a leading icon.
  const PrimaryButton.icon({
    super.key,
    required this.label,
    required this.onPressed,
    required IconData this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final buttonContent = isLoading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.onPrimary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          );

    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: isFullWidth ? const Size.fromHeight(48) : null,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );

    return Semantics(
      label: label,
      button: true,
      enabled: onPressed != null && !isLoading,
      child: ElevatedButton(
        onPressed: (isLoading || onPressed == null) ? null : onPressed,
        style: buttonStyle,
        child: buttonContent,
      ),
    );
  }
}
