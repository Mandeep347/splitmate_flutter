import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/network/connectivity_notifier.dart';
import 'package:splito_flutter/core/responsive/responsive_layout.dart';
import 'package:splito_flutter/features/activity/domain/entities/activity_item.dart';
import 'package:splito_flutter/features/activity/presentation/providers/activity_providers.dart';
import 'package:splito_flutter/features/activity/presentation/widgets/activity_list_tile.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/shared/widgets/empty_state_widget.dart';
import 'package:splito_flutter/shared/widgets/shimmer_wrapper.dart';
import 'package:splito_flutter/shared/widgets/skeletons/activity_list_tile_skeleton.dart';

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
    final activityAsync = ref.watch(globalActivityProvider);
    final isOnline = ref.watch(isOnlineProvider);
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final activities = activityAsync.hasValue
        ? activityAsync.requireValue
        : const <ActivityItem>[];

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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: (activityAsync.isLoading && activities.isEmpty)
              ? ShimmerWrapper(
                  isLoading: true,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                        const ActivityListTileSkeleton(),
                  ),
                )
              : (activities.isEmpty)
              ? const EmptyStateWidget(
                  icon: Icons.history_rounded,
                  title: 'No activity yet',
                  subtitle: 'Transactions and group changes will appear here.',
                )
              : RefreshIndicator(
                  onRefresh: () => _handleRefresh(ref),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount:
                        activities.length + ((!isOnline && !isDesktop) ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (!isOnline && !isDesktop && index == 0) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF59E0B,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(
                                0xFFF59E0B,
                              ).withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.wifi_off_rounded,
                                size: 14,
                                color: Color(0xFFD97706),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Offline mode — Showing saved activities (may not be latest)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD97706),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final activityIndex = (!isOnline && !isDesktop)
                          ? index - 1
                          : index;
                      final activity = activities[activityIndex];

                      return Column(
                        children: [
                          ActivityListTile(activity: activity),
                          const Divider(height: 1),
                        ],
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
