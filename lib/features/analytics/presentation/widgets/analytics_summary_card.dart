import 'package:flutter/material.dart';
import 'package:splito_flutter/features/analytics/domain/entities/group_analytics.dart';
import 'package:splito_flutter/shared/widgets/amount_display.dart';

/// Card component displaying group overview metrics inside a responsive grid.
class AnalyticsSummaryCard extends StatelessWidget {
  /// The group analytics computed metrics.
  final GroupAnalytics analytics;

  /// The currency code.
  final String currency;

  /// Creates a new [AnalyticsSummaryCard] instance.
  const AnalyticsSummaryCard({
    super.key,
    required this.analytics,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final useRow = constraints.maxWidth > 550;

                final cells = [
                  _StatCell(
                    label: 'Total Spent',
                    child: AmountDisplay(
                      amount: analytics.totalExpenses,
                      currency: currency,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _StatCell(
                    label: 'Avg Expense',
                    child: AmountDisplay(
                      amount: analytics.averageExpenseAmount,
                      currency: currency,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _StatCell(
                    label: 'Expenses',
                    child: Text(
                      '${analytics.totalExpenseCount}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _StatCell(
                    label: 'Largest',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AmountDisplay(
                          amount: analytics.largestExpense,
                          currency: currency,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (analytics.largestExpenseTitle != null &&
                            analytics.largestExpenseTitle!.isNotEmpty)
                          Text(
                            analytics.largestExpenseTitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ];

                if (useRow) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: cells
                          .map((cell) => Expanded(child: cell))
                          .toList(),
                    ),
                  );
                } else {
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.0,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: cells,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final Widget child;

  const _StatCell({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
