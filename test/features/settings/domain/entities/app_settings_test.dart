import 'package:flutter_test/flutter_test.dart';
import 'package:splito_flutter/features/settings/domain/entities/app_settings.dart';

void main() {
  const tSettings = AppSettings(
    themeMode: 'dark',
    notificationsEnabled: true,
    defaultCurrency: 'USD',
    compactExpenseList: false,
  );
  const tDefaultSettings = AppSettings.defaults();

  group('AppSettings', () {
    test('defaults() returns correct default values', () {
      expect(tDefaultSettings.themeMode, 'system');
      expect(tDefaultSettings.notificationsEnabled, true);
      expect(tDefaultSettings.defaultCurrency, 'INR');
      expect(tDefaultSettings.compactExpenseList, false);
    });

    test('copyWith changes only specified fields', () {
      final updated = tDefaultSettings.copyWith(themeMode: 'dark');
      expect(updated.themeMode, 'dark');
      expect(updated.defaultCurrency, 'INR'); // Unchanged field preserved
      expect(updated.notificationsEnabled, true);
      expect(updated.compactExpenseList, false);
    });

    test('copyWith with no args returns equivalent object', () {
      final copy = tSettings.copyWith();
      expect(copy.themeMode, tSettings.themeMode);
      expect(copy.defaultCurrency, tSettings.defaultCurrency);
      expect(copy.notificationsEnabled, tSettings.notificationsEnabled);
      expect(copy.compactExpenseList, tSettings.compactExpenseList);
    });
  });
}
