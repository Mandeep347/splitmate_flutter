import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/constants/app_constants.dart';
import 'package:splito_flutter/core/network/dio_client.dart';
import '../models/expense_model.dart';
import '../models/paginated_expenses_model.dart';

/// Abstract remote datasource interface for expense operations.
abstract interface class IExpenseRemoteDatasource {
  /// Fetches a paginated list of expenses for a group.
  Future<PaginatedExpensesModel> getGroupExpenses({
    required String groupId,
    int page = 1,
    int limit = 20,
  });

  /// Fetches a single expense details by ID.
  Future<ExpenseModel> getExpenseById({required String expenseId});

  /// Creates a new expense record in a group.
  Future<ExpenseModel> createExpense({
    required String groupId,
    required Map<String, dynamic> body,
    String? idempotencyKey,
  });

  /// Updates details of an existing expense record.
  Future<ExpenseModel> updateExpense({
    required String expenseId,
    String? title,
    String? description,
  });

  /// Reverses an active expense record.
  Future<ExpenseModel> reverseExpense({required String expenseId});
}

/// Remote datasource implementation using [DioClient].
class ExpenseRemoteDatasource implements IExpenseRemoteDatasource {
  final DioClient _client;

  /// Creates a new [ExpenseRemoteDatasource] instance.
  const ExpenseRemoteDatasource(this._client);

  @override
  Future<PaginatedExpensesModel> getGroupExpenses({
    required String groupId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.groupExpenses(groupId),
      queryParameters: {'page': page, 'limit': limit},
    );
    return PaginatedExpensesModel.fromJson(response.data!);
  }

  @override
  Future<ExpenseModel> getExpenseById({required String expenseId}) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.expenseById(expenseId),
    );
    return ExpenseModel.fromJson(response.data!);
  }

  @override
  Future<ExpenseModel> createExpense({
    required String groupId,
    required Map<String, dynamic> body,
    String? idempotencyKey,
  }) async {
    final options = idempotencyKey != null
        ? Options(headers: {'Idempotency-Key': idempotencyKey})
        : null;

    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.groupExpenses(groupId),
      data: body,
      options: options,
    );
    return ExpenseModel.fromJson(response.data!);
  }

  @override
  Future<ExpenseModel> updateExpense({
    required String expenseId,
    String? title,
    String? description,
  }) async {
    final response = await _client.patch<Map<String, dynamic>>(
      ApiEndpoints.expenseById(expenseId),
      data: {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
      },
    );
    return ExpenseModel.fromJson(response.data!);
  }

  @override
  Future<ExpenseModel> reverseExpense({required String expenseId}) async {
    final response = await _client.patch<Map<String, dynamic>>(
      ApiEndpoints.reverseExpense(expenseId),
    );
    return ExpenseModel.fromJson(response.data!);
  }
}

/// Provider exposing [IExpenseRemoteDatasource].
final expenseRemoteDatasourceProvider = Provider<IExpenseRemoteDatasource>((
  ref,
) {
  final client = ref.watch(dioClientProvider);
  return ExpenseRemoteDatasource(client);
});
