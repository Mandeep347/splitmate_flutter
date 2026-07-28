import 'package:flutter/material.dart';

/// Enum representing the synchronization status of an entity or action.
enum PendingState {
  /// Confirmed by remote server.
  confirmed,

  /// Enqueued locally, pending network sync.
  pending,

  /// Sync attempt failed after max retries or server error.
  failed,
}

/// Helper widget wrapping item content with a subtle visual status indicator for offline queue state.
class PendingIndicatorWrapper extends StatelessWidget {
  /// The item content to display.
  final Widget child;

  /// The current pending state of the entity.
  final PendingState state;

  /// Optional custom message for pending/failed states.
  final String? message;

  /// Creates a new [PendingIndicatorWrapper] instance.
  const PendingIndicatorWrapper({
    super.key,
    required this.child,
    required this.state,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (state == PendingState.confirmed) {
      return child;
    }

    final theme = Theme.of(context);
    final isPending = state == PendingState.pending;

    final badgeColor = isPending
        ? const Color(0xFFF59E0B) // Warm Amber
        : theme.colorScheme.error; // Vibrant Red

    final badgeIcon = isPending
        ? Icons.access_time_rounded
        : Icons.warning_amber_rounded;

    final defaultText = isPending ? 'Pending sync' : 'Sync failed';
    final displayText = message ?? defaultText;

    return Stack(
      children: [
        Opacity(opacity: isPending ? 0.88 : 0.75, child: child),
        Positioned(
          top: 6,
          right: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: badgeColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(badgeIcon, size: 12, color: badgeColor),
                const SizedBox(width: 4),
                Text(
                  displayText,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
