import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/storage_keys.dart';
import '../storage/hive_storage_service.dart';

/// Representation of an API request queued during offline state.
class QueuedRequest {
  final String path;
  final String method;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? queryParameters;
  final Map<String, String>? headers;
  final String timestamp;

  const QueuedRequest({
    required this.path,
    required this.method,
    this.data,
    this.queryParameters,
    this.headers,
    required this.timestamp,
  });

  /// Convert model instance to a JSON Map.
  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'method': method,
      'data': data,
      'queryParameters': queryParameters,
      'headers': headers,
      'timestamp': timestamp,
    };
  }

  /// Rebuild model instance from a Map structure.
  factory QueuedRequest.fromMap(Map<String, dynamic> map) {
    return QueuedRequest(
      path: map['path'] as String,
      method: map['method'] as String,
      data: map['data'] != null
          ? Map<String, dynamic>.from(map['data'] as Map)
          : null,
      queryParameters: map['queryParameters'] != null
          ? Map<String, dynamic>.from(map['queryParameters'] as Map)
          : null,
      headers: map['headers'] != null
          ? Map<String, String>.from(map['headers'] as Map)
          : null,
      timestamp: map['timestamp'] as String,
    );
  }

  /// Serialize to raw JSON string.
  String toJson() => json.encode(toMap());

  /// Deserialize from raw JSON string.
  factory QueuedRequest.fromJson(String source) =>
      QueuedRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}

/// Abstract contract for managing requests queued while offline.
abstract class IOfflineRequestQueue {
  /// Enqueues a failed write operation request.
  Future<void> enqueue(QueuedRequest request);

  /// Retrieves the list of currently queued write operations.
  List<QueuedRequest> getQueue();

  /// Removes a processed request from the queue by its index.
  Future<void> removeAt(int index);

  /// Wipes all queued requests.
  Future<void> clear();
}

/// Hive implementation of [IOfflineRequestQueue].
class OfflineRequestQueue implements IOfflineRequestQueue {
  final IHiveStorageService _hiveService;

  const OfflineRequestQueue(this._hiveService);

  @override
  Future<void> enqueue(QueuedRequest request) async {
    final currentQueue = getQueue();
    currentQueue.add(request);

    final jsonList = currentQueue.map((r) => r.toJson()).toList();
    await _hiveService.write<List<dynamic>>(
      StorageKeys.offlineQueueBox,
      StorageKeys.offlineQueueBox,
      jsonList,
    );
  }

  @override
  List<QueuedRequest> getQueue() {
    final rawList = _hiveService.read<List<dynamic>>(
      StorageKeys.offlineQueueBox,
      StorageKeys.offlineQueueBox,
    );
    if (rawList == null) return [];

    return rawList
        .map((item) => QueuedRequest.fromJson(item as String))
        .toList();
  }

  @override
  Future<void> removeAt(int index) async {
    final currentQueue = getQueue();
    if (index >= 0 && index < currentQueue.length) {
      currentQueue.removeAt(index);
      final jsonList = currentQueue.map((r) => r.toJson()).toList();
      await _hiveService.write<List<dynamic>>(
        StorageKeys.offlineQueueBox,
        StorageKeys.offlineQueueBox,
        jsonList,
      );
    }
  }

  @override
  Future<void> clear() async {
    await _hiveService.clearBox(StorageKeys.offlineQueueBox);
  }
}

/// Provider for [IOfflineRequestQueue] interface.
final offlineRequestQueueProvider = Provider<IOfflineRequestQueue>((ref) {
  final hiveService = ref.watch(hiveStorageServiceProvider);
  return OfflineRequestQueue(hiveService);
});
