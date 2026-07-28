import 'package:flutter/material.dart';
import 'design_tokens.dart';

/// Renders a vertical whitespace box using preset spacing tokens.
class VerticalSpace extends StatelessWidget {
  final double size;

  const VerticalSpace(this.size, {super.key});

  const VerticalSpace.xxs({super.key}) : size = AppDesignTokens.spaceXXS;
  const VerticalSpace.xs({super.key}) : size = AppDesignTokens.spaceXS;
  const VerticalSpace.sm({super.key}) : size = AppDesignTokens.spaceSM;
  const VerticalSpace.md({super.key}) : size = AppDesignTokens.spaceMD;
  const VerticalSpace.lg({super.key}) : size = AppDesignTokens.spaceLG;
  const VerticalSpace.xl({super.key}) : size = AppDesignTokens.spaceXL;
  const VerticalSpace.xxl({super.key}) : size = AppDesignTokens.spaceXXL;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size);
  }
}

/// Renders a horizontal whitespace box using preset spacing tokens.
class HorizontalSpace extends StatelessWidget {
  final double size;

  const HorizontalSpace(this.size, {super.key});

  const HorizontalSpace.xxs({super.key}) : size = AppDesignTokens.spaceXXS;
  const HorizontalSpace.xs({super.key}) : size = AppDesignTokens.spaceXS;
  const HorizontalSpace.sm({super.key}) : size = AppDesignTokens.spaceSM;
  const HorizontalSpace.md({super.key}) : size = AppDesignTokens.spaceMD;
  const HorizontalSpace.lg({super.key}) : size = AppDesignTokens.spaceLG;
  const HorizontalSpace.xl({super.key}) : size = AppDesignTokens.spaceXL;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size);
  }
}

/// Reusable Section Header for structuring content listings.
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDesignTokens.spaceSM),
      // Semantics for screen readers
      child: Semantics(
        header: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

/// Micro-animation that fades children in when mounted or state changes.
class AnimatedFade extends StatelessWidget {
  final Widget child;
  final bool show;
  final Duration duration;

  const AnimatedFade({
    super.key,
    required this.child,
    this.show = true,
    this.duration = AppDesignTokens.durationFast,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: show ? 1.0 : 0.0,
      duration: duration,
      curve: Curves.easeInOut,
      child: child,
    );
  }
}

/// Micro-animation that scales children up/down when transitions occur.
class AnimatedScaleUp extends StatelessWidget {
  final Widget child;
  final bool show;
  final Duration duration;

  const AnimatedScaleUp({
    super.key,
    required this.child,
    this.show = true,
    this.duration = AppDesignTokens.durationFast,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: show ? 1.0 : 0.95,
      duration: duration,
      curve: Curves.easeOutBack,
      child: child,
    );
  }
}
