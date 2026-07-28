import 'package:flutter/material.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';

/// A custom linear progress bar indicating the settlement progress.
/// Uses a custom gradient styling that shifts color depending on value.
class SettlementProgressBar extends StatelessWidget {
  /// Progress value between 0.0 and 1.0.
  final double value;

  /// Creates a const [SettlementProgressBar] instance.
  const SettlementProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    final isFullySettled = value >= 0.99;

    return Container(
      height: 10,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(ext.radiusXS),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth * value;
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: width,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ext.radiusXS),
                gradient: isFullySettled
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF10B981),
                          Color(0xFF059669),
                        ], // Emerald Green
                      )
                    : ext.primaryGradient,
              ),
            ),
          );
        },
      ),
    );
  }
}
