import 'package:flutter/material.dart';

/// A full screen loader that intercepts events and reduces background opacity during loads.
class LoadingOverlay extends StatelessWidget {
  /// Flag indicating if the loading overlay is active.
  final bool isLoading;

  /// The underlying widget subtree.
  final Widget child;

  /// Creates a [LoadingOverlay].
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          Positioned.fill(
            child: AbsorbPointer(
              child: Container(color: Colors.black.withValues(alpha: 0.3)),
            ),
          ),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
}
