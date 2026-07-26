import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/features/settlements/domain/entities/settlement.dart';
import 'package:splito_flutter/features/settlements/presentation/providers/settlement_providers.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/empty_state_widget.dart';
import 'package:splito_flutter/shared/widgets/settlement_list_tile.dart';
import 'package:splito_flutter/shared/widgets/shimmer_wrapper.dart';
import 'package:splito_flutter/shared/widgets/skeletons/settlement_list_tile_skeleton.dart';

/// Screen displaying the settlement logs of a group.
class SettlementListPage extends ConsumerWidget {
  /// The unique identifier of the group.
  final String groupId;

  /// The name of the group.
  final String groupName;

  /// Creates a const [SettlementListPage] instance.
  const SettlementListPage({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settlementsAsync = ref.watch(groupSettlementsProvider(groupId));
    final groupDetail = ref.watch(groupDetailProvider(groupId)).valueOrNull;
    final members = groupDetail?.members ?? const [];
    final currency = groupDetail?.defaultCurrency ?? 'INR';

    void navigateToCreateSettlement() {
      context.goNamed(
        AppRoutes.createSettlementName,
        pathParameters: {'groupId': groupId},
        extra: {
          'groupName': groupName,
          'currency': currency,
          'members': members,
        },
      );
    }

    Future<void> handleRefresh() async {
      ref.read(groupSettlementsProvider(groupId).notifier).refresh();
      try {
        await ref.read(groupSettlementsProvider(groupId).future);
      } catch (_) {
        // Ignore to allow pull-to-refresh spinner to complete
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(groupName),
            Text(
              'Settlements',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: navigateToCreateSettlement,
          ),
        ],
      ),
      body: AsyncValueWidget<List<Settlement>>(
        value: settlementsAsync,
        onRetry: handleRefresh,
        loading: () => ShimmerWrapper(
          isLoading: true,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: 5,
            itemBuilder: (context, index) => const SettlementListTileSkeleton(),
          ),
        ),
        data: (settlements) {
          if (settlements.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.swap_horiz_rounded,
              title: 'No settlements yet',
              subtitle: 'Record a payment when someone settles up.',
              actionLabel: 'Record Payment',
              onAction: navigateToCreateSettlement,
            );
          }

          return RefreshIndicator(
            onRefresh: handleRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: settlements.length,
              itemBuilder: (context, index) {
                return SettlementListTile(
                  settlement: settlements[index],
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToCreateSettlement,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Record Payment'),
      ),
    );
  }
}
