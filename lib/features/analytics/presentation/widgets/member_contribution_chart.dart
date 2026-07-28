import 'package:flutter/material.dart';
import 'package:splito_flutter/features/analytics/domain/entities/member_contribution.dart';
import 'package:splito_flutter/shared/widgets/member_avatar.dart';
import 'package:splito_flutter/shared/widgets/amount_display.dart';

/// A widget displaying each member's payment contribution as progress bars.
class MemberContributionChart extends StatelessWidget {
  /// The list of member contributions.
  final List<MemberContribution> contributions;

  /// The total transaction spending amount in the group.
  final double totalAmount;

  /// The currency code.
  final String currency;

  /// Creates a new [MemberContributionChart] instance.
  const MemberContributionChart({
    super.key,
    required this.contributions,
    required this.totalAmount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (contributions.isEmpty || totalAmount == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Text(
            'No contributions yet',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    // Display top 5 members by totalPaid, sorted descending
    final displayedContributions = contributions.take(5).toList();

    return Column(
      children: [
        for (final c in displayedContributions) ...[
          Row(
            children: [
              MemberAvatar(name: c.name, radius: 14),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          c.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AmountDisplay(
                          amount: c.totalPaid,
                          currency: currency,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: (c.percentageOfTotal / 100.0).clamp(0.0, 1.0),
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(
                        theme.colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${c.percentageOfTotal.toStringAsFixed(0)}%',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
