import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/features/notifications/domain/entities/app_notification.dart';
import 'package:splito_flutter/features/notifications/presentation/providers/notification_providers.dart';

/// Card list tile presenting a notification with tap-to-read and routing logic.
class NotificationListTile extends ConsumerWidget {
  /// The app notification entity.
  final AppNotification notification;

  /// Creates a new [NotificationListTile] instance.
  const NotificationListTile({required this.notification, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isUnread = notification.isUnread;

    // Leading icon selection
    IconData iconData;
    if (notification.type.startsWith('EXPENSE_')) {
      iconData = Icons.receipt_long_outlined;
    } else if (notification.type.startsWith('SETTLEMENT_')) {
      iconData = Icons.swap_horiz_rounded;
    } else if (notification.type.startsWith('MEMBER_')) {
      iconData = Icons.person_add_outlined;
    } else {
      iconData = Icons.notifications_outlined;
    }

    return Opacity(
      opacity: notification.isRead ? 0.65 : 1.0,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            // Fire-and-forget: Mark as read silently in the background
            try {
              ref
                  .read(markReadProvider.notifier)
                  .markRead(notificationId: notification.id);
            } catch (_) {}

            // Navigate immediately based on type
            final metadata = notification.metadata;
            if ((notification.type == 'EXPENSE_CREATED' ||
                    notification.type == 'EXPENSE_REVERSED') &&
                metadata != null &&
                metadata.containsKey('group_id') &&
                metadata.containsKey('expense_id')) {
              context.goNamed(
                AppRoutes.expenseDetailName,
                pathParameters: {
                  'groupId': metadata['group_id'] as String,
                  'expenseId': metadata['expense_id'] as String,
                },
              );
            } else if ((notification.type == 'SETTLEMENT_RECORDED' ||
                    notification.type == 'MEMBER_ADDED') &&
                metadata != null &&
                metadata.containsKey('group_id')) {
              context.goNamed(
                AppRoutes.groupDetailsName,
                pathParameters: {'groupId': metadata['group_id'] as String},
              );
            } else {
              context.goNamed(AppRoutes.groupsName);
            }
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: isUnread
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                iconData,
                color: isUnread
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            title: Text(
              notification.displayTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (notification.displayMessage.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    notification.displayMessage,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _formatRelativeDate(notification.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            trailing: isUnread
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  String _formatRelativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (dateToCheck == today) {
      return 'Today at ${DateFormat('h:mm a').format(dateTime)}';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM').format(dateTime);
    }
  }
}
