import 'package:flutter/material.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';

/// A reusable row displaying a key-value pair with an icon.
class InfoRow extends StatelessWidget {
  /// The icon representing the field.
  final IconData icon;

  /// The label describing the key.
  final String label;

  /// The value associated with the label.
  final String value;

  /// Optional color override for the value text.
  final Color? valueColor;

  /// Creates a const [InfoRow] instance.
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        SizedBox(width: ext.spaceSM),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: valueColor ?? theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
