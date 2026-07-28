import 'package:flutter/material.dart';

/// A small styled chip container indicating debt directions (Positive/Negative).
class BalanceDirectionChip extends StatelessWidget {
  /// The text label to show in the chip.
  final String label;

  /// True if the balance direction represents a positive amount (someone owes you),
  /// false if negative (you owe someone).
  final bool isPositive;

  /// Creates a const [BalanceDirectionChip] instance.
  const BalanceDirectionChip({
    super.key,
    required this.label,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = isPositive
        ? Colors.green.shade50
        : Colors.red.shade50;
    final borderColor = isPositive
        ? Colors.green.shade200
        : Colors.red.shade200;
    final textColor = isPositive ? Colors.green.shade700 : Colors.red.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
