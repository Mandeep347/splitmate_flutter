import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/features/notifications/presentation/providers/notification_providers.dart';

/// Binary unread indicator — red dot when any unread notifications exist.
class NotificationBell extends ConsumerWidget {
  /// Creates a new [NotificationBell] instance.
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hasUnread = ref.watch(hasUnreadProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            ref.read(notificationsProvider.notifier).refresh();
            // Bug 6 fix: use pushNamed so back navigation returns to the
            // originating page (profile / any screen) instead of replacing it.
            context.pushNamed(AppRoutes.notificationsName);
          },
        ),
        if (hasUnread)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
