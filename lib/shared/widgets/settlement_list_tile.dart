import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:splito_flutter/core/theme/financial_colors.dart';
import 'package:splito_flutter/features/auth/domain/entities/logged_in_user.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/settlements/domain/entities/settlement.dart';
import 'amount_display.dart';

/// Card tile representation for displaying summary details of a settlement.
class SettlementListTile extends ConsumerWidget {
  /// The settlement transaction details.
  final Settlement settlement;

  /// Creates a const [SettlementListTile] instance.
  const SettlementListTile({
    super.key,
    required this.settlement,
  });

  String _displayName(String? userId, String name, LoggedInUser? me) {
    if (me == null) return name;
    if (userId != null && userId == me.id) return 'You';
    if (userId == null && name == me.name) return 'You';
    return name;
  }

  String _paidToLabel(String toUserId, String toName, LoggedInUser? me) {
    if (me != null && toUserId == me.id) return 'you';
    return toName;
  }

  String _getRelativeDate(DateTime createdAt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final created = DateTime(createdAt.year, createdAt.month, createdAt.day);

    if (created == today) {
      return 'Today';
    } else if (created == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM').format(createdAt);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final relativeDate = _getRelativeDate(settlement.createdAt);
    final currentUser = ref.watch(currentUserProvider);

    final fromLabel = _displayName(settlement.fromUserId, settlement.fromUserName, currentUser);
    final toLabel = _paidToLabel(settlement.toUserId, settlement.toUserName, currentUser);

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
            // Leading avatar with primaryContainer background
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.swap_horiz_rounded,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),

            // Center rich text details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: fromLabel,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' paid '),
                        TextSpan(
                          text: toLabel,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (settlement.note != null && settlement.note!.trim().isNotEmpty) ...[
                        Text(
                          settlement.note!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        relativeDate,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Trailing amount display in green (using color scheme extension)
            AmountDisplay(
              amount: settlement.amount,
              currency: settlement.currency,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              color: theme.colorScheme.owedColor,
            ),
          ],
        ),
      ),
    );
  }
}
