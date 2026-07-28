import 'package:splito_flutter/core/errors/failures.dart';
import '../entities/app_settings.dart';
import '../repositories/i_settings_repository.dart';

/// Usecase responsible for fetching local configuration preferences.
class GetSettingsUseCase {
  /// The settings repository instance.
  final ISettingsRepository repository;

  /// Creates a new [GetSettingsUseCase] instance.
  const GetSettingsUseCase({required this.repository});

  /// Executes the usecase.
  Future<AppSettings> call() async {
    try {
      return await repository.getSettings();
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
