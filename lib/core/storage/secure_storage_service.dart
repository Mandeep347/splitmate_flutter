import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstract interface for storing sensitive credentials.
abstract class ISecureStorageService {
  /// Writes a sensitive string value to secure storage.
  Future<void> write(String key, String value);

  /// Reads a sensitive string value. Returns null if key doesn't exist.
  Future<String?> read(String key);

  /// Deletes a specific key.
  Future<void> delete(String key);

  /// Wipes all secured key-value pairs.
  Future<void> clear();

  /// Checks if a key exists in storage.
  Future<bool> containsKey(String key);
}

/// Production implementation of [ISecureStorageService] wrapping [FlutterSecureStorage].
class SecureStorageService implements ISecureStorageService {
  final FlutterSecureStorage _secureStorage;

  const SecureStorageService(this._secureStorage);

  @override
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }

  @override
  Future<bool> containsKey(String key) async {
    return await _secureStorage.containsKey(key: key);
  }
}

/// Provider for raw [FlutterSecureStorage] with encrypted preferences enabled on Android.
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

/// Provider for [ISecureStorageService] interface.
final secureStorageServiceProvider = Provider<ISecureStorageService>((ref) {
  final rawStorage = ref.watch(flutterSecureStorageProvider);
  return SecureStorageService(rawStorage);
});
