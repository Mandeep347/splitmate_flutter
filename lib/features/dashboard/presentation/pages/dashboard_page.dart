import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:splito_flutter/core/network/connectivity_notifier.dart';
import 'package:splito_flutter/core/responsive/responsive_layout.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/balances/presentation/providers/balance_providers.dart';
import 'package:splito_flutter/features/groups/domain/entities/group.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/features/groups/presentation/widgets/group_card.dart';
import 'package:splito_flutter/features/groups/presentation/widgets/create_group_sheet.dart';
import 'package:splito_flutter/features/activity/presentation/providers/activity_providers.dart';
import 'package:splito_flutter/features/activity/domain/entities/activity_item.dart';
import 'package:splito_flutter/features/activity/presentation/widgets/activity_list_tile.dart';
import 'package:splito_flutter/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:splito_flutter/features/dashboard/presentation/widgets/wallet_card_painter.dart';
import 'package:splito_flutter/features/dashboard/presentation/widgets/dashboard_line_chart.dart';
import 'package:splito_flutter/features/dashboard/presentation/widgets/dashboard_category_pie_chart.dart';

import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/empty_state_widget.dart';
import 'package:splito_flutter/shared/widgets/amount_display.dart';
import 'package:splito_flutter/features/analytics/domain/entities/user_analytics.dart';
import 'package:splito_flutter/features/analytics/domain/utils/analytics_utils.dart';
import 'package:splito_flutter/features/analytics/presentation/providers/analytics_providers.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providers used in this widget
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final user = ref.watch(currentUserProvider);
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final userAnalyticsAsync = ref.watch(userAnalyticsProvider);
    final groupsAsync = ref.watch(myGroupsProvider);
    final activityAsync = ref.watch(globalActivityProvider);
    final categorySharesAsync = ref.watch(globalCategorySharesProvider);
    final isOnline = ref.watch(isOnlineProvider);

    final groups = groupsAsync.hasValue
        ? groupsAsync.requireValue
        : const <Group>[];
    final analytics = userAnalyticsAsync.hasValue
        ? userAnalyticsAsync.requireValue
        : UserAnalytics(
            userId: user?.id ?? '',
            userName: user?.name ?? '',
            totalPaidAllGroups: 0.0,
            totalOwedToOthers: 0.0,
            totalOthersOweUser: 0.0,
            netBalance: 0.0,
            totalGroupsCount: groups.length,
            totalExpenseCount: 0,
            groups: const [],
            monthlySpending: const [],
          );
    final activities = activityAsync.hasValue
        ? activityAsync.requireValue
        : const <ActivityItem>[];
    final categoryShares = categorySharesAsync.hasValue
        ? categorySharesAsync.requireValue
        : const <CategoryShare>[];

    final String greetingText = user != null
        ? '${_greeting()}, ${user.name}'
        : _greeting();

    Widget mainContent(List<Group> groups, UserAnalytics analytics) {
      final groupMap = {for (var g in groups) g.id: g};
      final shownGroups = analytics.groups
          .map((rg) => groupMap[rg.groupId])
          .whereType<Group>()
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Title (Mobile / Tablet)
          if (!isDesktop) ...[
            Text(
              greetingText,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Let's settle up and stay on track.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Balance Card
          _BalanceCard(netBalance: analytics.netBalance),

          // Most Expensive Group Callout/Badge
          if (analytics.mostExpensiveGroupName != null &&
              analytics.mostExpensiveGroupName!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.15,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Most expensive group: ${analytics.mostExpensiveGroupName}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Overview Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Overview Cards Grid
          _OverviewGrid(analytics: analytics, isDesktop: isDesktop),
          const SizedBox(height: 24),

          // Groups Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Groups',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.groupsPath),
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Groups List
          if (shownGroups.isEmpty)
            EmptyStateWidget(
              icon: Icons.group_outlined,
              title: 'No active groups',
              subtitle: 'Create a group to start sharing expenses.',
              actionLabel: 'Create Group',
              onAction: () => CreateGroupSheet.show(context),
            )
          else
            Column(
              children: shownGroups
                  .map((g) => GroupCard(group: g, compact: true))
                  .toList(),
            ),
        ],
      );
    }

    Widget sidebarContent(
      List<ActivityItem> activities,
      UserAnalytics analytics,
      List<CategoryShare> categories,
    ) {
      final recentActivities = activities.take(5).toList();
      final hasData = analytics.totalExpenseCount > 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!hasData) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(ext.spaceLG),
                child: const EmptyStateWidget(
                  icon: Icons.analytics_outlined,
                  title: 'No activity yet',
                  subtitle:
                      'Make groups and create expenses to see personalized analytics.',
                ),
              ),
            ),
          ] else ...[
            // Spending Overview Chart Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(ext.spaceLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending Overview',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DashboardLineChart(
                      monthlyData: fillMissingMonths(analytics.monthlySpending),
                      currency: 'INR',
                      height: 180,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Top Categories Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(ext.spaceLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Categories',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DashboardCategoryPieChart(shares: categories, height: 190),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Recent Activity Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(ext.spaceLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            context.go(AppRoutes.globalActivityPath),
                        child: const Text('View all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (recentActivities.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: Text(
                          'No recent activities',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: recentActivities
                          .map((a) => ActivityListTile(activity: a))
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget buildDashboardBody() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isOnline && !isDesktop) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
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
            const SizedBox(height: 16),
          ],
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(right: ext.spaceLG),
                    child: mainContent(groups, analytics),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: sidebarContent(activities, analytics, categoryShares),
                ),
              ],
            )
          else
            Column(
              children: [
                mainContent(groups, analytics),
                const SizedBox(height: 24),
                sidebarContent(activities, analytics, categoryShares),
                const SizedBox(height: 80),
              ],
            ),
        ],
      );
    }

    // Bug 1 Fix: Wrap body in SafeArea on mobile/tablet to prevent greeting
    // text from overlapping the device status bar.
    return Scaffold(
      body: SafeArea(
        // On desktop the shell already handles safe areas via the sidebar;
        // only apply top SafeArea on mobile/tablet.
        top: !isDesktop,
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myGroupsProvider);
            ref.invalidate(myOverallBalancesProvider);
            ref.invalidate(globalActivityProvider);
            ref.invalidate(userAnalyticsProvider);
            try {
              await ref.read(myGroupsProvider.future);
              await ref.read(myOverallBalancesProvider.future);
              await ref.read(userAnalyticsProvider.future);
            } catch (_) {}
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isDesktop ? ext.spaceXL : ext.spaceLG),
            child: (groupsAsync.hasError && groups.isEmpty)
                ? AsyncValueWidget<List<Group>>(
                    value: groupsAsync,
                    onRetry: () {
                      ref.invalidate(myGroupsProvider);
                      ref.invalidate(myOverallBalancesProvider);
                    },
                    data: (_) => buildDashboardBody(),
                  )
                : (groupsAsync.isLoading && groups.isEmpty)
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : buildDashboardBody(),
          ),
        ),
      ),
    );
  }
}

