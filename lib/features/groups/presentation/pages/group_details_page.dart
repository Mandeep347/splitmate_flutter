import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/responsive/responsive_layout.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/groups/domain/entities/group.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/features/groups/presentation/widgets/add_member_sheet.dart';
import 'package:splito_flutter/features/groups/presentation/widgets/edit_group_name_sheet.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/confirmation_dialog.dart';
import 'package:splito_flutter/shared/widgets/info_row.dart';
import 'package:splito_flutter/shared/widgets/member_avatar.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/core/theme/financial_colors.dart';
import 'package:splito_flutter/features/balances/presentation/providers/balance_providers.dart';
import 'package:splito_flutter/features/balances/domain/entities/group_balances.dart';
import 'package:splito_flutter/shared/widgets/balance_row.dart';
import 'package:splito_flutter/features/activity/presentation/providers/activity_providers.dart';
import 'package:splito_flutter/features/activity/presentation/widgets/activity_list_tile.dart';
import 'package:splito_flutter/features/activity/domain/entities/activity_feed.dart';
import 'package:splito_flutter/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:splito_flutter/shared/widgets/amount_display.dart';

class GroupDetailsPage extends ConsumerWidget {
  final String groupId;

  const GroupDetailsPage({
    super.key,
    required this.groupId,
  });

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    double? width,
  }) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final isDisabled = onTap == null;

    return SizedBox(
      width: width,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: ext.spaceXS, vertical: ext.spaceXS),
        elevation: 0,
        color: isDisabled
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ext.radiusMD),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: isDisabled ? 0.1 : 0.3),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: ext.spaceMD),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isDisabled
                      ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)
                      : theme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(height: ext.spaceXS),
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDisabled
                        ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)
                        : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final detailAsync = ref.watch(groupDetailProvider(groupId));
    final group = detailAsync.valueOrNull;
    final balancesAsync = ref.watch(groupBalancesProvider(groupId));
    final isSettled = balancesAsync.hasValue && (balancesAsync.value?.isAllSettled ?? false);
    final currentUser = ref.watch(currentUserProvider);
    final isDesktop = ResponsiveLayout.isDesktop(context);

    final isAdmin = group != null &&
        (group.createdBy == currentUser?.id ||
            group.members.any((m) => m.userId == currentUser?.id && m.isAdmin));

    // Listen to delete group mutation
    ref.listen<AsyncValue<void>>(archiveGroupProvider, (previous, next) {
      if (next is AsyncData<void> && previous is AsyncLoading<void>) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group deleted!')),
        );
        context.pop();
      } else if (next is AsyncError<void> && previous is AsyncLoading<void>) {
        final errorMessage =
            next.error is Failure ? (next.error as Failure).message : 'Failed to delete group.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    Widget membersCard(Group group) {
      final shownMembers = group.members.take(6).toList();
      final extraCount = group.members.length - 6;

      return Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(ext.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Members (${group.membersCount})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () async => await AddMemberSheet.show(context, groupId),
                    child: const Text('+ Add Member'),
                  ),
                ],
              ),
              SizedBox(height: ext.spaceSM),
              if (group.members.isEmpty)
                Text(
                  'No members yet',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                Wrap(
                  spacing: ext.spaceSM,
                  runSpacing: ext.spaceSM,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...shownMembers.map((m) => MemberAvatar(name: m.name, radius: 18)),
                    if (extraCount > 0)
                      Padding(
                        padding: EdgeInsets.only(left: ext.spaceXS),
                        child: Text(
                          '+$extraCount more',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Builder(
                    builder: (context) {
                      final totalSpent = ref.watch(groupTotalSpentProvider(groupId));
                      final symbol = group.defaultCurrency == 'INR'
                          ? '₹'
                          : (group.defaultCurrency == 'USD' ? '\$' : '${group.defaultCurrency} ');
                      final formatter = NumberFormat('#,##0.00');
                      final formattedTotal = '$symbol${formatter.format(totalSpent)}';

                      return Text(
                        totalSpent > 0 ? 'Total spent: $formattedTotal' : 'No expenses yet',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget balancesCard(Group group) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(ext.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balances',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ext.spaceSM),
              AsyncValueWidget<GroupBalances>(
                value: ref.watch(groupBalancesProvider(groupId)),
                loading: () => const SizedBox(
                  height: 48,
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
                data: (groupBalances) {
                  if (groupBalances.isAllSettled) {
                    return Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: theme.colorScheme.owedColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'All settled up!',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    );
                  }

                  final balances = groupBalances.balances;
                  final shown = balances.take(3).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...shown.map((b) => BalanceRow(
                            balance: b,
                            showSettleButton: false,
                          )),
                      if (balances.length > 3)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.goNamed(
                                AppRoutes.groupBalancesName,
                                pathParameters: {'groupId': groupId},
                                extra: {
                                  'groupName': group.name,
                                  'currency': group.defaultCurrency,
                                },
                              );
                            },
                            child: const Text('See all'),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    Widget recentActivityCard(Group group) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(ext.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Activity',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ext.spaceSM),
              AsyncValueWidget<ActivityFeed>(
                value: ref.watch(groupActivityProvider(groupId)),
                loading: () => const SizedBox(
                  height: 48,
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
                data: (feed) {
                  if (feed.items.isEmpty) {
                    return Text(
                      'No activity yet',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    );
                  }

                  final recent = feed.items.take(3).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...recent.map((activity) => ActivityListTile(activity: activity)),
                      if (feed.totalItems > 3)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.goNamed(
                                AppRoutes.activityFeedName,
                                pathParameters: {'groupId': groupId},
                                extra: {
                                  'groupName': group.name,
                                },
                              );
                            },
                            child: const Text('View all'),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    Widget analyticsTeaserCard(Group group) {
      return ref.watch(groupAnalyticsProvider(group.id)).when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (a) => a.hasData
                ? Card(
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(ext.spaceLG),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total spent',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AmountDisplay(
                                amount: a.totalExpenses,
                                currency: group.defaultCurrency,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Avg expense',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AmountDisplay(
                                amount: a.averageExpenseAmount,
                                currency: group.defaultCurrency,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () => context.goNamed(
                              AppRoutes.groupAnalyticsName,
                              pathParameters: {'groupId': group.id},
                              extra: {
                                'groupName': group.name,
                                'currency': group.defaultCurrency,
                              },
                            ),
                            child: const Text('Analytics →'),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          );
    }

    Widget quickActionsRow(Group group, double itemWidth) {
      return Wrap(
        children: [
          _buildActionItem(
            context,
            icon: Icons.receipt_long_outlined,
            label: 'Expenses',
            width: itemWidth,
            onTap: () {
              context.goNamed(
                AppRoutes.expenseListName,
                pathParameters: {'groupId': group.id},
                extra: {'groupName': group.name},
              );
            },
          ),
          _buildActionItem(
            context,
            icon: Icons.account_balance_wallet_outlined,
            label: 'Balances',
            width: itemWidth,
            onTap: () {
              context.goNamed(
                AppRoutes.groupBalancesName,
                pathParameters: {'groupId': group.id},
                extra: {
                  'groupName': group.name,
                  'currency': group.defaultCurrency,
                },
              );
            },
          ),
          _buildActionItem(
            context,
            icon: Icons.swap_horiz_rounded,
            label: 'Settle Up',
            width: itemWidth,
            onTap: isSettled
                ? null
                : () {
                    context.goNamed(
                      AppRoutes.createSettlementName,
                      pathParameters: {'groupId': group.id},
                      extra: {
                        'groupName': group.name,
                        'currency': group.defaultCurrency,
                        'members': group.members,
                      },
                    );
                  },
          ),
          _buildActionItem(
            context,
            icon: Icons.history_outlined,
            label: 'Activity',
            width: itemWidth,
            onTap: () {
              context.goNamed(
                AppRoutes.activityFeedName,
                pathParameters: {'groupId': group.id},
                extra: {
                  'groupName': group.name,
                },
              );
            },
          ),
          _buildActionItem(
            context,
            icon: Icons.bar_chart_outlined,
            label: 'Analytics',
            width: itemWidth,
            onTap: () {
              context.goNamed(
                AppRoutes.groupAnalyticsName,
                pathParameters: {'groupId': group.id},
                extra: {
                  'groupName': group.name,
                  'currency': group.defaultCurrency,
                },
              );
            },
          ),
        ],
      );
    }

    Widget metaInfoCard(Group group) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(ext.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Group Info',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ext.spaceMD),
              InfoRow(
                icon: Icons.attach_money_rounded,
                label: 'Default Currency',
                value: group.defaultCurrency,
              ),
              Divider(height: ext.spaceLG),
              InfoRow(
                icon: Icons.calendar_today_rounded,
                label: 'Created On',
                value: DateFormat('d MMM yyyy').format(group.createdAt),
              ),
              Divider(height: ext.spaceLG),
              InfoRow(
                icon: Icons.info_outline_rounded,
                label: 'Status',
                value: group.status,
                valueColor: group.isActive ? theme.colorScheme.primary : theme.colorScheme.error,
              ),
            ],
          ),
        ),
      );
    }

    void showMembersBottomSheet(Group g) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: theme.colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (modalContext) {
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.85,
            expand: false,
            builder: (sheetContext, scrollController) {
              return Padding(
                padding: EdgeInsets.all(ext.spaceMD),
                child: Column(
                  children: [
                    // Grab Handle
                    Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Group Members (${g.members.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(modalContext);
                            await AddMemberSheet.show(context, g.id);
                          },
                          icon: const Icon(Icons.person_add_rounded, size: 16),
                          label: const Text('Add Member'),
                          style: ElevatedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    // Members List
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: g.members.length,
                        itemBuilder: (context, index) {
                          final m = g.members[index];
                          final isCreator = m.userId == g.createdBy;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              leading: MemberAvatar(name: m.name, radius: 22),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      m.name,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (m.isAdmin || isCreator) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        isCreator ? 'Owner' : 'Admin',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              subtitle: Text(
                                m.email.isNotEmpty ? m.email : 'No email address',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    void showEditOptions(Group g) async {
      final value = await showMenu<String>(
        context: context,
        position: const RelativeRect.fromLTRB(100, 80, 0, 0),
        items: [
          const PopupMenuItem(
            value: 'add_member',
            child: Row(
              children: [
                Icon(Icons.person_add_outlined, size: 20),
                SizedBox(width: 10),
                Text('Add Member'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 20),
                SizedBox(width: 10),
                Text('Edit Group Name'),
              ],
            ),
          ),
          if (isAdmin)
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Delete Group', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
        ],
      );

      if (value == 'add_member') {
        if (context.mounted) await AddMemberSheet.show(context, g.id);
      } else if (value == 'edit') {
        if (context.mounted) await EditGroupNameSheet.show(context, g);
      } else if (value == 'delete') {
        if (context.mounted) {
          final confirm = await ConfirmationDialog.show(
            context,
            title: 'Delete Group',
            message: 'Are you sure you want to delete this group?',
            isDestructive: true,
          );
          if (confirm == true) {
            await ref.read(archiveGroupProvider.notifier).archive(groupId: groupId);
          }
        }
      }
    }

    double userWillGet = 0.0;
    double userNeedToPay = 0.0;

    if (balancesAsync.hasValue && currentUser != null) {
      final balances = balancesAsync.value!.balances;
      for (final b in balances) {
        if (b.toUserId == currentUser.id || b.toUserName == currentUser.name) {
          userWillGet += b.amount;
        } else if (b.fromUserId == currentUser.id || b.fromUserName == currentUser.name) {
          userNeedToPay += b.amount;
        }
      }
    }

    Widget buildBalanceSummaryBadge(String currency) {
      if (userWillGet == 0.0 && userNeedToPay == 0.0) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Colors.tealAccent, size: 14),
              SizedBox(width: 4),
              Text(
                'Settled in this group',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }

      return Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          if (userWillGet > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.6)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'You will get ',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Flexible(
                    child: AmountDisplay(
                      amount: userWillGet,
                      currency: currency,
                      style: const TextStyle(color: Color(0xFF6EE7B7), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          if (userNeedToPay > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.6)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'You need to pay ',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Flexible(
                    child: AmountDisplay(
                      amount: userNeedToPay,
                      currency: currency,
                      style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    if (isDesktop && group != null) {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(group.name),
              const SizedBox(height: 4),
              Row(
                children: [
                  InkWell(
                    onTap: () => showMembersBottomSheet(group),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_alt_rounded, size: 12, color: theme.colorScheme.onPrimaryContainer),
                          const SizedBox(width: 4),
                          Text(
                            '${group.membersCount} members',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  buildBalanceSummaryBadge(group.defaultCurrency),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () => showEditOptions(group),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(ext.spaceXL),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column (flex 3)
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    balancesCard(group),
                    const SizedBox(height: 16),
                    metaInfoCard(group),
                    const SizedBox(height: 16),
                    membersCard(group),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Right Column (flex 2)
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    quickActionsRow(group, 140),
                    const SizedBox(height: 16),
                    analyticsTeaserCard(group),
                    const SizedBox(height: 16),
                    recentActivityCard(group),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('Add Expense'),
          onPressed: () => context.goNamed(
            AppRoutes.createExpenseName,
            pathParameters: {'groupId': group.id},
            extra: {
              'groupName': group.name,
              'currency': group.defaultCurrency,
              'members': group.members,
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: AsyncValueWidget<Group>(
        value: detailAsync,
        onRetry: () => ref.invalidate(groupDetailProvider(groupId)),
        data: (group) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 175,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 12, right: 16),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          // Members Count Clickable Chip
                          InkWell(
                            onTap: () => showMembersBottomSheet(group),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.people_alt_rounded, color: Colors.white, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${group.membersCount} members',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Balance Badge
                          buildBalanceSummaryBadge(group.defaultCurrency),
                        ],
                      ),
                    ],
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Modern Deep Gradient Background
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF0F172A), // Deep Slate 900
                              Color(0xFF312E81), // Indigo 900
                              Color(0xFF1E1B4B), // Deep Purple
                            ],
                          ),
                        ),
                      ),
                      // Decorative Glowing Mesh Accents
                      Positioned(
                        top: -30,
                        right: -30,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF6366F1).withValues(alpha: 0.25),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -40,
                        left: 20,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF10B981).withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                    onPressed: () => showEditOptions(group),
                  ),
                ],
              ),
              SliverPadding(
                padding: EdgeInsets.all(ext.spaceLG),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    balancesCard(group),
                    const SizedBox(height: 12),
                    recentActivityCard(group),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = constraints.maxWidth / 3;
                        return quickActionsRow(group, itemWidth);
                      },
                    ),
                    const SizedBox(height: 12),
                    analyticsTeaserCard(group),
                    const SizedBox(height: 12),
                    metaInfoCard(group),
                    const SizedBox(height: 12),
                    membersCard(group),
                    const SizedBox(height: 80),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: group == null
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text('Add Expense'),
              onPressed: () => context.goNamed(
                AppRoutes.createExpenseName,
                pathParameters: {'groupId': group.id},
                extra: {
                  'groupName': group.name,
                  'currency': group.defaultCurrency,
                  'members': group.members,
                },
              ),
            ),
    );
  }
}
