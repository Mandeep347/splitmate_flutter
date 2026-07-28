import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/constants/storage_keys.dart';
import 'package:splito_flutter/core/storage/hive_storage_service.dart';
import '../models/activity_item_model.dart';

/// Abstract contract governing local persistence of group activities feed.
abstract interface class IActivityLocalDatasource {
  /// Caches the page 1 activity items for a group.
  Future<void> cacheActivities({
    required String groupId,
    required List<ActivityItemModel> items,
  });

  /// Retrieves the cached activity items list, or null if missing.
  Future<List<ActivityItemModel>?> getCachedActivities(String groupId);

  /// Clears the cached activities for a specific group.
  Future<void> clearActivitiesCache(String groupId);
}

/// Local NoSQL caching implementation of activity feed.
class ActivityLocalDatasource implements IActivityLocalDatasource {
  /// The local NoSQL storage service dependency.
  final IHiveStorageService storage;

  /// Creates a new [ActivityLocalDatasource] instance.
  const ActivityLocalDatasource({required this.storage});

  static const String _boxName = StorageKeys.activityCacheBox;

  @override
  Future<void> cacheActivities({
    required String groupId,
    required List<ActivityItemModel> items,
  }) async {
    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await storage.write<String>(_boxName, 'activities_$groupId', jsonString);
  }

  @override
  Future<List<ActivityItemModel>?> getCachedActivities(String groupId) async {
    try {
      final jsonString = storage.read<String>(_boxName, 'activities_$groupId');
      if (jsonString == null) return null;
      final list = jsonDecode(jsonString) as List<dynamic>;
      return list
          .map(
            (item) => ActivityItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearActivitiesCache(String groupId) async {
    await storage.delete(_boxName, 'activities_$groupId');
  }
}

/// Provider exposing [IActivityLocalDatasource] implementation.
final activityLocalDatasourceProvider = Provider<IActivityLocalDatasource>((
  ref,
) {
  final storageService = ref.watch(hiveStorageServiceProvider);
  return ActivityLocalDatasource(storage: storageService);
});
