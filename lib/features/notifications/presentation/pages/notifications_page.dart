import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/notifications/domain/entities/app_notification.dart';
import 'package:splito_flutter/features/notifications/presentation/providers/notification_providers.dart';
import 'package:splito_flutter/features/notifications/presentation/widgets/notification_list_tile.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/empty_state_widget.dart';
import 'package:splito_flutter/shared/widgets/shimmer_wrapper.dart';
import 'package:splito_flutter/shared/widgets/skeletons/notification_list_tile_skeleton.dart';

/// Screen presenting the notifications list, mark-all-read action, and pull-to-refresh.
class NotificationsPage extends ConsumerWidget {
  /// Creates a new [NotificationsPage] instance.
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notificationsState = ref.watch(notificationsProvider);

    // Listen to mark all read updates
    ref.listen<AsyncValue<int?>>(markAllReadProvider, (previous, next) {
      if (next is AsyncData<int?> && next.value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${next.value} notifications marked as read')),
        );
      } else if (next is AsyncError) {
        final error = next.error;
        final message = error is Failure ? error.message : error.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final markAllReadState = ref.watch(markAllReadProvider);
              final hasUnread = ref.watch(hasUnreadProvider);
              final isLoading = markAllReadState.isLoading;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasUnread)
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              try {
                                ref.read(markAllReadProvider.notifier).markAll();
                              } catch (_) {}
                            },
                      child: const Text('Mark all read'),
                    ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: AsyncValueWidget<List<AppNotification>>(
        value: notificationsState,
        loading: () => ShimmerWrapper(
          isLoading: true,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: 5,
            itemBuilder: (context, index) => const NotificationListTileSkeleton(),
          ),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.notifications_none_outlined,
              title: 'No notifications',
              subtitle:
                  'You will be notified about expenses, settlements and group activity here.',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(notificationsProvider.notifier).refresh();
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationListTile(notification: notifications[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
