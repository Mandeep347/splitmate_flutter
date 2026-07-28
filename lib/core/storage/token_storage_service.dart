import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract contract managing persistent JWT token storage operations.
abstract interface class ITokenStorageService {
  /// Writes secure access and refresh tokens to persistent storage.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  /// Reads the secure access token from storage.
  Future<String?> getAccessToken();

  /// Reads the secure refresh token from storage.
  Future<String?> getRefreshToken();

  /// Deletes access and refresh tokens from secure storage.
  Future<void> clearTokens();

  /// Validates presence of both access and refresh tokens in storage.
  Future<bool> hasTokens();
}

/// Secure storage service implementation using [FlutterSecureStorage].
///
/// When the hardware-backed Android KeyStore is unavailable (emulator or
/// device without lock screen), every operation falls back to a shared
/// [_fallbackStorage] instance. If even that fails, reads return `null`
/// and writes/deletes silently no-op so callers never receive an
/// unhandled [OperationError].
class TokenStorageService implements ITokenStorageService {
  final FlutterSecureStorage _storage;

  const TokenStorageService(this._storage);

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  /// Shared fallback storage instance. Using a single static instance
  /// guarantees that writes and reads go to the same underlying bucket.
  static const FlutterSecureStorage _fallbackStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: false),
  );

  /// In-memory token cache used as a last resort when both primary
  /// and fallback secure storage are unavailable.
  static final Map<String, String> _memoryCache = {};

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    // Always update in-memory cache so the current session works
    // even if all persistent writes fail.
    _memoryCache[_accessTokenKey] = accessToken;
    _memoryCache[_refreshTokenKey] = refreshToken;

    // Write to both primary and fallback storage so key resets on Android don't erase tokens
    try {
      await Future.wait([
        _storage.write(key: _accessTokenKey, value: accessToken),
        _storage.write(key: _refreshTokenKey, value: refreshToken),
      ]);
    } catch (e) {
      // ignore: avoid_print
      debugPrint('Warning: Secure storage write failed: $e');
    }

    try {
      await Future.wait([
        _fallbackStorage.write(key: _accessTokenKey, value: accessToken),
        _fallbackStorage.write(key: _refreshTokenKey, value: refreshToken),
      ]);
    } catch (e) {
      // ignore: avoid_print
      debugPrint('Warning: Fallback storage write failed: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return _readKey(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _readKey(_refreshTokenKey);
  }

  /// Reads [key] from primary → fallback → in-memory cache.
  /// Never throws.
  Future<String?> _readKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (value != null) return value;
    } catch (_) {
      // ignore: avoid_print
      debugPrint('Warning: Secure storage read failed for $key. Trying fallback.');
    }

    try {
      final value = await _fallbackStorage.read(key: key);
      if (value != null) return value;
    } catch (_) {
      // ignore: avoid_print
      debugPrint('Warning: Fallback storage read also failed for $key. Using in-memory.');
    }

    return _memoryCache[key];
  }

  @override
  Future<void> clearTokens() async {
    _memoryCache.remove(_accessTokenKey);
    _memoryCache.remove(_refreshTokenKey);

    try {
      await Future.wait([
        _storage.delete(key: _accessTokenKey),
        _storage.delete(key: _refreshTokenKey),
      ]);
    } catch (_) {
      // ignore: avoid_print
      debugPrint('Warning: Secure storage delete failed. Trying fallback.');
    }

    try {
      await Future.wait([
        _fallbackStorage.delete(key: _accessTokenKey),
        _fallbackStorage.delete(key: _refreshTokenKey),
      ]);
    } catch (_) {
      // ignore: avoid_print
      debugPrint('Warning: Fallback storage delete also failed.');
    }
  }

  @override
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }
}

/// Provider exposing [ITokenStorageService].
final tokenStorageServiceProvider = Provider<ITokenStorageService>((ref) {
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
  return const TokenStorageService(secureStorage);
});
