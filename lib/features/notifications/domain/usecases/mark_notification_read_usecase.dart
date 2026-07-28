import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/app_notification.dart';
import '../repositories/i_notification_repository.dart';

/// Usecase to mark a specific notification as read.
class MarkNotificationReadUseCase {
  /// The notification repository.
  final INotificationRepository repository;

  /// Creates a new [MarkNotificationReadUseCase] instance.
  const MarkNotificationReadUseCase({required this.repository});

  /// Executes the usecase.
  Future<AppNotification> call({required String notificationId}) async {
    try {
      return await repository.markAsRead(notificationId: notificationId);
    } on Failure {
      rethrow;
    } on NotFoundException {
      throw const ServerFailure(
        'Notification not found.',
        'NOTIFICATION_NOT_FOUND',
      );
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
