import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/expense.dart';
import '../repositories/i_expense_repository.dart';

/// Usecase to reverse/cancel an existing active expense.
class ReverseExpenseUseCase {
  /// The expenses repository dependency.
  final IExpenseRepository repository;

  /// Creates a new [ReverseExpenseUseCase] instance.
  const ReverseExpenseUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<Expense> call({required String expenseId}) async {
    try {
      return await repository.reverseExpense(expenseId: expenseId);
    } on Failure {
      rethrow;
    } on BusinessRuleException catch (e) {
      throw BusinessRuleFailure(e.message, e.errorCode, e.errors);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on NotFoundException {
      throw const ServerFailure(
        'Expense not found or already reversed.',
        'NOT_FOUND',
      );
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
