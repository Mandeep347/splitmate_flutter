import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/auth/domain/entities/logged_in_user.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/presentation/providers/expense_providers.dart';
import 'package:splito_flutter/shared/widgets/amount_display.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/confirmation_dialog.dart';
import 'package:splito_flutter/shared/widgets/loading_overlay.dart';
import 'package:splito_flutter/shared/widgets/member_avatar.dart';
import 'package:splito_flutter/features/expenses/presentation/widgets/edit_expense_sheet.dart';

/// Screen displaying the detailed split breakdown and attributes of a single expense.
class ExpenseDetailPage extends ConsumerWidget {
  /// The unique identifier of the expense.
  final String expenseId;

  /// Creates a const [ExpenseDetailPage] instance.
  const ExpenseDetailPage({super.key, required this.expenseId});

  String _displayName(String? userId, String name, LoggedInUser? me) {
    if (me == null) return name;
    if (userId != null && userId == me.id) return 'You';
    if (userId == null && name == me.name) return 'You';
    return name;
  }

  Future<void> _onReverse(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
  ) async {
    final confirm = await ConfirmationDialog.show(
      context,
      title: 'Reverse Expense',
      message:
          'This will undo all balance changes from this expense. This cannot be undone.',
      confirmLabel: 'Reverse',
      isDestructive: true,
    );

    if (confirm == true) {
      try {
        await ref
            .read(reverseExpenseProvider.notifier)
            .reverse(expenseId: expenseId, groupId: expense.groupId);
      } catch (_) {
        // Silent catch; handled via provider listener
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final detailAsync = ref.watch(expenseDetailProvider(expenseId));
    final reverseState = ref.watch(reverseExpenseProvider);
    final currentUser = ref.watch(currentUserProvider);

    // Listen to changes in the reverseExpenseProvider
    ref.listen<AsyncValue<void>>(reverseExpenseProvider, (previous, next) {
      if (next is AsyncData<void> && previous is AsyncLoading<void>) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Expense reversed')));
        context.pop();
      } else if (next is AsyncError<void> && previous is AsyncLoading<void>) {
        final failure = next.error;
        final message = failure is Failure
            ? failure.message
            : 'Failed to reverse expense.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    // Listen to changes in the updateExpenseProvider
    ref.listen<AsyncValue<void>>(updateExpenseProvider, (previous, next) {
      if (next is AsyncData<void> && previous is AsyncLoading<void>) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Expense updated')));
      } else if (next is AsyncError<void> && previous is AsyncLoading<void>) {
        final failure = next.error;
        final message = failure is Failure
            ? failure.message
            : 'Failed to update expense.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return LoadingOverlay(
      isLoading: reverseState.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Expense Details'),
          actions: [
            ...detailAsync.when(
              data: (expense) {
                if (expense.isActive) {
                  return [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Edit',
                      onPressed: () => EditExpenseSheet.show(context, expense),
                    ),
                    IconButton(
                      icon: const Icon(Icons.undo),
                      tooltip: 'Reverse Expense',
                      onPressed: () => _onReverse(context, ref, expense),
                    ),
                  ];
                }
                return [];
              },
              error: (_, __) => [],
              loading: () => [],
            ),
          ],
        ),
        body: AsyncValueWidget<Expense>(
          value: detailAsync,
          onRetry: () => ref.refresh(expenseDetailProvider(expenseId)),
          data: (expense) {
            final isReversed = !expense.isActive;
            final paidByLabel = _displayName(
              expense.paidByUserId,
              expense.paidByName,
              currentUser,
            );

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Card 1 — Header card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isReversed) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'REVERSED',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onError,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          expense.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AmountDisplay(
                          amount: expense.totalAmount,
                          currency: expense.currency,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: isReversed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          color: isReversed
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.primary,
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Paid by ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              paidByLabel,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat(
                                'd MMM yyyy, h:mm a',
                              ).format(expense.createdAt),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.pie_chart_outline,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              expense.splitType.displayLabel,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        if (expense.description != null &&
                            expense.description!.trim().isNotEmpty) ...[
                          const Divider(height: 24),
                          Text(
                            'Description',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            expense.description!,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card 2 — Participants card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Split Breakdown',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...expense.participants.map((p) {
                          final hasPercentage = p.percentage != null;
                          final hasShares = p.shares != null;
                          final participantLabel = _displayName(
                            p.userId,
                            p.name,
                            currentUser,
                          );

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                MemberAvatar(name: p.name, radius: 18),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    participantLabel,
                                    style: theme.textTheme.titleSmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    AmountDisplay(
                                      amount: p.owedAmount,
                                      currency: expense.currency,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      color: theme.colorScheme.error,
                                    ),
                                    if (hasPercentage) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        '${p.percentage!.toStringAsFixed(1)}%',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                              fontSize: 10,
                                            ),
                                      ),
                                    ] else if (hasShares) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        '${p.shares} shares',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                              fontSize: 10,
                                            ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
