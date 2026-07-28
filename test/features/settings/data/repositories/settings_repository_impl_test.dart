import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/constants/storage_keys.dart';
import 'package:splito_flutter/core/storage/hive_storage_service.dart';
import 'package:splito_flutter/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:splito_flutter/features/settings/domain/entities/app_settings.dart';

class MockIHiveStorageService extends Mock implements IHiveStorageService {}

void main() {
  late MockIHiveStorageService mockStorage;
  late SettingsRepositoryImpl repo;

  const tSettings = AppSettings(
    themeMode: 'dark',
    notificationsEnabled: true,
    defaultCurrency: 'USD',
    compactExpenseList: false,
  );

  setUp(() {
    mockStorage = MockIHiveStorageService();
    repo = SettingsRepositoryImpl(storage: mockStorage);
  });

  group('getSettings', () {
    test('returns defaults when storage has no saved settings', () async {
      when(() => mockStorage.read<String>(any(), any())).thenReturn(null);

      final result = await repo.getSettings();

      expect(result.themeMode, 'system');
      expect(result.defaultCurrency, 'INR');
      expect(result.notificationsEnabled, true);
      expect(result.compactExpenseList, false);
    });

    test('returns parsed settings when storage has data', () async {
      final json = jsonEncode({
        'themeMode': 'dark',
        'notificationsEnabled': false,
        'defaultCurrency': 'USD',
        'compactExpenseList': true,
      });
      when(() => mockStorage.read<String>(any(), any())).thenReturn(json);

      final result = await repo.getSettings();

      expect(result.themeMode, 'dark');
      expect(result.defaultCurrency, 'USD');
      expect(result.notificationsEnabled, false);
      expect(result.compactExpenseList, true);
    });

    test('returns defaults on malformed JSON (never throws)', () async {
      when(
        () => mockStorage.read<String>(any(), any()),
      ).thenReturn('not-valid-json');

      final result = await repo.getSettings();

      expect(result.themeMode, 'system');
      expect(result.defaultCurrency, 'INR');
    });
  });

  group('saveSettings', () {
    test('writes jsonEncoded settings to correct box and key', () async {
      when(
        () => mockStorage.write<String>(any(), any(), any()),
      ).thenAnswer((_) async {});

      await repo.saveSettings(settings: tSettings);

      final captured =
          verify(
                () => mockStorage.write<String>(
                  StorageKeys.settingsBox,
                  StorageKeys.settingsKey,
                  captureAny(),
                ),
              ).captured.first
              as String;

      final decoded = jsonDecode(captured) as Map<String, dynamic>;
      expect(decoded['themeMode'], 'dark');
      expect(decoded['defaultCurrency'], 'USD');
      expect(decoded['notificationsEnabled'], true);
      expect(decoded['compactExpenseList'], false);
    });
  });
}
