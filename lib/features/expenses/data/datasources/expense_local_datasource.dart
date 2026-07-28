import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/constants/storage_keys.dart';
import 'package:splito_flutter/core/storage/hive_storage_service.dart';
import '../models/expense_model.dart';

/// Abstract contract governing local persistence operations for expense details and lists.
abstract interface class IExpenseLocalDatasource {
  /// Caches a list of group expenses.
  Future<void> cacheGroupExpenses({
    required String groupId,
    required List<ExpenseModel> expenses,
  });

  /// Retrieves cached group expenses, or null if not found.
  Future<List<ExpenseModel>?> getCachedGroupExpenses(String groupId);

  /// Caches details of a single expense.
  Future<void> cacheExpense(ExpenseModel expense);

  /// Retrieves details of a cached expense by ID, or null.
  Future<ExpenseModel?> getCachedExpense(String expenseId);

  /// Clears the cached expenses list for a group.
  Future<void> clearGroupExpensesCache(String groupId);
}

/// Local datasource implementation using [IHiveStorageService].
class ExpenseLocalDatasource implements IExpenseLocalDatasource {
  /// The local storage service dependency.
  final IHiveStorageService storage;

  /// Creates a new [ExpenseLocalDatasource] instance.
  const ExpenseLocalDatasource({required this.storage});

  static const String _boxName = StorageKeys.expensesCacheBox;

  @override
  Future<void> cacheGroupExpenses({
    required String groupId,
    required List<ExpenseModel> expenses,
  }) async {
    final jsonString = jsonEncode(expenses.map((e) => e.toJson()).toList());
    await storage.write<String>(
      _boxName,
      'group_expenses_$groupId',
      jsonString,
    );
  }

  @override
  Future<List<ExpenseModel>?> getCachedGroupExpenses(String groupId) async {
    try {
      final jsonString = storage.read<String>(
        _boxName,
        'group_expenses_$groupId',
      );
      if (jsonString == null) return null;
      final list = jsonDecode(jsonString) as List<dynamic>;
      return list
          .map((item) => ExpenseModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheExpense(ExpenseModel expense) async {
    final jsonString = jsonEncode(expense.toJson());
    await storage.write<String>(_boxName, 'expense_${expense.id}', jsonString);
  }

  @override
  Future<ExpenseModel?> getCachedExpense(String expenseId) async {
    try {
      final jsonString = storage.read<String>(_boxName, 'expense_$expenseId');
      if (jsonString == null) return null;
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return ExpenseModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearGroupExpensesCache(String groupId) async {
    await storage.delete(_boxName, 'group_expenses_$groupId');
  }
}

/// Provider exposing [IExpenseLocalDatasource].
final expenseLocalDatasourceProvider = Provider<IExpenseLocalDatasource>((ref) {
  final storage = ref.watch(hiveStorageServiceProvider);
  return ExpenseLocalDatasource(storage: storage);
});
