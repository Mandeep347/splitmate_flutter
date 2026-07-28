import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/i_notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

/// Repository implementation delivering in-app notifications.
class NotificationRepositoryImpl implements INotificationRepository {
  /// The remote notifications datasource.
  final INotificationRemoteDatasource remoteDatasource;

  /// Creates a new [NotificationRepositoryImpl] instance.
  const NotificationRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<AppNotification>> getNotifications() async {
    final models = await remoteDatasource.getNotifications();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AppNotification> markAsRead({required String notificationId}) async {
    final model = await remoteDatasource.markAsRead(
      notificationId: notificationId,
    );
    return model.toEntity();
  }

  @override
  Future<int> markAllAsRead() async {
    return await remoteDatasource.markAllAsRead();
  }

  @override
  Future<int> getUnreadCount() async {
    final list = await getNotifications();
    return list.where((n) => n.isUnread).length;
  }
}

/// Provider exposing [INotificationRepository] implementation.
final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  final remoteDatasource = ref.watch(notificationRemoteDatasourceProvider);
  return NotificationRepositoryImpl(remoteDatasource: remoteDatasource);
});
