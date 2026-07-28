import 'package:flutter/material.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// A widget representing an empty or neutral placeholder screen.
class EmptyStateWidget extends StatelessWidget {
  /// The icon representing the state.
  final IconData icon;

  /// The title text of the empty state.
  final String title;

  /// The subtitle text giving more context.
  final String subtitle;

  /// The label for the primary call-to-action button.
  final String? actionLabel;

  /// The callback triggered when the action button is pressed.
  final VoidCallback? onAction;

  /// Creates a const [EmptyStateWidget] instance.
  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final hasAction = actionLabel != null && onAction != null;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(ext.spaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(ext.spaceLG),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(ext.radiusRound),
              ),
              child: Icon(
                icon,
                size: 48,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(height: ext.spaceXL),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ext.spaceSM),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasAction) ...[
              SizedBox(height: ext.spaceXL),
              PrimaryButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
