import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/responsive/responsive_layout.dart';
import 'package:splito_flutter/features/groups/domain/entities/group.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/features/groups/presentation/widgets/create_group_sheet.dart';
import 'package:splito_flutter/features/groups/presentation/widgets/group_card.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/empty_state_widget.dart';
import 'package:splito_flutter/shared/widgets/overall_balance_card.dart';
import 'package:splito_flutter/features/balances/presentation/providers/balance_providers.dart';
import 'package:splito_flutter/shared/widgets/notification_bell.dart';
import 'package:splito_flutter/features/notifications/presentation/providers/notification_providers.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/shared/widgets/shimmer_wrapper.dart';
import 'package:splito_flutter/shared/widgets/skeletons/group_card_skeleton.dart';

/// Redesigned Screen listing all groups in a responsive grid.
class GroupListPage extends ConsumerWidget {
  /// Creates a const [GroupListPage] instance.
  const GroupListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final groupsAsync = ref.watch(myGroupsProvider);
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);

    // Listens to create group mutation to show status SnackBars
    ref.listen<AsyncValue<void>>(createGroupProvider, (previous, next) {
      if (next is AsyncData<void> && previous is AsyncLoading<void>) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group created!')),
        );
      } else if (next is AsyncError<void>) {
        final errorMessage =
            next.error is Failure ? (next.error as Failure).message : 'Failed to create group.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: isDesktop
          ? null // AppBar is already in the Desktop Sidebar Shell
          : AppBar(
              title: const Text('Groups'),
              actions: [
                const NotificationBell(),
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: () => CreateGroupSheet.show(context),
                ),
              ],
            ),
      body: AsyncValueWidget<List<Group>>(
        value: groupsAsync,
        onRetry: () => ref.invalidate(myGroupsProvider),
        loading: () => ShimmerWrapper(
          isLoading: true,
          child: ListView.builder(
            padding: EdgeInsets.all(ext.spaceMD),
            itemCount: 5,
            itemBuilder: (context, index) => const GroupCardSkeleton(),
          ),
        ),
        data: (groups) {
          final activeGroups = groups.where((g) => g.isActive).toList();

          if (activeGroups.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.group_outlined,
              title: 'No groups yet',
              subtitle: 'Create a group to start splitting expenses.',
              actionLabel: 'Create Group',
              onAction: () => CreateGroupSheet.show(context),
            );
          }

          final unsettledGroups = <Group>[];
          final settledGroups = <Group>[];
          final settledIds = ref.watch(settledGroupIdsProvider);

          for (final group in activeGroups) {
            if (settledIds.contains(group.id)) {
              settledGroups.add(group);
            } else {
              unsettledGroups.add(group);
            }
          }

          // Sort unsettled groups by createdAt descending
          unsettledGroups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          settledGroups.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

          Widget groupsGrid(List<Group> list) {
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisExtent: 116,
                crossAxisSpacing: ext.spaceSM,
                mainAxisSpacing: ext.spaceSM,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GroupCard(group: list[index]);
                },
                childCount: list.length,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myGroupsProvider);
              ref.invalidate(myOverallBalancesProvider);
              ref.invalidate(unreadCountProvider);
              try {
                await ref.read(myGroupsProvider.future);
                await ref.read(myOverallBalancesProvider.future);
                await ref.read(unreadCountProvider.future);
              } catch (_) {}
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (!isDesktop)
                  const SliverToBoxAdapter(
                    child: OverallBalanceCard(),
                  ),
                
                // Active Groups Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ext.spaceLG, vertical: ext.spaceMD),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Active Groups',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (isDesktop)
                          ElevatedButton.icon(
                            onPressed: () => CreateGroupSheet.show(context),
                            icon: const Icon(Icons.add_rounded, size: 16),
                            label: const Text('Create Group'),
                          ),
                      ],
                    ),
                  ),
                ),

                // Unsettled Groups Grid
                if (unsettledGroups.isNotEmpty)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: ext.spaceSM),
                    sliver: groupsGrid(unsettledGroups),
                  )
                else
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                        child: Text(
                          'No active unsettled groups',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),

                // History Section
                if (settledGroups.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: ext.spaceLG, top: ext.spaceXL, bottom: ext.spaceMD),
                      child: Text(
                        'History (Settled Groups)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: ext.spaceSM),
                    sliver: groupsGrid(settledGroups),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        },
      ),
    );
  }
}
