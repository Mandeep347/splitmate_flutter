import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/simplified_balances.dart';
import '../repositories/i_balance_repository.dart';

/// Usecase to retrieve the simplified optimized transactions in a group.
class GetSimplifiedBalancesUseCase {
  /// The balance repository dependency.
  final IBalanceRepository repository;

  /// Creates a new [GetSimplifiedBalancesUseCase] instance.
  const GetSimplifiedBalancesUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<SimplifiedBalances> call({required String groupId}) async {
    try {
      return await repository.getSimplifiedBalances(groupId: groupId);
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
