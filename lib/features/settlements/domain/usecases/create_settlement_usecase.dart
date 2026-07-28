import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/settlement.dart';
import '../repositories/i_settlement_repository.dart';

/// Usecase to record a new debt settlement transaction with local validation checks.
class CreateSettlementUseCase {
  /// The settlement repository dependency.
  final ISettlementRepository repository;

  /// Creates a new [CreateSettlementUseCase] instance.
  const CreateSettlementUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<Settlement> call({
    required String groupId,
    required String fromUserId,
    required String toUserId,
    required double amount,
    required String currency,
    String? note,
  }) async {
    // Local validations
    if (amount <= 0) {
      throw const BusinessRuleFailure(
        'Settlement amount must be greater than zero.',
        'INVALID_AMOUNT',
      );
    }

    if (fromUserId == toUserId) {
      throw const BusinessRuleFailure(
        'Cannot settle with yourself.',
        'SELF_SETTLEMENT_INVALID',
      );
    }

    try {
      return await repository.createSettlement(
        groupId: groupId,
        fromUserId: fromUserId,
        toUserId: toUserId,
        amount: amount,
        currency: currency,
        note: note,
      );
    } on Failure {
      rethrow;
    } on BusinessRuleException catch (e) {
      throw BusinessRuleFailure(e.message, e.errorCode, e.errors);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
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
