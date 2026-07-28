import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/user_overall_balance.dart';
import '../repositories/i_balance_repository.dart';

/// Usecase to retrieve the overall user balance summary across groups.
class GetMyOverallBalancesUseCase {
  /// The balance repository dependency.
  final IBalanceRepository repository;

  /// Creates a new [GetMyOverallBalancesUseCase] instance.
  const GetMyOverallBalancesUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<List<UserOverallBalance>> call() async {
    try {
      return await repository.getMyOverallBalances();
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
