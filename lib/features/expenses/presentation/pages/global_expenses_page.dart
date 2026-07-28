import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:splito_flutter/features/expenses/presentation/widgets/expense_list_tile.dart';
import 'package:splito_flutter/shared/widgets/async_value_widget.dart';
import 'package:splito_flutter/shared/widgets/empty_state_widget.dart';

class GlobalExpensesPage extends ConsumerStatefulWidget {
  const GlobalExpensesPage({super.key});

  @override
  ConsumerState<GlobalExpensesPage> createState() => _GlobalExpensesPageState();
}

class _GlobalExpensesPageState extends ConsumerState<GlobalExpensesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(allExpensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              ref.invalidate(allExpensesProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search expenses...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim().toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: AsyncValueWidget<List<Expense>>(
              value: expensesAsync,
              data: (expenses) {
                final filtered = expenses.where((e) {
                  if (_searchQuery.isEmpty) return true;
                  return e.title.toLowerCase().contains(_searchQuery) ||
                      (e.description?.toLowerCase().contains(_searchQuery) ??
                          false);
                }).toList();

                if (filtered.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.receipt_long_outlined,
                    title: 'No expenses found',
                    subtitle: 'Add expenses to your groups to see them here.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(allExpensesProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final expense = filtered[index];
                      return ExpenseListTile(expense: expense);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
