import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/app_notification.dart';
import '../repositories/i_notification_repository.dart';

/// Usecase to fetch all user notifications.
class GetNotificationsUseCase {
  /// The notification repository.
  final INotificationRepository repository;

  /// Creates a new [GetNotificationsUseCase] instance.
  const GetNotificationsUseCase({required this.repository});

  /// Executes the usecase.
  Future<List<AppNotification>> call() async {
    try {
      return await repository.getNotifications();
    } on Failure {
      rethrow;
    } on NotFoundException {
      throw const ServerFailure('Notification list not found.', 'NOT_FOUND');
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
