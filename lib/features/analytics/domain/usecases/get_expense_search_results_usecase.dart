import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'package:splito_flutter/features/expenses/domain/repositories/i_expense_repository.dart';

/// Usecase performing search queries and filters on group expenses client-side.
class GetExpenseSearchResultsUseCase {
  /// The expense repository interface.
  final IExpenseRepository expenseRepository;

  /// Creates a const [GetExpenseSearchResultsUseCase] instance.
  const GetExpenseSearchResultsUseCase({required this.expenseRepository});

  /// Executes the usecase.
  /// Throws [Failure] subclass on error.
  Future<List<Expense>> call({
    required String groupId,
    String? searchQuery,
    DateTime? fromDate,
    DateTime? toDate,
    String? paidByUserId,
    SplitType? splitType,
  }) async {
    try {
      final paginated = await expenseRepository.getGroupExpenses(
        groupId: groupId,
        page: 1,
        limit: 1000,
      );

      var list = paginated.items;

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        list = list
            .where((e) => e.title.toLowerCase().contains(query))
            .toList();
      }

      if (fromDate != null) {
        // Subtract 1 day to be inclusive of the day boundary
        final boundary = fromDate.subtract(const Duration(days: 1));
        list = list.where((e) => e.createdAt.isAfter(boundary)).toList();
      }

      if (toDate != null) {
        // Add 1 day to be inclusive of the day boundary
        final boundary = toDate.add(const Duration(days: 1));
        list = list.where((e) => e.createdAt.isBefore(boundary)).toList();
      }

      if (paidByUserId != null) {
        list = list.where((e) => e.paidByUserId == paidByUserId).toList();
      }

      if (splitType != null) {
        list = list.where((e) => e.splitType == splitType).toList();
      }

      // Return filtered list sorted by createdAt descending
      return list..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } on Failure {
      rethrow;
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on NetworkClientException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
