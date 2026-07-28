import 'package:flutter/material.dart';
import '../utils/design_tokens.dart';

/// Preset color styles for Status Chips.
enum StatusType { success, error, warning, info, neutral }

/// Static colored status indicator badge.
class StatusChip extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusChip({
    super.key,
    required this.label,
    this.type = StatusType.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color bgColor;
    Color textColor;

    switch (type) {
      case StatusType.success:
        bgColor = theme.colorScheme.secondaryContainer;
        textColor = theme.colorScheme.onSecondaryContainer;
      case StatusType.error:
        bgColor = theme.colorScheme.errorContainer;
        textColor = theme.colorScheme.onErrorContainer;
      case StatusType.warning:
        bgColor = theme.colorScheme.tertiaryContainer;
        textColor = theme.colorScheme.onTertiaryContainer;
      case StatusType.info:
        bgColor = theme.colorScheme.primaryContainer;
        textColor = theme.colorScheme.onPrimaryContainer;
      case StatusType.neutral:
        bgColor = theme.colorScheme.surfaceContainerHighest;
        textColor = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spaceSM,
        vertical: AppDesignTokens.spaceXXS,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDesignTokens.radiusRound),
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

/// Filter action chip wrapping M3 standard.
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesignTokens.radiusSM),
      ),
    );
  }
}

/// A selectable pill chip for selection flows.
class SelectableChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.surface;
    final textColor = isSelected
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;
    final borderSide = isSelected
        ? BorderSide.none
        : BorderSide(color: theme.colorScheme.outlineVariant);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDesignTokens.radiusRound),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spaceLG,
          vertical: AppDesignTokens.spaceSM,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusRound),
          border: Border.fromBorderSide(borderSide),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Badge representing financial status (credit vs debit).
class AmountChip extends StatelessWidget {
  final double amount;
  final String currencySymbol;

  const AmountChip({
    super.key,
    required this.amount,
    this.currencySymbol = r'$',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNegative = amount < 0;
    final absAmount = amount.abs().toStringAsFixed(2);
    final label = isNegative
        ? 'Owe: $currencySymbol$absAmount'
        : 'Get back: $currencySymbol$absAmount';

    final bgColor = isNegative
        ? theme.colorScheme.errorContainer
        : theme.colorScheme.secondaryContainer;
    final textColor = isNegative
        ? theme.colorScheme.onErrorContainer
        : theme.colorScheme.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spaceMD,
        vertical: AppDesignTokens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDesignTokens.radiusSM),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
