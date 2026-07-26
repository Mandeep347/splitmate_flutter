import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/activity/domain/entities/activity_feed.dart';
import 'package:splito_flutter/features/activity/presentation/providers/activity_providers.dart';
import 'package:splito_flutter/features/activity/presentation/widgets/activity_list_tile.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/empty_state_widget.dart';
import 'package:splito_flutter/features/expenses/presentation/providers/expense_providers.dart';
import 'package:splito_flutter/features/settlements/presentation/providers/settlement_providers.dart';
import 'package:splito_flutter/core/network/connectivity_notifier.dart';

/// Screen displaying the paginated feed of activities in a group.
class ActivityFeedPage extends ConsumerStatefulWidget {
  /// The unique identifier of the group.
  final String groupId;

  /// The display name of the group.
  final String groupName;

  /// Creates a new [ActivityFeedPage] instance.
  const ActivityFeedPage({
    required this.groupId,
    required this.groupName,
    super.key,
  });

  @override
  ConsumerState<ActivityFeedPage> createState() => _ActivityFeedPageState();
}

class _ActivityFeedPageState extends ConsumerState<ActivityFeedPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(groupActivityProvider(widget.groupId).notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activityState = ref.watch(groupActivityProvider(widget.groupId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.groupName),
            Text(
              'Activity',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          final feed = activityState.hasValue ? activityState.requireValue : null;
          final isOnline = ref.watch(isOnlineProvider);

          if (feed == null) {
            if (activityState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  activityState.error != null 
                      ? 'Error: ${activityState.error}' 
                      : 'An error occurred',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(groupExpensesProvider(widget.groupId));
              ref.invalidate(groupSettlementsProvider(widget.groupId));
              ref.invalidate(groupActivityProvider(widget.groupId));
            },
            child: Column(
              children: [
                if (!isOnline)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.wifi_off_rounded, size: 14, color: Color(0xFFD97706)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Offline mode — Showing saved data (may not be latest)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: feed.items.isEmpty 
                    ? const EmptyStateWidget(
                        icon: Icons.history_outlined,
                        title: 'No activity yet',
                        subtitle: 'Activity will appear here as your group adds expenses and settlements.',
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        itemCount: feed.items.length + (feed.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == feed.items.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return ActivityListTile(activity: feed.items[index]);
                        },
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
