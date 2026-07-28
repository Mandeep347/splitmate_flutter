import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/notifications/domain/entities/app_notification.dart';
import 'package:splito_flutter/features/notifications/domain/repositories/i_notification_repository.dart';
import 'package:splito_flutter/features/notifications/domain/usecases/mark_notification_read_usecase.dart';

class MockINotificationRepository extends Mock
    implements INotificationRepository {}

void main() {
  late MockINotificationRepository mockRepository;
  late MarkNotificationReadUseCase usecase;

  final tNotification = AppNotification(
    id: 'notif-1',
    type: 'EXPENSE_CREATED',
    title: 'New expense',
    message: 'Mandeep added dinner',
    isRead: true,
    metadata: null,
    createdAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    mockRepository = MockINotificationRepository();
    usecase = MarkNotificationReadUseCase(repository: mockRepository);
  });

  group('MarkNotificationReadUseCase', () {
    test('calls repository with correct notificationId', () async {
      when(
        () => mockRepository.markAsRead(notificationId: 'notif-1'),
      ).thenAnswer((_) async => tNotification);

      final result = await usecase(notificationId: 'notif-1');

      expect(result, equals(tNotification));
      verify(
        () => mockRepository.markAsRead(notificationId: 'notif-1'),
      ).called(1);
    });

    test('maps NetworkException to NetworkFailure', () async {
      when(
        () => mockRepository.markAsRead(notificationId: 'notif-1'),
      ).thenThrow(const NetworkException('No connection'));

      expect(
        () => usecase(notificationId: 'notif-1'),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('completes without error on success', () async {
      when(
        () => mockRepository.markAsRead(notificationId: 'notif-1'),
      ).thenAnswer((_) async => tNotification);

      final result = await usecase(notificationId: 'notif-1');
      expect(result.isRead, isTrue);
    });
  });
}
