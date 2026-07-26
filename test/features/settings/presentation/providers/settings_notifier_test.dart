import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:splito_flutter/features/settings/domain/entities/app_settings.dart';
import 'package:splito_flutter/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:splito_flutter/features/settings/presentation/providers/settings_providers.dart';

class MockISettingsRepository extends Mock implements ISettingsRepository {}

void main() {
  late MockISettingsRepository mockRepo;
  late ProviderContainer container;

  const tSettings = AppSettings(
    themeMode: 'dark',
    notificationsEnabled: true,
    defaultCurrency: 'USD',
    compactExpenseList: false,
  );
  const tDefaultSettings = AppSettings.defaults();

  setUpAll(() {
    registerFallbackValue(const AppSettings.defaults());
  });

  setUp(() {
    mockRepo = MockISettingsRepository();
    container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('SettingsNotifier', () {
    test('builds with settings from repository', () async {
      when(() => mockRepo.getSettings()).thenAnswer((_) async => tSettings);

      final state = await container.read(settingsProvider.future);

      expect(state.themeMode, 'dark');
      expect(state.defaultCurrency, 'USD');
      verify(() => mockRepo.getSettings()).called(1);
    });

    test('updateThemeMode updates state optimistically', () async {
      when(() => mockRepo.getSettings()).thenAnswer((_) async => tDefaultSettings);
      when(() => mockRepo.saveSettings(settings: any(named: 'settings')))
          .thenAnswer((_) async {});

      // Build initial state
      await container.read(settingsProvider.future);
      expect(container.read(settingsProvider).valueOrNull?.themeMode, 'system');

      // Trigger update without awaiting immediately to verify optimistic update
      final future = container.read(settingsProvider.notifier).updateThemeMode('dark');

      final immediate = container.read(settingsProvider).valueOrNull;
      expect(immediate?.themeMode, 'dark'); // State updated immediately

      await future; // Wait for write to finish
    });

    test('resetToDefaults rebuilds provider with defaults', () async {
      when(() => mockRepo.getSettings()).thenAnswer((_) async => tSettings);
      when(() => mockRepo.resetToDefaults()).thenAnswer((_) async {});

      // Initial state is dark
      final initial = await container.read(settingsProvider.future);
      expect(initial.themeMode, 'dark');

      // Setup repository state change
      when(() => mockRepo.getSettings()).thenAnswer((_) async => tDefaultSettings);

      await container.read(settingsProvider.notifier).resetToDefaults();

      final state = await container.read(settingsProvider.future);
      expect(state.themeMode, 'system');
      verify(() => mockRepo.resetToDefaults()).called(1);
    });
  });
}
