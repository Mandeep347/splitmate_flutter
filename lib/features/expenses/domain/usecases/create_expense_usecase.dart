import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/expense.dart';
import '../entities/expense_split_input.dart';
import '../repositories/i_expense_repository.dart';

/// Usecase to create a new expense with local split validations.
class CreateExpenseUseCase {
  /// The expenses repository dependency.
  final IExpenseRepository repository;

  /// Creates a new [CreateExpenseUseCase] instance.
  const CreateExpenseUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<Expense> call({
    required String groupId,
    required String title,
    String? description,
    required double totalAmount,
    required String currency,
    required String paidByUserId,
    required ExpenseSplitInput splitInput,
    String? idempotencyKey,
  }) async {
    // Local Split Validation logic
    final input = splitInput;
    if (input is EqualSplitInput) {
      if (input.participants.isEmpty) {
        throw const BusinessRuleFailure(
          'Participants list cannot be empty.',
          'EMPTY_PARTICIPANTS',
        );
      }
    } else if (input is ExactSplitInput) {
      double sum = 0.0;
      for (final p in input.participants) {
        sum += p.owedAmount;
      }
      if ((sum - totalAmount).abs() > 0.01) {
        throw const BusinessRuleFailure(
          'The sum of split amounts does not equal the total amount.',
          'INVALID_SPLIT_TOTAL',
        );
      }
    } else if (input is PercentageSplitInput) {
      double sum = 0.0;
      for (final p in input.participants) {
        sum += p.percentage;
      }
      if ((sum - 100.0).abs() > 0.01) {
        throw const BusinessRuleFailure(
          'The sum of split percentages must equal 100%.',
          'INVALID_SPLIT_PERCENTAGE',
        );
      }
    } else if (input is ShareSplitInput) {
      if (input.participants.isEmpty) {
        throw const BusinessRuleFailure(
          'Participants list cannot be empty.',
          'EMPTY_PARTICIPANTS',
        );
      }
      for (final p in input.participants) {
        if (p.shares <= 0) {
          throw const BusinessRuleFailure(
            'Share values must be greater than zero.',
            'INVALID_SPLIT_SHARE',
          );
        }
      }
    }

    try {
      return await repository.createExpense(
        groupId: groupId,
        title: title,
        description: description,
        totalAmount: totalAmount,
        currency: currency,
        paidByUserId: paidByUserId,
        splitInput: splitInput,
        idempotencyKey: idempotencyKey,
      );
    } on Failure {
      rethrow;
    } on BusinessRuleException catch (e) {
      throw BusinessRuleFailure(e.message, e.errorCode, e.errors);
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
