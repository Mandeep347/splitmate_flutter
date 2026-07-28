import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:splito_flutter/features/analytics/domain/entities/monthly_spending.dart';

/// A sleek line chart displaying spending overview trends across months.
class DashboardLineChart extends StatelessWidget {
  /// The list of monthly spending records.
  final List<MonthlySpending> monthlyData;

  /// The currency code.
  final String currency;

  /// The height of the chart.
  final double height;

  /// Creates a new [DashboardLineChart] instance.
  const DashboardLineChart({
    super.key,
    required this.monthlyData,
    required this.currency,
    this.height = 200,
  });

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

  String _shortMonthYearLabel(MonthlySpending item) {
    final parts = item.monthLabel.trim().split(RegExp(r'\s+'));
    final monthStr = parts.isNotEmpty ? parts.first : item.monthLabel;
    final shortYear = "'${(item.year % 100).toString().padLeft(2, '0')}";
    return '$monthStr $shortYear';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (monthlyData.isEmpty) {
      return SizedBox(
        height: height,
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

    final spots = monthlyData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.totalAmount);
    }).toList();

    // Determine interval step based on total data points to prevent X-axis text overlap
    final totalPoints = monthlyData.length;
    final int intervalStep;
    if (totalPoints <= 6) {
      intervalStep = 1;
    } else if (totalPoints <= 9) {
      intervalStep = 2;
    } else {
      intervalStep = 3;
    }

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0, top: 12.0),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) =>
                    theme.colorScheme.surfaceContainerHighest,
                tooltipRoundedRadius: 10,
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    if (index < 0 || index >= monthlyData.length) return null;
                    final item = monthlyData[index];
                    final symbol = _currencySymbol(currency);
                    final formatter = NumberFormat('#,##0.00');
                    final formattedAmount =
                        '$symbol${formatter.format(spot.y)}';
                    return LineTooltipItem(
                      '${item.periodLabel}\n$formattedAmount',
                      theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ) ??
                          const TextStyle(),
                    );
                  }).toList();
                },
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxY > 0 ? (maxY / 3) : 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.3,
                  ),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  interval: maxY > 0 ? (maxY / 3) : 1,
                  getTitlesWidget: (value, meta) {
                    if (value == 0 || value >= meta.max * 0.95) {
                      return const SizedBox.shrink();
                    }
                    final symbol = _currencySymbol(currency);
                    final String label = value >= 1000
                        ? '$symbol${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k'
                        : '$symbol${value.toStringAsFixed(0)}';
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 6,
                      child: Text(
                        label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: intervalStep.toDouble(),
                  getTitlesWidget: (value, meta) {
                    final index = value.round();
                    if (index < 0 || index >= monthlyData.length) {
                      return const SizedBox.shrink();
                    }
                    // Only show title if it falls on interval step or is the last element
                    if (index % intervalStep != 0 &&
                        index != monthlyData.length - 1) {
                      return const SizedBox.shrink();
                    }

                    final label = _shortMonthYearLabel(monthlyData[index]);
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 6,
                      child: Text(
                        label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (monthlyData.length - 1).toDouble(),
            minY: 0,
            maxY: maxY,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.35,
                preventCurveOverShooting: true,
                color: theme.colorScheme.primary,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 3,
                      color: theme.colorScheme.primary,
                      strokeWidth: 1.5,
                      strokeColor: theme.colorScheme.surface,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.25),
                      theme.colorScheme.primary.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
