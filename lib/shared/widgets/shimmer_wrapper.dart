import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Wraps a [child] widget in a shimmering effect if [isLoading] is true.
/// Useful for displaying skeleton loading states.
class ShimmerWrapper extends StatelessWidget {
  /// The child widget to wrap.
  final Widget child;

  /// Whether the shimmer effect should be active.
  final bool isLoading;

  /// Creates a [ShimmerWrapper].
  const ShimmerWrapper({super.key, required this.child, this.isLoading = true});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    final colorScheme = Theme.of(context).colorScheme;

    return ExcludeSemantics(
      child: Shimmer.fromColors(
        baseColor: colorScheme.surfaceContainerHighest,
        highlightColor: colorScheme.surface,
        child: child,
      ),
    );
  }
}
