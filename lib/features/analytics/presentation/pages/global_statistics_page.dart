import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:splito_flutter/features/dashboard/presentation/widgets/dashboard_line_chart.dart';
import 'package:splito_flutter/features/dashboard/presentation/widgets/dashboard_category_pie_chart.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/empty_state_widget.dart';

class GlobalStatisticsPage extends ConsumerWidget {
  const GlobalStatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    final statsAsync = ref.watch(dashboardStatsProvider);
    final categorySharesAsync = ref.watch(globalCategorySharesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              ref.invalidate(dashboardStatsProvider);
              ref.invalidate(globalMonthlySpendingProvider);
              ref.invalidate(globalCategorySharesProvider);
            },
          ),
        ],
      ),
      body: AsyncValueWidget<DashboardStats>(
        value: statsAsync,
        data: (stats) {
          return AsyncValueWidget<List<dynamic>>(
            value: ref.watch(globalMonthlySpendingProvider),
            data: (monthlySpending) {
              return AsyncValueWidget<List<CategoryShare>>(
                value: categorySharesAsync,
                data: (categoryShares) {
                  final hasSpending = monthlySpending.isNotEmpty;

                  if (!hasSpending) {
                    return const EmptyStateWidget(
                      icon: Icons.bar_chart_outlined,
                      title: 'No stats yet',
                      subtitle: 'Add expenses to see detailed analytics.',
                    );
                  }

                  return ListView(
                    padding: EdgeInsets.all(ext.spaceLG),
                    children: [
                      // Section 1: Monthly spending line chart
                      Text(
                        'Spending Overview',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.all(ext.spaceLG),
                          child: DashboardLineChart(
                            monthlyData: monthlySpending.cast(),
                            currency: 'INR',
                            height: 200,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section 2: Top categories pie chart
                      Text(
                        'Top Categories',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.all(ext.spaceLG),
                          child: DashboardCategoryPieChart(
                            shares: categoryShares,
                            height: 180,
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
