import 'package:package_info_plus/package_info_plus.dart';

/// Reads and caches application version and build number details at runtime.
class PackageInfoService {
  static String _version = '';
  static String _buildNumber = '';

  /// Initializes package info asynchronously from platform bindings.
  static Future<void> init() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _version = info.version;
      _buildNumber = info.buildNumber;
    } catch (_) {
      // Fallback defaults for testing environment or missing platform channel bindings
      _version = '1.0.0';
      _buildNumber = '1';
    }
  }

  /// App version string (e.g. '1.0.0')
  static String get version => _version;

  /// Full formatted app version with build number (e.g. '1.0.0+1')
  static String get fullVersion => '$_version+$_buildNumber';
}
