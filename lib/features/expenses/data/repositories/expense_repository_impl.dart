import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_split_input.dart';
import 'package:splito_flutter/features/expenses/domain/entities/paginated_expenses.dart';
import 'package:splito_flutter/features/expenses/domain/repositories/i_expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../datasources/expense_remote_datasource.dart';

/// Repository implementation for expense operations, handling model mapping
/// and building raw API request payloads.
class ExpenseRepositoryImpl implements IExpenseRepository {
  final IExpenseRemoteDatasource _datasource;
  final IExpenseLocalDatasource _localDatasource;

  /// Creates a new [ExpenseRepositoryImpl] instance.
  const ExpenseRepositoryImpl(this._datasource, this._localDatasource);

  @override
  Future<PaginatedExpenses> getGroupExpenses({
    required String groupId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final model = await _datasource.getGroupExpenses(
        groupId: groupId,
        page: page,
        limit: limit,
      );
      if (page == 1) {
        await _localDatasource.cacheGroupExpenses(
          groupId: groupId,
          expenses: model.items,
        );
      }
      return model.toEntity();
    } catch (_) {
      if (page == 1) {
        final cached = await _localDatasource.getCachedGroupExpenses(groupId);
        if (cached != null) {
          return PaginatedExpenses(
            items: cached.map((e) => e.toEntity()).toList(),
            page: 1,
            limit: cached.length,
            totalPages: 1,
            totalItems: cached.length,
          );
        }
      }
      rethrow;
    }
  }

  @override
  Future<Expense> getExpenseById({required String expenseId}) async {
    try {
      final model = await _datasource.getExpenseById(expenseId: expenseId);
      await _localDatasource.cacheExpense(model);
      return model.toEntity();
    } catch (_) {
      final cached = await _localDatasource.getCachedExpense(expenseId);
      if (cached != null) {
        return cached.toEntity();
      }
      rethrow;
    }
  }

  @override
  Future<Expense> createExpense({
    required String groupId,
    required String title,
    String? description,
    required double totalAmount,
    required String currency,
    required String paidByUserId,
    required ExpenseSplitInput splitInput,
    String? idempotencyKey,
  }) async {
    final body = _buildRequestBody(
      title: title,
      description: description,
      totalAmount: totalAmount,
      currency: currency,
      paidByUserId: paidByUserId,
      splitInput: splitInput,
    );

    final model = await _datasource.createExpense(
      groupId: groupId,
      body: body,
      idempotencyKey: idempotencyKey,
    );
    return model.toEntity();
  }

  @override
  Future<Expense> updateExpense({
    required String expenseId,
    String? title,
    String? description,
  }) async {
    final model = await _datasource.updateExpense(
      expenseId: expenseId,
      title: title,
      description: description,
    );
    return model.toEntity();
  }

  @override
  Future<Expense> reverseExpense({required String expenseId}) async {
    final model = await _datasource.reverseExpense(expenseId: expenseId);
    return model.toEntity();
  }

  Map<String, dynamic> _buildRequestBody({
    required String title,
    String? description,
    required double totalAmount,
    required String currency,
    required String paidByUserId,
    required ExpenseSplitInput splitInput,
  }) {
    final body = <String, dynamic>{
      'title': title,
      'total_amount': totalAmount.toStringAsFixed(2),
      'currency': currency,
      'paid_by_user_id': paidByUserId,
      'split_type': splitInput.splitType.apiValue,
    };

    if (description != null && description.trim().isNotEmpty) {
      body['description'] = description;
    }

    final input = splitInput;
    if (input is EqualSplitInput) {
      body['participants_equal'] = input.participants
          .map((p) => {'user_id': p.userId})
          .toList();
    } else if (input is ExactSplitInput) {
      body['participants_exact'] = input.participants
          .map(
            (p) => {
              'user_id': p.userId,
              'owed_amount': p.owedAmount.toStringAsFixed(2),
            },
          )
          .toList();
    } else if (input is PercentageSplitInput) {
      body['participants_percentage'] = input.participants
          .map(
            (p) => {
              'user_id': p.userId,
              'percentage': p.percentage.toStringAsFixed(2),
            },
          )
          .toList();
    } else if (input is ShareSplitInput) {
      body['participants_share'] = input.participants
          .map((p) => {'user_id': p.userId, 'shares': p.shares})
          .toList();
    }

    return body;
  }
}

/// Provider exposing [IExpenseRepository] implementation.
final expenseRepositoryProvider = Provider<IExpenseRepository>((ref) {
  final datasource = ref.watch(expenseRemoteDatasourceProvider);
  final localDatasource = ref.watch(expenseLocalDatasourceProvider);
  return ExpenseRepositoryImpl(datasource, localDatasource);
});
