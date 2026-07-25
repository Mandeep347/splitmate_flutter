import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/theme/financial_colors.dart';
import 'package:splito_flutter/features/balances/presentation/providers/balance_providers.dart';
import 'amount_display.dart';

/// Card component showing user's cross-group outstanding net owed summary.
class OverallBalanceCard extends ConsumerWidget {
  /// Creates a const [OverallBalanceCard] instance.
  const OverallBalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final balancesAsync = ref.watch(myOverallBalancesProvider);

    // If loading, show shimmer-like placeholder container
    if (balancesAsync.isLoading) {
      return Container(
        margin: const EdgeInsets.all(16),
        height: 64,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    final totalOwed = ref.watch(totalOwedProvider);
    final totalOwedToMe = ref.watch(totalOwedToMeProvider);
    final currency = balancesAsync.valueOrNull?.firstOrNull?.currency ?? 'INR';

    // If fully settled up (both balances are 0.0)
    if (totalOwed <= 0 && totalOwedToMe <= 0) {
      return Card(
        margin: const EdgeInsets.all(16),
        elevation: 0,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: theme.colorScheme.owedColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'All settled up!',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left Column: You need to pay
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You need to pay',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AmountDisplay(
                      amount: totalOwed,
                      currency: currency,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      color: theme.colorScheme.oweColor,
                    ),
                  ],
                ),
              ),

              // Vertical divider separating details
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),

              // Right Column: You will get
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You will get',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AmountDisplay(
                      amount: totalOwedToMe,
                      currency: currency,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      color: theme.colorScheme.owedColor,
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
