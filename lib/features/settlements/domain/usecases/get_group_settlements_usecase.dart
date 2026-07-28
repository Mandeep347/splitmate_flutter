import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/settlement.dart';
import '../repositories/i_settlement_repository.dart';

/// Usecase to retrieve the historical list of settlements recorded in a group.
class GetGroupSettlementsUseCase {
  /// The settlement repository dependency.
  final ISettlementRepository repository;

  /// Creates a new [GetGroupSettlementsUseCase] instance.
  const GetGroupSettlementsUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws a [Failure] on error.
  Future<List<Settlement>> call({required String groupId}) async {
    try {
      return await repository.getGroupSettlements(groupId: groupId);
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
