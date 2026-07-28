import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/settings/domain/entities/app_settings.dart';
import 'package:splito_flutter/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:splito_flutter/features/settings/domain/usecases/save_settings_usecase.dart';

class MockISettingsRepository extends Mock implements ISettingsRepository {}

void main() {
  late MockISettingsRepository mockRepo;
  late SaveSettingsUseCase usecase;

  const tSettings = AppSettings(
    themeMode: 'dark',
    notificationsEnabled: true,
    defaultCurrency: 'USD',
    compactExpenseList: false,
  );

  setUpAll(() {
    registerFallbackValue(const AppSettings.defaults());
  });

  setUp(() {
    mockRepo = MockISettingsRepository();
    usecase = SaveSettingsUseCase(repository: mockRepo);
  });

  group('SaveSettingsUseCase — validation', () {
    test('throws BusinessRuleFailure for invalid themeMode', () async {
      final invalid = tSettings.copyWith(themeMode: 'purple');
      expect(
        () => usecase(settings: invalid),
        throwsA(
          isA<BusinessRuleFailure>().having(
            (f) => f.code,
            'code',
            'INVALID_THEME_MODE',
          ),
        ),
      );
      verifyNever(
        () => mockRepo.saveSettings(settings: any(named: 'settings')),
      );
    });

    test('throws BusinessRuleFailure for empty currency', () async {
      final invalid = tSettings.copyWith(defaultCurrency: '');
      expect(
        () => usecase(settings: invalid),
        throwsA(
          isA<BusinessRuleFailure>().having(
            (f) => f.code,
            'code',
            'INVALID_CURRENCY',
          ),
        ),
      );
      verifyNever(
        () => mockRepo.saveSettings(settings: any(named: 'settings')),
      );
    });

    test('does NOT call repository on validation failure', () async {
      final invalid = tSettings.copyWith(defaultCurrency: '  ');
      try {
        await usecase(settings: invalid);
      } catch (_) {}
      verifyNever(
        () => mockRepo.saveSettings(settings: any(named: 'settings')),
      );
    });

    test('calls repository with valid settings', () async {
      when(
        () => mockRepo.saveSettings(settings: any(named: 'settings')),
      ).thenAnswer((_) async {});

      await usecase(settings: tSettings);

      verify(() => mockRepo.saveSettings(settings: tSettings)).called(1);
    });

    test('accepts all valid themeMode values', () async {
      when(
        () => mockRepo.saveSettings(settings: any(named: 'settings')),
      ).thenAnswer((_) async {});

      for (final mode in ['system', 'light', 'dark']) {
        final s = tSettings.copyWith(themeMode: mode);
        await expectLater(usecase(settings: s), completes);
      }
    });
  });
}
