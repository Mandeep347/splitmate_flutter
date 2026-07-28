import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/activity_item.dart';
import 'activity_icon.dart';

/// List tile widget presenting a single activity item description and timestamp.
///
/// Substitutes the current user's name with "You" in the [activity.description]
/// so actions performed by the signed-in user read naturally (e.g.
/// "You added an expense" instead of "Mandeep Chauhan added an expense").
class ActivityListTile extends ConsumerWidget {
  /// The activity item entity.
  final ActivityItem activity;

  /// Creates a new [ActivityListTile] instance.
  const ActivityListTile({required this.activity, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Bug 3 fix: read current user to substitute their name with "You".
    final currentUser = ref.watch(currentUserProvider);

    // Replace the actor's name with "You" when the activity belongs to the
    // current user.  The backend description already contains the actor name,
    // so we do a targeted string replacement.
    String displayDescription = activity.description;
    if (currentUser != null && activity.actorName.isNotEmpty) {
      // Match by actorUserId when available, fall back to name comparison.
      final isCurrentUser = activity.actorUserId.isNotEmpty
          ? activity.actorUserId == currentUser.id
          : activity.actorName == currentUser.name;

      if (isCurrentUser) {
        // Replace the leading name token with "You".
        displayDescription = displayDescription.replaceFirst(
          activity.actorName,
          'You',
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: ActivityIcon(iconKey: activity.iconKey, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayDescription,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatRelativeDate(activity.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatRelativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final activityDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (activityDate == today) {
      return 'Today at ${DateFormat('h:mm a').format(dateTime)}';
    } else if (activityDate == yesterday) {
      return 'Yesterday at ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      return DateFormat('d MMM, h:mm a').format(dateTime);
    }
  }
}
