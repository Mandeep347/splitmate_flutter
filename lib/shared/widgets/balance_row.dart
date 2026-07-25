import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/theme/financial_colors.dart';
import 'package:splito_flutter/features/auth/domain/entities/logged_in_user.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/balances/domain/entities/pairwise_balance.dart';
import 'amount_display.dart';
import 'member_avatar.dart';

/// Card item widget representing a single debt balance relationship.
class BalanceRow extends ConsumerWidget {
  /// The pairwise debt balance representation.
  final PairwiseBalance balance;

  /// Option to show a settle button on the right.
  final bool showSettleButton;

  /// Callback triggered when tapping the settle button.
  final VoidCallback? onSettle;

  /// Creates a const [BalanceRow] instance.
  const BalanceRow({
    super.key,
    required this.balance,
    this.showSettleButton = false,
    this.onSettle,
  });

  String _displayName(String? userId, String name, LoggedInUser? me) {
    if (me == null) return name;
    if (userId != null && userId == me.id) return 'You';
    if (userId == null && name == me.name) return 'You';
    return name;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);

    final fromLabel = _displayName(balance.fromUserId, balance.fromUserName, currentUser);
    final toLabel = _displayName(balance.toUserId, balance.toUserName, currentUser);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Left Member Avatar
            MemberAvatar(name: balance.fromUserName, radius: 18),
            const SizedBox(width: 12),

            // Center details column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: fromLabel,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: ' → '),
                              TextSpan(
                                text: toLabel,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AmountDisplay(
                    amount: balance.amount,
                    currency: balance.currency,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    color: theme.colorScheme.oweColor,
                  ),
                ],
              ),
            ),

            // Right Settle Action Button
            if (showSettleButton && onSettle != null) ...[
              const SizedBox(width: 12),
              TextButton(
                onPressed: onSettle,
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.owedColor,
                ),
                child: const Text('Settle'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
