import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/network/dio_client.dart';
import 'package:splito_flutter/core/utils/package_info_service.dart';

/// Holds information about an available app update.
class UpdateInfo {
  /// The latest version string from GitHub (e.g. 'v1.2.0').
  final String latestVersion;

  /// Direct APK download URL from the GitHub release assets.
  final String downloadUrl;

  /// Markdown release notes body from the GitHub release.
  final String releaseNotes;

  /// ISO-8601 published date of the release.
  final String publishedAt;

  const UpdateInfo({
    required this.latestVersion,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.publishedAt,
  });
}

/// Service that checks the GitHub Releases API for a newer version of the app.
class UpdateService {
  static const String _githubApiUrl =
      'https://api.github.com/repos/Mandeep347/splito_flutter/releases/latest';

  final Dio _dio;

  /// Creates an [UpdateService] using the provided [Dio] instance.
  // ignore: prefer_initializing_formals
  const UpdateService({required Dio dio}) : _dio = dio;

  /// Checks GitHub for a newer release than the currently installed version.
  ///
  /// Returns an [UpdateInfo] when a newer version is found.
  /// Returns `null` when up-to-date or when any error occurs (network, parsing, etc.).
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final response = await _dio.get<dynamic>(_githubApiUrl);
      final data = response.data as Map<String, dynamic>?;
      if (data == null) return null;

      final tagName = data['tag_name'] as String? ?? '';
      if (tagName.isEmpty) return null;

      final currentVersion = PackageInfoService.version;
      if (!_isNewer(tagName, currentVersion)) return null;

      final assets = data['assets'] as List<dynamic>? ?? [];
      final apkUrl = _findApkUrl(assets);
      if (apkUrl == null) return null;

      return UpdateInfo(
        latestVersion: tagName,
        downloadUrl: apkUrl,
        releaseNotes: data['body'] as String? ?? '',
        publishedAt: data['published_at'] as String? ?? '',
      );
    } catch (_) {
      // Never crash the settings page — silently swallow all errors.
      return null;
    }
  }

  /// Fetches the APK download URL without comparing versions.
  /// Used by the download banner / page where we just want the latest APK URL.
  Future<String?> fetchLatestApkUrl() async {
    try {
      final response = await _dio.get<dynamic>(_githubApiUrl);
      final data = response.data as Map<String, dynamic>?;
      if (data == null) return null;
      final assets = data['assets'] as List<dynamic>? ?? [];
      return _findApkUrl(assets);
    } catch (_) {
      return null;
    }
  }

  /// Returns `true` if [latest] version is strictly greater than [current].
  ///
  /// Both strings may have a leading 'v' which is stripped before comparison.
  bool _isNewer(String latest, String current) {
    try {
      final latestParts = _parseSemver(latest);
      final currentParts = _parseSemver(current);
      for (var i = 0; i < 3; i++) {
        final l = i < latestParts.length ? latestParts[i] : 0;
        final c = i < currentParts.length ? currentParts[i] : 0;
        if (l > c) return true;
        if (l < c) return false;
      }
      return false; // equal
    } catch (_) {
      return false;
    }
  }

  List<int> _parseSemver(String version) {
    final clean = version.startsWith('v') ? version.substring(1) : version;
    // Strip any pre-release suffix (e.g. '1.2.0-beta')
    final base = clean.split('-').first;
    return base.split('.').map((p) => int.tryParse(p) ?? 0).toList();
  }

  /// Finds the first APK asset and returns its browser download URL, or `null`.
  String? _findApkUrl(List<dynamic> assets) {
    for (final asset in assets) {
      if (asset is Map<String, dynamic>) {
        final name = asset['name'] as String? ?? '';
        if (name.toLowerCase().endsWith('.apk')) {
          return asset['browser_download_url'] as String?;
        }
      }
    }
    return null;
  }
}

/// Provider exposing the [UpdateService] singleton.
final updateServiceProvider = Provider<UpdateService>((ref) {
  // Use the raw Dio from dioClientProvider's underlying instance.
  final client = ref.watch(dioClientProvider);
  return UpdateService(dio: client.dio);
});
