import 'package:flutter/foundation.dart';
import 'package:splito_flutter/core/config/app_branding.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Centralized service handling OS system tray notifications outside the app.
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  final Set<String> _notifiedIds = {};

  /// Initializes local notification settings for Android and iOS.
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notificationsPlugin.initialize(settings);
      _initialized = true;

      // Request Android 13+ (API 33+) notification permissions
      final androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    } catch (e) {
      debugPrint('LocalNotificationService initialization warning: $e');
    }
  }

  /// Displays a system notification banner outside the app.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'splitmate_channel',
      '${AppBranding.name} Notifications',
      channelDescription: 'Notifications for expenses, balances, and group updates',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notificationsPlugin.show(id, title, body, details, payload: payload);
    } catch (e) {
      debugPrint('Failed to display system notification: $e');
    }
  }

  /// Helper to trigger notification for a specific item if it hasn't been shown yet.
  Future<void> notifyIfNew({
    required String notificationId,
    required String title,
    required String body,
  }) async {
    if (_notifiedIds.contains(notificationId)) return;
    _notifiedIds.add(notificationId);
    final numericId = notificationId.hashCode.abs() % 100000;
    await showNotification(id: numericId, title: title, body: body);
  }
}

/// Provider exposing [LocalNotificationService].
final localNotificationServiceProvider = Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});
