import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/features/auth/domain/entities/logged_in_user.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/core/offline/domain/entities/pending_indicator.dart';
import 'package:splito_flutter/shared/widgets/amount_display.dart';

/// Card tile representation for displaying summary details of an expense.
class ExpenseListTile extends ConsumerWidget {
  /// The expense transaction detail data.
  final Expense expense;

  /// Whether the tile should be displayed in a compact format.
  final bool compact;

  /// Creates a const [ExpenseListTile] instance.
  const ExpenseListTile({
    super.key,
    required this.expense,
    this.compact = false,
  });

  String _displayName(String? userId, String name, LoggedInUser? me) {
    if (me == null) return name;
    if (userId != null && userId == me.id) return 'You';
    if (userId == null && name == me.name) return 'You';
    return name;
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
    final isReversed = !expense.isActive && expense.status == 'REVERSED';
    final isPending = expense.status == 'PENDING';
    final relativeDate = isPending ? 'Pending sync' : _getRelativeDate(expense.createdAt);
    final currentUser = ref.watch(currentUserProvider);

    final paidByLabel = _displayName(expense.paidByUserId, expense.paidByName, currentUser);

    Widget content = Card(
      margin: compact
          ? const EdgeInsets.symmetric(vertical: 2, horizontal: 12)
          : const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isPending
            ? null
            : () => context.pushNamed(
                AppRoutes.expenseDetailName,
                pathParameters: {
                  'groupId': expense.groupId,
                  'expenseId': expense.id,
                },
              ),
        child: Padding(
          padding: EdgeInsets.all(compact ? 10.0 : 14.0),
          child: Row(
            children: [
              // Left Icon Container
              Container(
                width: compact ? 36 : 44,
                height: compact ? 36 : 44,
                decoration: BoxDecoration(
                  color: isPending
                      ? const Color(0xFFF59E0B).withValues(alpha: 0.15)
                      : theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isPending ? Icons.access_time_rounded : Icons.receipt_long_outlined,
                  color: isPending ? const Color(0xFFF59E0B) : theme.colorScheme.onPrimaryContainer,
                  size: compact ? 16 : 20,
                ),
              ),
              const SizedBox(width: 12),

              // Middle Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: (compact ? theme.textTheme.bodySmall : theme.textTheme.titleMedium)?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: isReversed ? TextDecoration.lineThrough : null,
                        color: isReversed ? theme.colorScheme.onSurfaceVariant : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$paidByLabel · $relativeDate',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isPending ? const Color(0xFFD97706) : theme.colorScheme.onSurfaceVariant,
                        fontSize: compact ? 11 : null,
                        fontWeight: isPending ? FontWeight.w600 : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Right Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AmountDisplay(
                    amount: expense.totalAmount,
                    currency: expense.currency,
                    style: (compact ? theme.textTheme.bodyMedium : theme.textTheme.titleMedium)?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: isReversed ? TextDecoration.lineThrough : null,
                    ),
                    color: isReversed
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.primary,
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        expense.splitType.displayLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (isPending) {
      content = PendingIndicatorWrapper(
        state: PendingState.pending,
        child: content,
      );
    } else if (isReversed) {
      content = Opacity(
        opacity: 0.6,
        child: content,
      );
    }

    return content;
  }
}
