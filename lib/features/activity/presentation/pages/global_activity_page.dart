import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/activity/domain/entities/activity_item.dart';
import 'package:splito_flutter/features/activity/presentation/providers/activity_providers.dart';
import 'package:splito_flutter/features/activity/presentation/widgets/activity_list_tile.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/empty_state_widget.dart';

import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';

class GlobalActivityPage extends ConsumerWidget {
  const GlobalActivityPage({super.key});

  Future<void> _handleRefresh(WidgetRef ref) async {
    ref.invalidate(myGroupsProvider);
    final groups = ref.read(myGroupsProvider).valueOrNull ?? [];
    for (final g in groups) {
      ref.invalidate(groupActivityProvider(g.id));
    }
    ref.invalidate(globalActivityProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activityAsync = ref.watch(globalActivityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => _handleRefresh(ref),
          ),
        ],
      ),
      body: AsyncValueWidget<List<ActivityItem>>(
        value: activityAsync,
        data: (activities) {
          if (activities.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.history_rounded,
              title: 'No activity yet',
              subtitle: 'Transactions and group changes will appear here.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => _handleRefresh(ref),
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ActivityListTile(activity: activity);
              },
            ),
          );
        },
      ),
    );
  }
}
