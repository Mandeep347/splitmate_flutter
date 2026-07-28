import 'package:flutter/material.dart';
import '../utils/design_tokens.dart';

/// Base custom styling container wrapping standard card attributes.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? elevation;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: elevation ?? 0,
      color: color ?? theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesignTokens.radiusMD),
        side: BorderSide(
          color: theme.colorScheme.surfaceContainerHighest,
          width: 1,
        ),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppDesignTokens.cardPadding),
        child: child,
      ),
    );
  }
}

/// A card structured for containing sub-sections in pages.
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDesignTokens.cardPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppDesignTokens.cardPadding),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Card styled for informational callouts (e.g. alerts or warnings).
class InfoCard extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;

  const InfoCard({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finalBgColor = backgroundColor ?? theme.colorScheme.primaryContainer;
    final finalIconColor = iconColor ?? theme.colorScheme.onPrimaryContainer;

    return Semantics(
      container: true,
      label: 'Info: $message',
      child: AppCard(
        color: finalBgColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: finalIconColor, size: AppDesignTokens.iconMD),
            const SizedBox(width: AppDesignTokens.spaceMD),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// InkWell clickable card with selection feedback.
class ClickableCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const ClickableCard({
    super.key,
    required this.child,
    required this.onTap,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: color ?? theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesignTokens.radiusMD),
        side: BorderSide(
          color: theme.colorScheme.surfaceContainerHighest,
          width: 1,
        ),
      ),
      clipBehavior:
          Clip.antiAlias, // Critical for keeping Inkwell ripple within borders
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppDesignTokens.cardPadding),
          child: child,
        ),
      ),
    );
  }
}
