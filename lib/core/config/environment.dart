/// Defines supported environment types.
enum EnvironmentType {
  dev,
  staging,
  prod,
}

/// Environment configuration loader for Splito.
/// Reads configuration variables injected at compile-time via --dart-define or --dart-define-from-file.
abstract class AppEnvironment {
  // Key names used for injection
  static const String _envKey = 'ENV';
  static const String _apiBaseUrlKey = 'API_BASE_URL';
  static const String _appNameKey = 'APP_NAME';

  // Read raw properties from the compilation environment
  static const String _rawEnv = String.fromEnvironment(
    _envKey,
    defaultValue: 'dev',
  );

  static const String _rawApiBaseUrl = String.fromEnvironment(
    _apiBaseUrlKey,
    defaultValue: 'http://localhost:8000/api/v1',
  );

  static const String _rawAppName = String.fromEnvironment(
    _appNameKey,
    defaultValue: 'Splitmate (Dev)',
  );

  /// Resolves the current [EnvironmentType] from compilation values.
  static EnvironmentType get type {
    switch (_rawEnv.toLowerCase()) {
      case 'prod':
      case 'production':
        return EnvironmentType.prod;
      case 'staging':
        return EnvironmentType.staging;
      case 'dev':
      case 'development':
      default:
        return EnvironmentType.dev;
    }
  }

  /// App name for current compile profile.
  static String get appName => _rawAppName;

  /// Base API Endpoint configuration.
  static String get apiBaseUrl => _rawApiBaseUrl;

  /// Utility flags for environment checks.
  static bool get isDev => type == EnvironmentType.dev;
  static bool get isStaging => type == EnvironmentType.staging;
  static bool get isProd => type == EnvironmentType.prod;
}
