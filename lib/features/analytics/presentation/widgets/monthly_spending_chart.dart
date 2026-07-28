import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:splito_flutter/features/analytics/domain/entities/monthly_spending.dart';

/// A modern, interactive bar chart widget presenting monthly spending trends.
class MonthlySpendingChart extends StatefulWidget {
  /// The monthly spending data points.
  final List<MonthlySpending> monthlyData;

  /// The currency code.
  final String currency;

  /// The height of the chart container.
  final double height;

  /// Creates a new [MonthlySpendingChart] instance.
  const MonthlySpendingChart({
    super.key,
    required this.monthlyData,
    required this.currency,
    this.height = 220,
  });

  @override
  State<MonthlySpendingChart> createState() => _MonthlySpendingChartState();
}

class _MonthlySpendingChartState extends State<MonthlySpendingChart> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _currencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'INR':
        return '₹';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return '$currencyCode ';
    }
  }

  String _shortMonth(String monthLabel) {
    final parts = monthLabel.trim().split(RegExp(r'\s+'));
    return parts.isNotEmpty ? parts.first : monthLabel;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthlyData = widget.monthlyData;

    if (monthlyData.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            'No spending data yet',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final maxAmount = monthlyData.map((e) => e.totalAmount).reduce(max);
    final maxY = maxAmount == 0.0 ? 10.0 : maxAmount * 1.2;

    const double barWidth = 18.0;
    const double barItemSpacing = 54.0;
    final isScrollable = monthlyData.length > 5;

    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth;
        final chartContentWidth = isScrollable
            ? max(containerWidth, monthlyData.length * barItemSpacing)
            : containerWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isScrollable) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.swipe_left_rounded,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Scroll for more months',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(
              height: widget.height,
              child: Row(
                children: [
                  // Scrollable Chart Body
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: SizedBox(
                        width: chartContentWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 12.0,
                            top: 12.0,
                          ),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: maxY,
                              barTouchData: BarTouchData(
                                handleBuiltInTouches: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (_) =>
                                      theme.colorScheme.surfaceContainerHighest,
                                  tooltipRoundedRadius: 10,
                                  tooltipPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    final item = monthlyData[groupIndex];
                                    final symbol = _currencySymbol(
                                      widget.currency,
                                    );
                                    final formatter = NumberFormat('#,##0.00');
                                    final formattedAmount =
                                        '$symbol${formatter.format(rod.toY)}';
                                    final countText = item.expenseCount == 1
                                        ? '1 expense'
                                        : '${item.expenseCount} expenses';
                                    return BarTooltipItem(
                                      '${item.periodLabel}\n$formattedAmount\n$countText',
                                      theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ) ??
                                          const TextStyle(),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 36,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      if (index < 0 ||
                                          index >= monthlyData.length) {
                                        return const SizedBox.shrink();
                                      }
                                      final item = monthlyData[index];
                                      final shortMonth = _shortMonth(
                                        item.monthLabel,
                                      );
                                      final shortYear =
                                          "'${(item.year % 100).toString().padLeft(2, '0')}";

                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        space: 4,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              shortMonth,
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurface,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                            ),
                                            Text(
                                              shortYear,
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                    fontSize: 9,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 38,
                                    interval: maxY > 0 ? (maxY / 3) : 1,
                                    getTitlesWidget: (value, meta) {
                                      if (value == 0 ||
                                          value >= meta.max * 0.95) {
                                        return const SizedBox.shrink();
                                      }
                                      final symbol = _currencySymbol(
                                        widget.currency,
                                      );
                                      final String label = value >= 1000
                                          ? '$symbol${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k'
                                          : '$symbol${value.toStringAsFixed(0)}';
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        space: 6,
                                        child: Text(
                                          label,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                                fontSize: 10,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: maxY > 0 ? (maxY / 3) : 1,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: theme.colorScheme.outlineVariant
                                        .withValues(alpha: 0.3),
                                    strokeWidth: 1,
                                    dashArray: [4, 4],
                                  );
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: monthlyData.asMap().entries.map((e) {
                                final isHighest =
                                    e.value.totalAmount == maxAmount &&
                                    maxAmount > 0;
                                return BarChartGroupData(
                                  x: e.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: e.value.totalAmount,
                                      gradient: LinearGradient(
                                        colors: [
                                          isHighest
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.primary
                                                    .withValues(alpha: 0.75),
                                          theme.colorScheme.primary.withValues(
                                            alpha: 0.4,
                                          ),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      width: barWidth,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
