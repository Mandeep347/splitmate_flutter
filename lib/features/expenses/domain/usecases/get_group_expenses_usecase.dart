import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/paginated_expenses.dart';
import '../repositories/i_expense_repository.dart';

/// Usecase to retrieve a paginated list of expenses for a specific group.
class GetGroupExpensesUseCase {
  /// The expenses repository dependency.
  final IExpenseRepository repository;

  /// Creates a new [GetGroupExpensesUseCase] instance.
  const GetGroupExpensesUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<PaginatedExpenses> call({
    required String groupId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await repository.getGroupExpenses(
        groupId: groupId,
        page: page,
        limit: limit,
      );
    } on Failure {
      rethrow;
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on NotFoundException {
      throw const ServerFailure('Group not found.', 'NOT_FOUND');
    } on NetworkClientException catch (e) {
      throw ServerFailure(e.message, e.errorCode);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}

extension on NetworkClientException {
  String? get errorCode {
    if (this is BusinessRuleException) {
      final br = this as BusinessRuleException;
      return br.errors?['code'] as String? ??
          br.errors?['errorCode'] as String?;
    }
    return null;
  }
}
