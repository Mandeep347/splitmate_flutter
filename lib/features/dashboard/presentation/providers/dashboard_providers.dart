import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:splito_flutter/features/analytics/domain/entities/member_contribution.dart';
import 'package:splito_flutter/features/analytics/domain/entities/monthly_spending.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/presentation/providers/expense_providers.dart';

/// Aggregated metrics for the global dashboard view.
class DashboardStats {
  final double totalSpent;
  final double youPaid;
  final double youOwe;
  final double netBalance;

  const DashboardStats({
    required this.totalSpent,
    required this.youPaid,
    required this.youOwe,
    required this.netBalance,
  });

  const DashboardStats.zero()
    : totalSpent = 0.0,
      youPaid = 0.0,
      youOwe = 0.0,
      netBalance = 0.0;
}

/// Provider that aggregates spending across all active groups.
final dashboardStatsProvider = Provider<AsyncValue<DashboardStats>>((ref) {
  final groupsState = ref.watch(myGroupsProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) {
    return const AsyncValue.data(DashboardStats.zero());
  }

  return groupsState.when(
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
    data: (groups) {
      final activeGroups = groups.where((g) => g.isActive).toList();
      if (activeGroups.isEmpty) {
        return const AsyncValue.data(DashboardStats.zero());
      }

      double totalSpent = 0.0;
      double youPaid = 0.0;
      double youOwe = 0.0;
      bool anyLoading = false;
      Object? firstError;
      StackTrace? firstStack;

      for (final group in activeGroups) {
        final analyticsState = ref.watch(groupAnalyticsProvider(group.id));
        analyticsState.when(
          data: (analytics) {
            totalSpent += analytics.totalExpenses;

            // Find current user's contribution in this group
            final userContrib = analytics.memberContributions.firstWhere(
              (c) => c.userId == currentUser.id,
              orElse: () => MemberContribution(
                userId: currentUser.id,
                name: currentUser.name,
                totalPaid: 0.0,
                totalOwed: 0.0,
                netBalance: 0.0,
                expenseCount: 0,
                percentageOfTotal: 0.0,
              ),
            );
            youPaid += userContrib.totalPaid;
            youOwe += userContrib.totalOwed;
          },
          loading: () => anyLoading = true,
          error: (err, stack) {
            firstError ??= err;
            firstStack ??= stack;
          },
        );
      }

      if (anyLoading) {
        return const AsyncValue.loading();
      }

      if (firstError != null) {
        return AsyncValue.error(firstError!, firstStack!);
      }

      return AsyncValue.data(
        DashboardStats(
          totalSpent: totalSpent,
          youPaid: youPaid,
          youOwe: youOwe,
          netBalance: youPaid - youOwe,
        ),
      );
    },
  );
});

/// Aggregates all active expenses across all groups.
final allExpensesProvider = Provider<AsyncValue<List<Expense>>>((ref) {
  final groupsState = ref.watch(myGroupsProvider);

  return groupsState.when(
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
    data: (groups) {
      final activeGroups = groups.where((g) => g.isActive).toList();
      final List<Expense> expensesList = [];
      bool anyLoading = false;
      Object? firstError;
      StackTrace? firstStack;

      for (final group in activeGroups) {
        final expensesState = ref.watch(groupExpensesProvider(group.id));
        expensesState.when(
          data: (paginated) {
            expensesList.addAll(paginated.items.where((e) => e.isActive));
          },
          loading: () => anyLoading = true,
          error: (err, stack) {
            firstError ??= err;
            firstStack ??= stack;
          },
        );
      }

      if (anyLoading && expensesList.isEmpty) {
        return const AsyncValue.loading();
      }

      if (firstError != null && expensesList.isEmpty) {
        return AsyncValue.error(firstError!, firstStack!);
      }

      expensesList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return AsyncValue.data(expensesList);
    },
  );
});

