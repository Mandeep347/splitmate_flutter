import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/activity/domain/entities/activity_feed.dart';
import 'package:splito_flutter/features/activity/presentation/providers/activity_providers.dart';
import 'package:splito_flutter/features/activity/presentation/widgets/activity_list_tile.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/empty_state_widget.dart';
import 'package:splito_flutter/features/expenses/presentation/providers/expense_providers.dart';
import 'package:splito_flutter/features/settlements/presentation/providers/settlement_providers.dart';

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
      body: AsyncValueWidget<ActivityFeed>(
        value: activityState,
        data: (feed) {
          if (feed.items.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.history_outlined,
              title: 'No activity yet',
              subtitle:
                  'Activity will appear here as your group adds expenses and settlements.',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(groupExpensesProvider(widget.groupId));
              ref.invalidate(groupSettlementsProvider(widget.groupId));
              ref.invalidate(groupActivityProvider(widget.groupId));
            },
            child: ListView.builder(
              controller: _scrollController,
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
          );
        },
      ),
    );
  }
}
