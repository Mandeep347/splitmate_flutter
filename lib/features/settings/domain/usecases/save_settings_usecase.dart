import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/app_settings.dart';
import '../repositories/i_settings_repository.dart';

/// Usecase responsible for validating and updating local user configurations.
class SaveSettingsUseCase {
  /// The settings repository instance.
  final ISettingsRepository repository;

  /// Creates a new [SaveSettingsUseCase] instance.
  const SaveSettingsUseCase({required this.repository});

  /// Validates and saves configurations.
  Future<void> call({required AppSettings settings}) async {
    // Validation rules
    if (settings.themeMode != 'system' &&
        settings.themeMode != 'light' &&
        settings.themeMode != 'dark') {
      throw const BusinessRuleFailure(
        'Invalid theme mode.',
        'INVALID_THEME_MODE',
      );
    }

    if (settings.defaultCurrency.trim().isEmpty) {
      throw const BusinessRuleFailure(
        'Currency cannot be empty.',
        'INVALID_CURRENCY',
      );
    }

    try {
      await repository.saveSettings(settings: settings);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
