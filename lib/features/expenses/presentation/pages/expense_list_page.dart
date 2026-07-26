import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/paginated_expenses.dart';
import 'package:splito_flutter/features/expenses/presentation/providers/expense_providers.dart';
import 'package:splito_flutter/features/expenses/presentation/widgets/expense_filter_sheet.dart';
import 'package:splito_flutter/features/expenses/presentation/widgets/expense_list_tile.dart';
import 'package:splito_flutter/features/groups/domain/entities/group_member.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/features/settings/presentation/providers/settings_providers.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/empty_state_widget.dart';
import 'package:splito_flutter/shared/widgets/shimmer_wrapper.dart';
import 'package:splito_flutter/shared/widgets/skeletons/expense_list_tile_skeleton.dart';

/// Screen displaying a paginated list of expenses for a specific group.
class ExpenseListPage extends ConsumerStatefulWidget {
  /// The unique identifier of the group.
  final String groupId;

  /// The name of the group.
  final String groupName;

  /// Creates a const [ExpenseListPage] instance.
  const ExpenseListPage({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  ConsumerState<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends ConsumerState<ExpenseListPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(groupExpensesProvider(widget.groupId).notifier).loadNextPage();
    }
  }

  void _navigateToAddExpense() {
    final group = ref.read(groupDetailProvider(widget.groupId)).valueOrNull;
    if (group != null) {
      context.goNamed(
        AppRoutes.createExpenseName,
        pathParameters: {'groupId': widget.groupId},
        extra: {
          'groupName': group.name,
          'currency': group.defaultCurrency,
          'members': group.members,
        },
      );
    } else {
      context.goNamed(
        AppRoutes.createExpenseName,
        pathParameters: {'groupId': widget.groupId},
        extra: {
          'groupName': widget.groupName,
          'currency': 'INR',
          'members': <GroupMember>[],
        },
      );
    }
  }

  Future<void> _onRefresh() async {
    ref.read(groupExpensesProvider(widget.groupId).notifier).refresh();
    try {
      await ref.read(groupExpensesProvider(widget.groupId).future);
    } catch (_) {
      // Ignore errors so pull-to-refresh indicator completes
    }
  }

  Widget _buildFilterSummaryBar(BuildContext context, ThemeData theme, AppThemeExtension ext) {
    return Container(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
      padding: EdgeInsets.symmetric(horizontal: ext.spaceMD, vertical: ext.spaceXS),
      child: Row(
        children: [
          Text(
            'Filtered results',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              ref.read(expenseSearchProvider(widget.groupId).notifier).clearFilters();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(groupExpensesProvider(widget.groupId));
    final isCompact = ref.watch(settingsProvider).valueOrNull?.compactExpenseList ?? false;
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    final filtersState = ref.watch(expenseSearchFiltersProvider(widget.groupId));
    final hasFilters = filtersState.hasActiveFilters;
    final isSearchMode = _isSearching || hasFilters;

    final groupAsync = ref.watch(groupDetailProvider(widget.groupId));
    final members = groupAsync.valueOrNull?.members ?? [];

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search expenses…',
                  border: InputBorder.none,
                ),
                onChanged: (q) => ref.read(expenseSearchProvider(widget.groupId).notifier).updateQuery(q),
              )
            : Text(widget.groupName),
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                  });
                  ref.read(expenseSearchProvider(widget.groupId).notifier).clearFilters();
                  _searchController.clear();
                },
              )
            : null,
        actions: _isSearching
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.search_outlined),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
                IconButton(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.tune_outlined),
                      if (hasFilters)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 8,
                              minHeight: 8,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () => ExpenseFilterSheet.show(context, widget.groupId, members),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _navigateToAddExpense,
                ),
              ],
      ),
      body: isSearchMode
          ? AsyncValueWidget<List<Expense>>(
              value: ref.watch(expenseSearchProvider(widget.groupId)),
              onRetry: () async {
                await ref.read(expenseSearchProvider(widget.groupId).future);
              },
              loading: () => ShimmerWrapper(
                isLoading: true,
                child: ListView.builder(
                  padding: isCompact
                      ? const EdgeInsets.fromLTRB(12, 8, 12, 100)
                      : const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  itemCount: 5,
                  itemBuilder: (context, index) => const ExpenseListTileSkeleton(),
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Column(
                    children: [
                      if (hasFilters) _buildFilterSummaryBar(context, theme, ext),
                      const Expanded(
                        child: EmptyStateWidget(
                          icon: Icons.search_off_outlined,
                          title: 'No results found',
                          subtitle: 'Try adjusting your search queries or filter choices.',
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    if (hasFilters) _buildFilterSummaryBar(context, theme, ext),
                    Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: isCompact
                            ? const EdgeInsets.fromLTRB(12, 8, 12, 100)
                            : const EdgeInsets.fromLTRB(16, 12, 16, 100),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ExpenseListTile(
                            expense: items[index],
                            compact: isCompact,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            )
          : AsyncValueWidget<PaginatedExpenses>(
              value: state,
              onRetry: () => ref.invalidate(groupExpensesProvider(widget.groupId)),
              loading: () => ShimmerWrapper(
                isLoading: true,
                child: ListView.builder(
                  padding: isCompact
                      ? const EdgeInsets.fromLTRB(12, 8, 12, 100)
                      : const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  itemCount: 5,
                  itemBuilder: (context, index) => const ExpenseListTileSkeleton(),
                ),
              ),
              data: (paginatedData) {
                final items = paginatedData.items;

                if (items.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.receipt_long_outlined,
                    title: 'No expenses yet',
                    subtitle: 'Add the first expense for ${widget.groupName}.',
                    actionLabel: 'Add Expense',
                    onAction: _navigateToAddExpense,
                  );
                }

                final hasMore = paginatedData.hasMore;

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: isCompact
                        ? const EdgeInsets.fromLTRB(12, 8, 12, 100)
                        : const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    itemCount: items.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return ExpenseListTile(
                        expense: items[index],
                        compact: isCompact,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