/// Dynamic Apple Wallet / Premium Card for balance details
class _BalanceCard extends StatelessWidget {
  final double netBalance;

  const _BalanceCard({required this.netBalance});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    final isOwed = netBalance >= 0;
    final balanceText = isOwed ? 'You will get' : 'You need to pay';
    const balanceColor = Colors.white;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 8,
      shadowColor: ext.primaryGradient.colors.first.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ext.radiusXL),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ext.radiusXL),
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(gradient: ext.primaryGradient),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: WalletCardPainter(
                    primaryColor: theme.colorScheme.primary,
                  ),
                ),
              ),
              // Card Details
              Padding(
                padding: EdgeInsets.all(ext.spaceXL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Balance',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              balanceText,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                        // Tiny card chip
                        Container(
                          width: 38,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(ext.radiusXS),
                          ),
                          child: Icon(
                            Icons.wallet_rounded,
                            color: Colors.white.withValues(alpha: 0.75),
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    AmountDisplay(
                      amount: netBalance.abs(),
                      currency: 'INR',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: balanceColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'All active groups',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Overview Grid displaying global stats cards
class _OverviewGrid extends StatelessWidget {
  final UserAnalytics analytics;
  final bool isDesktop;

  const _OverviewGrid({required this.analytics, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    final List<_OverviewItem> items = [
      _OverviewItem(
        title: 'Total Paid',
        amount: analytics.totalPaidAllGroups,
        icon: Icons.payment_outlined,
        color: const Color(0xFF14B8A6), // Teal
        subtitle: 'Across all groups',
      ),
      _OverviewItem(
        title: 'You Need to Pay',
        amount: analytics.totalOwedToOthers,
        icon: Icons.account_balance_outlined,
        color: const Color(0xFFEF4444), // Red
        subtitle: 'Need to pay others',
      ),
      _OverviewItem(
        title: 'You Will Get',
        amount: analytics.totalOthersOweUser,
        icon: Icons.account_balance_wallet_outlined,
        color: const Color(0xFF6366F1), // Indigo
        subtitle: 'You will get',
      ),
      _OverviewItem(
        title: 'Net Balance',
        amount: analytics.netBalance,
        icon: Icons.account_balance_wallet_outlined,
        color: analytics.netBalance >= 0
            ? const Color(0xFF14B8A6)
            : const Color(0xFFEF4444),
        subtitle: 'Overall net share',
      ),
    ];

    if (isDesktop) {
      return Row(
        children: items
            .map(
              (item) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ext.spaceXS),
                  child: _StatCard(item: item),
                ),
              ),
            )
            .toList(),
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          final double cardWidth = (constraints.maxWidth - ext.spaceSM) / 2;
          return Wrap(
            spacing: ext.spaceSM,
            runSpacing: ext.spaceSM,
            children: items
                .map(
                  (item) => SizedBox(
                    width: cardWidth,
                    child: _StatCard(item: item),
                  ),
                )
                .toList(),
          );
        },
      );
    }
  }
}

class _OverviewItem {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final String subtitle;

  _OverviewItem({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.subtitle,
  });
}

class _StatCard extends StatelessWidget {
  final _OverviewItem item;

  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(ext.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(ext.spaceXS),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, size: 16, color: item.color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AmountDisplay(
              amount: item.amount.abs(),
              currency: 'INR',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.subtitle,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
