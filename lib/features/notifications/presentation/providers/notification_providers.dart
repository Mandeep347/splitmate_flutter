import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:splito_flutter/features/notifications/domain/entities/app_notification.dart';
import 'package:splito_flutter/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:splito_flutter/features/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:splito_flutter/features/notifications/domain/usecases/mark_all_read_usecase.dart';
import 'package:splito_flutter/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/utils/provider_ttl.dart';

// ============================================================================
// UseCase Providers
// ============================================================================

/// Provider exposing [GetNotificationsUseCase].
final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetNotificationsUseCase(repository: repository);
});

/// Provider exposing [MarkNotificationReadUseCase].
final markNotificationReadUseCaseProvider = Provider<MarkNotificationReadUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkNotificationReadUseCase(repository: repository);
});

/// Provider exposing [MarkAllReadUseCase].
final markAllReadUseCaseProvider = Provider<MarkAllReadUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkAllReadUseCase(repository: repository);
});

/// Provider exposing [GetUnreadCountUseCase].
final getUnreadCountUseCaseProvider = Provider<GetUnreadCountUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetUnreadCountUseCase(repository: repository);
});

// ============================================================================
// Notifiers & State Providers
// ============================================================================

/// Notifier managing user notifications list.
class NotificationsNotifier extends AsyncNotifier<List<AppNotification>> {
  @override
  FutureOr<List<AppNotification>> build() {
    final isAuthenticated = ref.watch(authStateProvider);
    if (!isAuthenticated) {
      return const [];
    }
    
    ref.cacheWithTTL(ProviderTTL.shortTTL);
    
    final useCase = ref.watch(getNotificationsUseCaseProvider);
    return useCase();
  }

  /// Invalidates this notifier to trigger a manual refresh.
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Provider exposing the user notifications list.
final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<AppNotification>>(() {
  return NotificationsNotifier();
});

/// Notifier managing total unread notifications count.
class UnreadCountNotifier extends AsyncNotifier<int> {
  @override
  FutureOr<int> build() {
    final isAuthenticated = ref.watch(authStateProvider);
    if (!isAuthenticated) {
      return 0;
    }
    final useCase = ref.watch(getUnreadCountUseCaseProvider);
    return useCase();
  }

  /// Invalidates this notifier to trigger a manual refresh.
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Provider exposing the user unread notifications count.
final unreadCountProvider = AsyncNotifierProvider<UnreadCountNotifier, int>(() {
  return UnreadCountNotifier();
});

/// Derived provider checking if there are any unread notifications.
final hasUnreadProvider = Provider<bool>((ref) {
  return (ref.watch(unreadCountProvider).valueOrNull ?? 0) > 0;
});

/// Notifier marking a specific notification as read.
class MarkReadNotifier extends AsyncNotifier<AppNotification?> {
  @override
  FutureOr<AppNotification?> build() {
    return null;
  }

  /// Marks a specific notification as read.
  Future<AppNotification> markRead({required String notificationId}) async {
    state = const AsyncLoading<AppNotification?>();
    try {
      final useCase = ref.read(markNotificationReadUseCaseProvider);
      final updatedNotification = await useCase(notificationId: notificationId);

      ref.invalidate(notificationsProvider);
      ref.invalidate(unreadCountProvider);
      state = AsyncData<AppNotification?>(updatedNotification);
      return updatedNotification;
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<AppNotification?>(failure, stackTrace);
      rethrow;
    }
  }
}

/// Provider exposing the [MarkReadNotifier].
final markReadProvider = AsyncNotifierProvider<MarkReadNotifier, AppNotification?>(() {
  return MarkReadNotifier();
});

/// Notifier marking all notifications as read.
class MarkAllReadNotifier extends AsyncNotifier<int?> {
  @override
  FutureOr<int?> build() {
    return null;
  }

  /// Marks all notifications as read.
  Future<int> markAll() async {
    state = const AsyncLoading<int?>();
    try {
      final useCase = ref.read(markAllReadUseCaseProvider);
      final updatedCount = await useCase();

      ref.invalidate(notificationsProvider);
      ref.invalidate(unreadCountProvider);
      state = AsyncData<int?>(updatedCount);
      return updatedCount;
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<int?>(failure, stackTrace);
      rethrow;
    }
  }
}

/// Provider exposing the [MarkAllReadNotifier].
final markAllReadProvider = AsyncNotifierProvider<MarkAllReadNotifier, int?>(() {
  return MarkAllReadNotifier();
});