/// Combined monthly spending timeline metrics across all active groups.
final globalMonthlySpendingProvider =
    Provider<AsyncValue<List<MonthlySpending>>>((ref) {
      final groupsState = ref.watch(myGroupsProvider);

      return groupsState.when(
        loading: () => const AsyncValue.loading(),
        error: (err, stack) => AsyncValue.error(err, stack),
        data: (groups) {
          final activeGroups = groups.where((g) => g.isActive).toList();
          final Map<String, _MonthlySpendingBuilder> monthlyMap = {};
          bool anyLoading = false;
          Object? firstError;
          StackTrace? firstStack;

          for (final group in activeGroups) {
            final analyticsState = ref.watch(groupAnalyticsProvider(group.id));
            analyticsState.when(
              data: (analytics) {
                for (final s in analytics.monthlySpending) {
                  final key = '${s.year}-${s.month}';
                  final builder = monthlyMap.putIfAbsent(
                    key,
                    () => _MonthlySpendingBuilder(year: s.year, month: s.month),
                  );
                  builder.totalAmount += s.totalAmount;
                  builder.expenseCount += s.expenseCount;
                }
              },
              loading: () => anyLoading = true,
              error: (err, stack) {
                firstError ??= err;
                firstStack ??= stack;
              },
            );
          }

          if (anyLoading && monthlyMap.isEmpty) {
            return const AsyncValue.loading();
          }

          if (firstError != null && monthlyMap.isEmpty) {
            return AsyncValue.error(firstError!, firstStack!);
          }

          final monthlyList =
              monthlyMap.values
                  .map<MonthlySpending>(
                    (m) => MonthlySpending(
                      year: m.year,
                      month: m.month,
                      monthLabel: DateFormat(
                        'MMM',
                      ).format(DateTime(m.year, m.month)),
                      totalAmount: m.totalAmount,
                      expenseCount: m.expenseCount,
                      currency: 'INR',
                    ),
                  )
                  .toList()
                ..sort((a, b) {
                  final yearCompare = a.year.compareTo(b.year);
                  if (yearCompare != 0) return yearCompare;
                  return a.month.compareTo(b.month);
                });

          return AsyncValue.data(monthlyList);
        },
      );
    });

class _MonthlySpendingBuilder {
  final int year;
  final int month;
  double totalAmount = 0.0;
  int expenseCount = 0;

  _MonthlySpendingBuilder({required this.year, required this.month});
}

/// Expense categories classification structure.
enum ExpenseCategory {
  foodAndDining('Food & Dining'),
  travel('Travel'),
  shopping('Shopping'),
  billsAndUtilities('Bills & Utilities'),
  other('Other');

  final String displayName;
  const ExpenseCategory(this.displayName);
}

class CategoryShare {
  final ExpenseCategory category;
  final double amount;
  final double percentage;

  const CategoryShare({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}

/// Dynamic categorization of global expenses for visual summary.
final globalCategorySharesProvider = Provider<AsyncValue<List<CategoryShare>>>((
  ref,
) {
  final expensesAsync = ref.watch(allExpensesProvider);

  return expensesAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
    data: (expenses) {
      final Map<ExpenseCategory, double> sums = {
        ExpenseCategory.foodAndDining: 0.0,
        ExpenseCategory.travel: 0.0,
        ExpenseCategory.shopping: 0.0,
        ExpenseCategory.billsAndUtilities: 0.0,
        ExpenseCategory.other: 0.0,
      };

      double total = 0.0;
      for (final e in expenses) {
        final category = _classify(e.title);
        sums[category] = (sums[category] ?? 0.0) + e.totalAmount;
        total += e.totalAmount;
      }

      if (total == 0.0) {
        return const AsyncValue.data([]);
      }

      final list = sums.entries.map((entry) {
        return CategoryShare(
          category: entry.key,
          amount: entry.value,
          percentage: entry.value / total,
        );
      }).toList();

      return AsyncValue.data(list);
    },
  );
});

ExpenseCategory _classify(String title) {
  final t = title.toLowerCase();
  if (t.contains('cafe') ||
      t.contains('dinner') ||
      t.contains('lunch') ||
      t.contains('restaurant') ||
      t.contains('food') ||
      t.contains('groceries') ||
      t.contains('drinks') ||
      t.contains('pizza') ||
      t.contains('coffee') ||
      t.contains('eat') ||
      t.contains('breakfast')) {
    return ExpenseCategory.foodAndDining;
  }
  if (t.contains('fuel') ||
      t.contains('goa') ||
      t.contains('cab') ||
      t.contains('uber') ||
      t.contains('flight') ||
      t.contains('train') ||
      t.contains('travel') ||
      t.contains('ticket') ||
      t.contains('hotel') ||
      t.contains('stay') ||
      t.contains('gas') ||
      t.contains('bus') ||
      t.contains('trip')) {
    return ExpenseCategory.travel;
  }
  if (t.contains('gift') ||
      t.contains('cloth') ||
      t.contains('amazon') ||
      t.contains('shopping') ||
      t.contains('shoes') ||
      t.contains('movie') ||
      t.contains('cinema') ||
      t.contains('show') ||
      t.contains('ticket')) {
    return ExpenseCategory.shopping;
  }
  if (t.contains('electricity') ||
      t.contains('bill') ||
      t.contains('rent') ||
      t.contains('wifi') ||
      t.contains('internet') ||
      t.contains('water') ||
      t.contains('power') ||
      t.contains('utility')) {
    return ExpenseCategory.billsAndUtilities;
  }
  return ExpenseCategory.other;
}
