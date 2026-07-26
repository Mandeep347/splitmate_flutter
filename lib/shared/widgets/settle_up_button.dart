import 'package:flutter/material.dart';
import 'package:splito_flutter/core/theme/financial_colors.dart';

/// Reusable green ElevatedButton to initiate settlement workflows.
class SettleUpButton extends StatelessWidget {
  /// Callback triggered when tapping the button.
  final VoidCallback? onPressed;

  /// Option to show a loading indicator.
  final bool isLoading;

  /// Creates a const [SettleUpButton] instance.
  const SettleUpButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = theme.colorScheme.owedColor;

    return Semantics(
      label: 'Settle up button',
      button: true,
      enabled: onPressed != null && !isLoading,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: buttonColor.withValues(alpha: 0.5),
            disabledForegroundColor: Colors.white.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          icon: isLoading
              ? const SizedBox.shrink()
              : const Icon(Icons.swap_horiz_rounded),
          label: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Settle Up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
