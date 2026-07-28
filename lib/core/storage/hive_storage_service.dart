import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

/// Abstract interface for local caching and user preferences using a NoSQL database.
abstract class IHiveStorageService {
  /// Initializes the local database directory path.
  Future<void> init();

  /// Pre-opens a database box by name.
  Future<void> openBox(String boxName);

  /// Writes a value associated with a key inside the specified box.
  Future<void> write<T>(String boxName, String key, T value);

  /// Synchronously reads a value from a box. Returns null if key doesn't exist.
  T? read<T>(String boxName, String key);

  /// Deletes a key from a box.
  Future<void> delete(String boxName, String key);

  /// Wipes all entries from a box.
  Future<void> clearBox(String boxName);

  /// Checks if a key exists in a box.
  bool containsKey(String boxName, String key);

  /// Returns all keys stored in a box.
  List<String> getKeys(String boxName);

  /// Registers custom model adapters for binary encoding/decoding.
  void registerAdapter<T>(TypeAdapter<T> adapter);
}

/// Production implementation of [IHiveStorageService] using [Hive].
class HiveStorageService implements IHiveStorageService {
  const HiveStorageService();

  @override
  Future<void> init() async {
    await Hive.initFlutter();
  }

  @override
  Future<void> openBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<dynamic>(boxName);
    }
  }

  @override
  Future<void> write<T>(String boxName, String key, T value) async {
    final box = Hive.box<dynamic>(boxName);
    await box.put(key, value);
  }

  @override
  T? read<T>(String boxName, String key) {
    final box = Hive.box<dynamic>(boxName);
    final value = box.get(key);
    if (value == null) return null;
    return value as T;
  }

  @override
  Future<void> delete(String boxName, String key) async {
    final box = Hive.box<dynamic>(boxName);
    await box.delete(key);
  }

  @override
  Future<void> clearBox(String boxName) async {
    final box = Hive.box<dynamic>(boxName);
    await box.clear();
  }

  @override
  bool containsKey(String boxName, String key) {
    final box = Hive.box<dynamic>(boxName);
    return box.containsKey(key);
  }

  @override
  List<String> getKeys(String boxName) {
    final box = Hive.box<dynamic>(boxName);
    return box.keys.map((k) => k.toString()).toList();
  }

  @override
  void registerAdapter<T>(TypeAdapter<T> adapter) {
    Hive.registerAdapter(adapter);
  }
}

/// Provider for [IHiveStorageService] interface.
final hiveStorageServiceProvider = Provider<IHiveStorageService>((ref) {
  return const HiveStorageService();
});
