import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/constants/storage_keys.dart';
import 'package:splito_flutter/core/storage/hive_storage_service.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/i_settings_repository.dart';

/// Repository implementation managing device-local settings storage via Hive.
class SettingsRepositoryImpl implements ISettingsRepository {
  /// Hive database storage service dependency.
  final IHiveStorageService storage;

  /// Creates a new [SettingsRepositoryImpl] instance.
  const SettingsRepositoryImpl({required this.storage});

  @override
  Future<AppSettings> getSettings() async {
    try {
      final raw = storage.read<String>(
        StorageKeys.settingsBox,
        StorageKeys.settingsKey,
      );
      if (raw == null) {
        return const AppSettings.defaults();
      }
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return _mapToEntity(map);
    } catch (_) {
      return const AppSettings.defaults();
    }
  }

  @override
  Future<void> saveSettings({required AppSettings settings}) async {
    final map = _entityToMap(settings);
    await storage.write<String>(
      StorageKeys.settingsBox,
      StorageKeys.settingsKey,
      jsonEncode(map),
    );
  }

  @override
  Future<void> resetToDefaults() async {
    await saveSettings(settings: const AppSettings.defaults());
  }

  AppSettings _mapToEntity(Map<String, dynamic> map) {
    return AppSettings(
      themeMode: map['themeMode'] as String? ?? 'system',
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      defaultCurrency: map['defaultCurrency'] as String? ?? 'INR',
      compactExpenseList: map['compactExpenseList'] as bool? ?? false,
    );
  }

  Map<String, dynamic> _entityToMap(AppSettings s) {
    return {
      'themeMode': s.themeMode,
      'notificationsEnabled': s.notificationsEnabled,
      'defaultCurrency': s.defaultCurrency,
      'compactExpenseList': s.compactExpenseList,
    };
  }
}

/// Provider exposing the [ISettingsRepository] implementation.
final settingsRepositoryProvider = Provider<ISettingsRepository>((ref) {
  final storageService = ref.watch(hiveStorageServiceProvider);
  return SettingsRepositoryImpl(storage: storageService);
});
