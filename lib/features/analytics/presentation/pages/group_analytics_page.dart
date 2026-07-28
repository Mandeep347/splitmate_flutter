import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/empty_state_widget.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';
import 'package:splito_flutter/shared/widgets/amount_display.dart';
import 'package:splito_flutter/features/expenses/presentation/providers/expense_providers.dart';
import 'package:splito_flutter/features/analytics/domain/entities/group_analytics.dart';
import 'package:splito_flutter/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:splito_flutter/features/analytics/presentation/widgets/monthly_spending_chart.dart';
import 'package:splito_flutter/features/analytics/presentation/widgets/member_contribution_chart.dart';
import 'package:splito_flutter/features/analytics/presentation/widgets/analytics_summary_card.dart';
import 'package:splito_flutter/features/analytics/presentation/widgets/top_payer_badge.dart';
import 'package:share_plus/share_plus.dart';
import 'package:splito_flutter/features/analytics/domain/services/export_service.dart';
import 'package:splito_flutter/features/analytics/presentation/widgets/settlement_progress_bar.dart';
import 'package:splito_flutter/features/analytics/domain/utils/analytics_utils.dart';
import 'package:splito_flutter/shared/widgets/skeletons/analytics_skeleton.dart';

/// Screen presenting client-side visual statistics and charts for a group's expenses.
class GroupAnalyticsPage extends ConsumerWidget {
  /// The unique identifier of the group.
  final String groupId;

  /// The display name of the group.
  final String groupName;

  /// The currency code.
  final String currency;

  /// Creates a new [GroupAnalyticsPage] instance.
  const GroupAnalyticsPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.currency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final analyticsAsync = ref.watch(groupAnalyticsProvider(groupId));
    final analytics = analyticsAsync.valueOrNull;
    final hasData = analytics != null && analytics.hasData;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(groupName),
            Text(
              'Analytics',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share summary',
            onPressed: hasData
                ? () => _shareAnalytics(context, ref, analytics)
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              ref.invalidate(groupAnalyticsProvider(groupId));
              ref.invalidate(groupExpensesProvider(groupId));
            },
          ),
        ],
      ),
      body: AsyncValueWidget<GroupAnalytics>(
        value: analyticsAsync,
        loading: () => const AnalyticsSkeleton(),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart_outlined,
                  size: 48,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 12),
                Text(
                  'Could not load analytics',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  error.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Try Again',
                  onPressed: () {
                    ref.invalidate(groupAnalyticsProvider(groupId));
                    ref.invalidate(groupExpensesProvider(groupId));
                  },
                ),
              ],
            ),
          ),
        ),
        data: (analytics) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(groupAnalyticsProvider(groupId));
              ref.invalidate(groupExpensesProvider(groupId));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: !analytics.hasData
                  ? const EmptyStateWidget(
                      icon: Icons.bar_chart_outlined,
                      title: 'No analytics yet',
                      subtitle:
                          'Add expenses to see spending insights for this group.',
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 720;

                        Widget leftColumn() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnalyticsSummaryCard(
                                analytics: analytics,
                                currency: currency,
                              ),
                              const SizedBox(height: 16),
                              const _SectionHeader(title: 'Monthly Spending'),
                              Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: MonthlySpendingChart(
                                    monthlyData: fillMissingMonths(
                                      analytics.monthlySpending,
                                    ),
                                    currency: currency,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const _SectionHeader(title: 'Who Paid Most'),
                              Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: MemberContributionChart(
                                    contributions:
                                        analytics.memberContributions,
                                    totalAmount: analytics.totalExpenses,
                                    currency: currency,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        Widget rightColumn() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (analytics.topPayer != null) ...[
                                TopPayerBadge(
                                  contribution: analytics.topPayer!,
                                  currency: currency,
                                ),
                                const SizedBox(height: 16),
                              ],
                              const _SectionHeader(
                                title: 'Settlement Progress',
                              ),
                              Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Settled',
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                          Text(
                                            '${(analytics.settlementRate * 100).toStringAsFixed(0)}%',
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  color:
                                                      theme.colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      SettlementProgressBar(
                                        value: analytics.settlementRate,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Total Expenses',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      color: theme
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                              ),
                                              const SizedBox(height: 2),
                                              AmountDisplay(
                                                amount: analytics.totalExpenses,
                                                currency: currency,
                                                style: theme
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Total Settled',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      color: theme
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                              ),
                                              const SizedBox(height: 2),
                                              AmountDisplay(
                                                amount: analytics.totalSettled,
                                                currency: currency,
                                                style: theme
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      color:
                                                          Colors.green.shade600,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: leftColumn()),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: rightColumn()),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              leftColumn(),
                              const SizedBox(height: 16),
                              rightColumn(),
                              const SizedBox(height: 80),
                            ],
                          );
                        }
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  void _shareAnalytics(
    BuildContext context,
    WidgetRef ref,
    GroupAnalytics analytics,
  ) {
    final exportService = ref.read(exportServiceProvider);
    final text = exportService.generateGroupSummary(
      analytics: analytics,
      groupName: groupName,
      currency: currency,
    );
    Share.share(text, subject: '$groupName — Expense Summary');
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
