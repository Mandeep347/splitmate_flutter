import '../entities/expense.dart';
import '../entities/expense_split_input.dart';
import '../entities/paginated_expenses.dart';

/// Repository interface governing operations on Splito expenses.
abstract interface class IExpenseRepository {
  /// Fetches a paginated list of expenses for a specific group.
  Future<PaginatedExpenses> getGroupExpenses({
    required String groupId,
    int page = 1,
    int limit = 20,
  });

  /// Fetches a single expense record by its unique ID.
  Future<Expense> getExpenseById({required String expenseId});

  /// Creates a new expense record in a group.
  Future<Expense> createExpense({
    required String groupId,
    required String title,
    String? description,
    required double totalAmount,
    required String currency,
    required String paidByUserId,
    required ExpenseSplitInput splitInput,
    String? idempotencyKey,
  });

  /// Updates details of an existing expense record.
  Future<Expense> updateExpense({
    required String expenseId,
    String? title,
    String? description,
  });

  /// Reverses/cancels an existing active expense.
  Future<Expense> reverseExpense({required String expenseId});
}
