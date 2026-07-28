import 'package:flutter/material.dart';
import '../utils/design_tokens.dart';

/// Supported sizing presets for App buttons.
enum ButtonSize { small, medium, large }

/// Helper to render unified loading states (CircularProgressIndicator) inside buttons.
class _ButtonLoadingIndicator extends StatelessWidget {
  final Color color;
  final ButtonSize size;

  const _ButtonLoadingIndicator({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    final indicatorSize = size == ButtonSize.small ? 16.0 : 20.0;
    return SizedBox(
      height: indicatorSize,
      width: indicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

/// Generic wrapper to apply heights, width constraints, and minimum touch target requirements.
class _ButtonLayout extends StatelessWidget {
  final Widget child;
  final bool fullWidth;
  final ButtonSize size;

  const _ButtonLayout({
    required this.child,
    required this.fullWidth,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    double height = AppDesignTokens.buttonHeightMD;
    if (size == ButtonSize.small) height = AppDesignTokens.buttonHeightSM;
    if (size == ButtonSize.large) height = AppDesignTokens.buttonHeightLG;

    Widget buttonWidget = SizedBox(height: height, child: child);

    if (fullWidth) {
      buttonWidget = SizedBox(
        width: double.infinity,
        height: height,
        child: child,
      );
    }

    // Ensure compliance with touch targets (Minimum 48 pixels)
    if (height < AppDesignTokens.minimumTouchTarget) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical:
              (AppDesignTokens.minimumTouchTarget -
                  AppDesignTokens.buttonHeightSM) /
              2,
        ),
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}

/// Primary action button (M3 FilledButton).
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final ButtonSize size;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onPrimaryColor = theme.colorScheme.onPrimary;

    final Widget buttonContent = isLoading
        ? _ButtonLoadingIndicator(color: onPrimaryColor, size: size)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: size == ButtonSize.small ? 16 : 20),
                const SizedBox(width: AppDesignTokens.spaceSM),
              ],
              Text(label),
            ],
          );

    return _ButtonLayout(
      fullWidth: fullWidth,
      size: size,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusMD),
          ),
        ),
        child: buttonContent,
      ),
    );
  }
}

/// Tonal Action Button (M3 FilledButton.tonal).
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final ButtonSize size;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSecondaryContainer = theme.colorScheme.onSecondaryContainer;

    final Widget buttonContent = isLoading
        ? _ButtonLoadingIndicator(color: onSecondaryContainer, size: size)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: size == ButtonSize.small ? 16 : 20),
                const SizedBox(width: AppDesignTokens.spaceSM),
              ],
              Text(label),
            ],
          );

    return _ButtonLayout(
      fullWidth: fullWidth,
      size: size,
      child: FilledButton.tonal(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusMD),
          ),
        ),
        child: buttonContent,
      ),
    );
  }
}

/// Outlined Action Button (M3 OutlinedButton).
class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final ButtonSize size;

  const AppOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final Widget buttonContent = isLoading
        ? _ButtonLoadingIndicator(color: primary, size: size)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: size == ButtonSize.small ? 16 : 20),
                const SizedBox(width: AppDesignTokens.spaceSM),
              ],
              Text(label),
            ],
          );

    return _ButtonLayout(
      fullWidth: fullWidth,
      size: size,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusMD),
          ),
        ),
        child: buttonContent,
      ),
    );
  }
}

/// Text Action Button (M3 TextButton).
class AppTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final ButtonSize size;

  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final Widget buttonContent = isLoading
        ? _ButtonLoadingIndicator(color: primary, size: size)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: size == ButtonSize.small ? 16 : 20),
                const SizedBox(width: AppDesignTokens.spaceSM),
              ],
              Text(label),
            ],
          );

    return _ButtonLayout(
      fullWidth: fullWidth,
      size: size,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusMD),
          ),
        ),
        child: buttonContent,
      ),
    );
  }
}

/// Destructive Action Button (M3 Tonal Error Button).
class DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final ButtonSize size;

  const DangerButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onErrorContainer = theme.colorScheme.onErrorContainer;

    final Widget buttonContent = isLoading
        ? _ButtonLoadingIndicator(color: onErrorContainer, size: size)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: size == ButtonSize.small ? 16 : 20),
                const SizedBox(width: AppDesignTokens.spaceSM),
              ],
              Text(label),
            ],
          );

    return _ButtonLayout(
      fullWidth: fullWidth,
      size: size,
      child: FilledButton.tonal(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.errorContainer,
          foregroundColor: onErrorContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusMD),
          ),
        ),
        child: buttonContent,
      ),
    );
  }
}

/// Circular or standard IconButton wrapping accessibility minimum touch targets.
class AppIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final Color? color;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    required this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tooltip,
      button: true,
      enabled: onPressed != null,
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
        tooltip: tooltip,
        color: color,
        constraints: const BoxConstraints(
          minHeight: AppDesignTokens.minimumTouchTarget,
          minWidth: AppDesignTokens.minimumTouchTarget,
        ),
      ),
    );
  }
}

/// Explicit widget to render loading button states.
class LoadingButton extends StatelessWidget {
  final String label;
  final ButtonSize size;
  final bool fullWidth;

  const LoadingButton({
    super.key,
    required this.label,
    this.size = ButtonSize.medium,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: label,
      isLoading: true,
      fullWidth: fullWidth,
      size: size,
    );
  }
}
