import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../repositories/i_notification_repository.dart';

/// Usecase to fetch the total unread notifications count.
class GetUnreadCountUseCase {
  /// The notification repository.
  final INotificationRepository repository;

  /// Creates a new [GetUnreadCountUseCase] instance.
  const GetUnreadCountUseCase({required this.repository});

  /// Executes the usecase.
  Future<int> call() async {
    try {
      final notifications = await repository.getNotifications();
      return notifications.where((n) => n.isUnread).length;
    } on Failure {
      rethrow;
    } on NotFoundException {
      throw const ServerFailure('Notification count not found.', 'NOT_FOUND');
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
