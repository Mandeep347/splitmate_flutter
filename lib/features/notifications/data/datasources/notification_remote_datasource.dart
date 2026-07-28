import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/constants/app_constants.dart';
import 'package:splito_flutter/core/network/dio_client.dart';
import '../models/notification_model.dart';

/// Abstract contract governing remote REST calls for notifications.
abstract interface class INotificationRemoteDatasource {
  /// Fetches notifications for the authenticated user.
  Future<List<NotificationModel>> getNotifications();

  /// Marks a specific notification as read.
  Future<NotificationModel> markAsRead({required String notificationId});

  /// Marks all notifications as read for the authenticated user, returning updated count.
  Future<int> markAllAsRead();
}

/// Remote datasource implementation using [DioClient].
class NotificationRemoteDatasource implements INotificationRemoteDatasource {
  /// The dio client instance.
  final DioClient client;

  /// Creates a new [NotificationRemoteDatasource] instance.
  const NotificationRemoteDatasource({required this.client});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await client.get<dynamic>(ApiEndpoints.notifications);
    final list = response.data as List<dynamic>;
    return list
        .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<NotificationModel> markAsRead({required String notificationId}) async {
    final response = await client.patch<dynamic>(
      ApiEndpoints.markNotificationRead(notificationId),
    );
    final data = response.data as Map<String, dynamic>;
    return NotificationModel.fromJson(data);
  }

  @override
  Future<int> markAllAsRead() async {
    final response = await client.patch<dynamic>(
      ApiEndpoints.markAllNotificationsRead,
    );
    final data = response.data as Map<String, dynamic>;
    return data['updated_count'] as int;
  }
}

/// Provider exposing [INotificationRemoteDatasource] implementation.
final notificationRemoteDatasourceProvider =
    Provider<INotificationRemoteDatasource>((ref) {
      final dioClient = ref.watch(dioClientProvider);
      return NotificationRemoteDatasource(client: dioClient);
    });
