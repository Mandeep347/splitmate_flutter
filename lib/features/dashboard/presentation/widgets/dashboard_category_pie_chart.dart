import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:splito_flutter/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';

/// Enhanced, interactive pie chart widget for Dashboard category spending breakdown.
class DashboardCategoryPieChart extends StatefulWidget {
  /// List of category shares to render.
  final List<CategoryShare> shares;

  /// Height of the chart widget container.
  final double height;

  /// Creates a stateful [DashboardCategoryPieChart] instance.
  const DashboardCategoryPieChart({
    super.key,
    required this.shares,
    this.height = 210,
  });

  @override
  State<DashboardCategoryPieChart> createState() =>
      _DashboardCategoryPieChartState();
}

class _DashboardCategoryPieChartState extends State<DashboardCategoryPieChart> {
  int _touchedIndex = -1;

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.foodAndDining:
        return const Color(0xFF6366F1); // Indigo
      case ExpenseCategory.travel:
        return const Color(0xFF10B981); // Emerald / Teal
      case ExpenseCategory.shopping:
        return const Color(0xFFF59E0B); // Amber
      case ExpenseCategory.billsAndUtilities:
        return const Color(0xFFEF4444); // Rose / Red
      case ExpenseCategory.other:
        return const Color(0xFF8B5CF6); // Purple / Violet
    }
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.foodAndDining:
        return Icons.restaurant_rounded;
      case ExpenseCategory.travel:
        return Icons.flight_takeoff_rounded;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag_rounded;
      case ExpenseCategory.billsAndUtilities:
        return Icons.receipt_long_rounded;
      case ExpenseCategory.other:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    if (widget.shares.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            'No spending data available',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final hasSelection =
        _touchedIndex >= 0 && _touchedIndex < widget.shares.length;
    final selectedShare = hasSelection ? widget.shares[_touchedIndex] : null;

    final sections = widget.shares.asMap().entries.map((entry) {
      final idx = entry.key;
      final share = entry.value;
      final isTouched = idx == _touchedIndex;
      final percentageVal = (share.percentage * 100).toStringAsFixed(0);
      final color = _getCategoryColor(share.category);

      return PieChartSectionData(
        color: color,
        value: share.percentage,
        title: isTouched ? '$percentageVal%' : '',
        radius: isTouched ? 44 : 36,
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _getCategoryIcon(share.category),
                  size: 14,
                  color: color,
                ),
              )
            : null,
        badgePositionPercentageOffset: 0.98,
        titleStyle: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        borderSide: isTouched
            ? BorderSide(color: theme.colorScheme.surface, width: 2)
            : BorderSide.none,
      );
    }).toList();

    return SizedBox(
      height: widget.height,
      child: Row(
        children: [
          // Left Donut Chart with Center Stack
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _touchedIndex = -1;
                            return;
                          }
                          _touchedIndex = pieTouchResponse
                              .touchedSection!
                              .touchedSectionIndex;
                        });
                      },
                    ),
                    sectionsSpace: 3,
                    centerSpaceRadius: 46,
                    sections: sections,
                  ),
                ),

                // Center Info Badge
                PointerInterceptorIgnore(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selectedShare != null
                            ? _getCategoryIcon(selectedShare.category)
                            : Icons.donut_large_rounded,
                        size: 18,
                        color: selectedShare != null
                            ? _getCategoryColor(selectedShare.category)
                            : theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedShare != null
                            ? '${(selectedShare.percentage * 100).toStringAsFixed(0)}%'
                            : 'Top Share',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        selectedShare != null
                            ? selectedShare.category.displayName
                            : 'Categories',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: ext.spaceMD),

          // Right Category Legend List
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.shares.asMap().entries.map((entry) {
                final idx = entry.key;
                final share = entry.value;
                final color = _getCategoryColor(share.category);
                final icon = _getCategoryIcon(share.category);
                final isSelected = idx == _touchedIndex;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _touchedIndex = isSelected ? -1 : idx;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // Category Icon Pill
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(icon, size: 12, color: color),
                        ),
                        const SizedBox(width: 8),

                        // Name
                        Expanded(
                          child: Text(
                            share.category.displayName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isSelected
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Percentage Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color
                                : theme.colorScheme.surfaceContainerHighest
                                      .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${(share.percentage * 100).toStringAsFixed(0)}%',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper stub for pointer interception compatibility
class PointerInterceptorIgnore extends StatelessWidget {
  final Widget child;
  const PointerInterceptorIgnore({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}
