import 'package:splito_flutter/core/errors/failures.dart';
import '../repositories/i_settings_repository.dart';

/// Usecase responsible for resetting configuration configurations to defaults.
class ResetSettingsUseCase {
  /// The settings repository instance.
  final ISettingsRepository repository;

  /// Creates a new [ResetSettingsUseCase] instance.
  const ResetSettingsUseCase({required this.repository});

  /// Executes the usecase.
  Future<void> call() async {
    try {
      await repository.resetToDefaults();
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
