import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/notifications/domain/entities/app_notification.dart';
import 'package:splito_flutter/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:splito_flutter/features/notifications/presentation/providers/notification_providers.dart';

class MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

class MockUnreadCountNotifier extends UnreadCountNotifier {
  final FutureOr<int> Function() _build;
  MockUnreadCountNotifier(this._build);

  @override
  FutureOr<int> build() => _build();
}

void main() {
  late MockGetNotificationsUseCase mockGetNotificationsUseCase;
  late AppNotification tNotification;
  ProviderContainer? container;

  setUp(() {
    mockGetNotificationsUseCase = MockGetNotificationsUseCase();
    tNotification = AppNotification(
      id: 'notif-1',
      type: 'EXPENSE_CREATED',
      title: 'New expense',
      message: 'Mandeep added dinner',
      isRead: false,
      metadata: null,
      createdAt: DateTime(2026, 1, 1),
    );
  });

  tearDown(() {
    container?.dispose();
    container = null;
  });

  group('hasUnreadProvider', () {
    test('true when unreadCount > 0', () {
      container = ProviderContainer(
        overrides: [
          unreadCountProvider.overrideWith(
            () => MockUnreadCountNotifier(() => 3),
          ),
        ],
      );

      final hasUnread = container!.read(hasUnreadProvider);
      expect(hasUnread, isTrue);
    });

    test('false when unreadCount == 0', () {
      container = ProviderContainer(
        overrides: [
          unreadCountProvider.overrideWith(
            () => MockUnreadCountNotifier(() => 0),
          ),
        ],
      );

      final hasUnread = container!.read(hasUnreadProvider);
      expect(hasUnread, isFalse);
    });

    test('false when loading', () {
      container = ProviderContainer(
        overrides: [
          unreadCountProvider.overrideWith(
            () => MockUnreadCountNotifier(() => Completer<int>().future),
          ),
        ],
      );

      final hasUnread = container!.read(hasUnreadProvider);
      expect(hasUnread, isFalse);
    });
  });

  group('NotificationsNotifier', () {
    test('returns empty list when not authenticated', () async {
      container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(false),
          getNotificationsUseCaseProvider.overrideWithValue(
            mockGetNotificationsUseCase,
          ),
        ],
      );

      final result = await container!.read(notificationsProvider.future);

      expect(result, isEmpty);
      verifyNever(() => mockGetNotificationsUseCase());
    });

    test('returns notifications when authenticated', () async {
      when(
        () => mockGetNotificationsUseCase(),
      ).thenAnswer((_) async => [tNotification]);

      container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWithValue(true),
          getNotificationsUseCaseProvider.overrideWithValue(
            mockGetNotificationsUseCase,
          ),
        ],
      );

      final result = await container!.read(notificationsProvider.future);

      expect(result.length, equals(1));
      expect(result.first, equals(tNotification));
      verify(() => mockGetNotificationsUseCase()).called(1);
    });
  });
}
