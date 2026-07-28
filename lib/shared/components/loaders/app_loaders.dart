import 'package:flutter/material.dart';
import '../utils/design_tokens.dart';

/// Zero-dependency custom Shimmer effect widget.
/// Animates a linear gradient highlighting effect across light/dark surfaces.
class Shimmer extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const Shimmer({super.key, required this.child, this.enabled = true});

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Premium Slate HSL-tailored shades for Light & Dark mode shimmers
    final baseColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final highlightColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFF1F5F9);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.1, 0.3, 0.4],
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
              ),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * (slidePercent - 0.5) * 2,
      0.0,
      0.0,
    );
  }
}

/// A generic skeleton rectangular block with customizable borders.
class SkeletonBlock extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBlock({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppDesignTokens.radiusSM,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // Color is overridden by Shimmer ShaderMask
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// A skeleton placeholder layout mimicking a list card item.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDesignTokens.spaceSM),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBlock(
              width: 48,
              height: 48,
              borderRadius: AppDesignTokens.radiusRound,
            ),
            SizedBox(width: AppDesignTokens.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBlock(width: 120, height: 16),
                  SizedBox(height: AppDesignTokens.spaceXS),
                  SkeletonBlock(width: double.infinity, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders a list of skeleton card placeholders for page load sequences.
class SkeletonList extends StatelessWidget {
  final int itemCount;

  const SkeletonList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => const SkeletonCard(),
    );
  }
}

/// Centered Circular progress indicator with semantics.
class CircularLoader extends StatelessWidget {
  const CircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: 'Loading content',
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

/// Centered progress spinner overlay with a description label.
class PageLoader extends StatelessWidget {
  final String message;

  const PageLoader({super.key, this.message = 'Please wait...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularLoader(),
          const SizedBox(height: AppDesignTokens.spaceMD),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// Fullscreen overlay page displaying a centered loader.
class EmptyLoadingScreen extends StatelessWidget {
  const EmptyLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: PageLoader());
  }
}
