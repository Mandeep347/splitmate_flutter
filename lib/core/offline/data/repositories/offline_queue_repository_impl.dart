import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/constants/storage_keys.dart';
import 'package:splito_flutter/core/offline/domain/entities/offline_action.dart';
import 'package:splito_flutter/core/offline/domain/repositories/i_offline_queue_repository.dart';
import 'package:splito_flutter/core/storage/hive_storage_service.dart';

/// Implementation of [IOfflineQueueRepository] backed by [IHiveStorageService].
class OfflineQueueRepositoryImpl implements IOfflineQueueRepository {
  final IHiveStorageService storage;

  /// Creates a new [OfflineQueueRepositoryImpl] instance.
  const OfflineQueueRepositoryImpl(this.storage);

  static const String _boxName = StorageKeys.offlineQueueBox;

  @override
  Future<void> enqueue(OfflineAction action) async {
    final key = 'action_${action.id}';
    final jsonString = jsonEncode(action.toJson());
    await storage.write<String>(_boxName, key, jsonString);
  }

  @override
  Future<List<OfflineAction>> getPending() async {
    try {
      final keys = storage.getKeys(_boxName);
      final actionKeys = keys.where((k) => k.startsWith('action_')).toList();
      final List<OfflineAction> pendingActions = [];

      for (final key in actionKeys) {
        final jsonString = storage.read<String>(_boxName, key);
        if (jsonString != null && jsonString.isNotEmpty) {
          try {
            final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
            final action = OfflineAction.fromJson(jsonMap);
            if (!action.isExhausted) {
              pendingActions.add(action);
            }
          } catch (e) {
            debugPrint('Failed to parse offline action for key $key: $e');
          }
        }
      }

      pendingActions.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return pendingActions;
    } catch (e) {
      debugPrint('Error retrieving pending offline actions: $e');
      return [];
    }
  }

  @override
  Future<void> markCompleted(String actionId) async {
    final actionKey = 'action_$actionId';
    final doneKey = 'done_$actionId';

    final raw = storage.read<String>(_boxName, actionKey);
    await storage.delete(_boxName, actionKey);

    final auditData = jsonEncode({
      'actionId': actionId,
      'completedAt': DateTime.now().toIso8601String(),
      'rawAction': raw,
    });
    await storage.write<String>(_boxName, doneKey, auditData);
  }

  @override
  Future<void> incrementRetry(String actionId) async {
    final actionKey = 'action_$actionId';
    final raw = storage.read<String>(_boxName, actionKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final jsonMap = jsonDecode(raw) as Map<String, dynamic>;
      final action = OfflineAction.fromJson(jsonMap);
      final updatedAction = action.copyWith(retryCount: action.retryCount + 1);

      if (updatedAction.isExhausted) {
        await markExhausted(actionId);
      } else {
        await storage.write<String>(_boxName, actionKey, jsonEncode(updatedAction.toJson()));
      }
    } catch (e) {
      debugPrint('Error incrementing retry for action $actionId: $e');
    }
  }

  @override
  Future<void> markExhausted(String actionId) async {
    final actionKey = 'action_$actionId';
    final exhaustedKey = 'exhausted_$actionId';

    final raw = storage.read<String>(_boxName, actionKey);
    await storage.delete(_boxName, actionKey);

    if (raw != null) {
      await storage.write<String>(_boxName, exhaustedKey, raw);
    }
    debugPrint('WARNING: OfflineAction $actionId reached max retries and was marked as exhausted.');
  }

  @override
  Future<void> clearCompleted() async {
    final keys = storage.getKeys(_boxName);
    final doneKeys = keys.where((k) => k.startsWith('done_')).toList();
    for (final key in doneKeys) {
      await storage.delete(_boxName, key);
    }
  }

  @override
  Future<int> getPendingCount() async {
    final pending = await getPending();
    return pending.length;
  }
}

/// Provider exposing [IOfflineQueueRepository] with ref.keepAlive().
final offlineQueueRepositoryProvider = Provider<IOfflineQueueRepository>((ref) {
  ref.keepAlive();
  final storage = ref.watch(hiveStorageServiceProvider);
  return OfflineQueueRepositoryImpl(storage);
});
