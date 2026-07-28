import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/theme/theme_provider.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/reset_settings_usecase.dart';
import '../../domain/usecases/save_settings_usecase.dart';

// ============================================================================
// UseCase Providers
// ============================================================================

/// Provider exposing [GetSettingsUseCase].
final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return GetSettingsUseCase(repository: repository);
});

/// Provider exposing [SaveSettingsUseCase].
final saveSettingsUseCaseProvider = Provider<SaveSettingsUseCase>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SaveSettingsUseCase(repository: repository);
});

/// Provider exposing [ResetSettingsUseCase].
final resetSettingsUseCaseProvider = Provider<ResetSettingsUseCase>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return ResetSettingsUseCase(repository: repository);
});

// ============================================================================
// Notifiers & Providers
// ============================================================================

/// Notifier managing application settings state and local updates.
class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  FutureOr<AppSettings> build() {
    final useCase = ref.watch(getSettingsUseCaseProvider);
    return useCase();
  }

  /// Invalidates this notifier to trigger a manual refresh.
  void refresh() {
    ref.invalidateSelf();
  }

  /// Updates the theme mode configuration value.
  Future<void> updateThemeMode(String themeMode) async {
    final current = state.valueOrNull ?? const AppSettings.defaults();
    final updated = current.copyWith(themeMode: themeMode);
    await _save(updated);
  }

  /// Toggles notifications setting state.
  Future<void> updateNotifications(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings.defaults();
    await _save(current.copyWith(notificationsEnabled: enabled));
  }

  /// Updates user preferred default expense currency code.
  Future<void> updateDefaultCurrency(String currency) async {
    final current = state.valueOrNull ?? const AppSettings.defaults();
    await _save(current.copyWith(defaultCurrency: currency));
  }

  /// Toggles betweencomfortable or compact listing cards.
  Future<void> updateCompactList(bool compact) async {
    final current = state.valueOrNull ?? const AppSettings.defaults();
    await _save(current.copyWith(compactExpenseList: compact));
  }

  /// Wipes settings and resets local configuration database to factory settings.
  Future<void> resetToDefaults() async {
    final useCase = ref.read(resetSettingsUseCaseProvider);
    await useCase();
    ref.invalidateSelf();
  }

  Future<void> _save(AppSettings updated) async {
    state = AsyncData(updated);
    final useCase = ref.read(saveSettingsUseCaseProvider);
    await useCase(settings: updated);
  }
}

/// Provider exposing the local [AppSettings] configuration notifier.
final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  () {
    return SettingsNotifier();
  },
);

/// Synchronizes theme configurations from local settings with [themeModeProvider].
final themeSyncProvider = Provider<void>((ref) {
  final settings = ref.watch(settingsProvider).valueOrNull;
  if (settings == null) return;
  final mode = switch (settings.themeMode) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
  Future.microtask(() {
    ref.read(themeModeProvider.notifier).state = mode;
  });
});

/// Exposes user preferred default currency symbol.
final defaultCurrencyProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).valueOrNull?.defaultCurrency ?? 'INR';
});
