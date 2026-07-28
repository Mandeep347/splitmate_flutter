import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../repositories/i_notification_repository.dart';

/// Usecase to mark all user notifications as read.
class MarkAllReadUseCase {
  /// The notification repository.
  final INotificationRepository repository;

  /// Creates a new [MarkAllReadUseCase] instance.
  const MarkAllReadUseCase({required this.repository});

  /// Executes the usecase.
  Future<int> call() async {
    try {
      return await repository.markAllAsRead();
    } on Failure {
      rethrow;
    } on NotFoundException {
      throw const ServerFailure('Notifications not found.', 'NOT_FOUND');
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
