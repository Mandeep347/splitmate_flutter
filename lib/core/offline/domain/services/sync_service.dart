import 'dart:async';

/// Result summary of an executed offline queue synchronization pass.
class SyncResult {
  /// Number of offline actions successfully processed and completed.
  final int succeeded;

  /// Number of offline actions that failed and were re-queued for retry.
  final int failed;

  /// Number of offline actions that reached max retries and were marked as exhausted.
  final int exhausted;

  /// Creates a new [SyncResult] instance.
  const SyncResult(this.succeeded, this.failed, this.exhausted);

  /// Whether any actions failed or became exhausted during this pass.
  bool get hasFailures => failed > 0 || exhausted > 0;

  /// Whether all processed actions succeeded cleanly.
  bool get allSucceeded => failed == 0 && exhausted == 0;
}

/// Real-time progress update for an ongoing synchronization pass.
class SyncProgress {
  /// Total number of actions to process in this sync pass.
  final int total;

  /// Number of actions completed so far in this pass.
  final int completed;

  /// Human-readable type string of the action currently being processed.
  final String currentActionType;

  /// Creates a new [SyncProgress] instance.
  const SyncProgress({
    required this.total,
    required this.completed,
    required this.currentActionType,
  });
}

/// Abstract contract governing sync engine execution and progress streaming.
abstract interface class ISyncService {
  /// Executes a synchronization pass over all pending offline actions in the queue.
  Future<SyncResult> sync();

  /// Stream emitting real-time progress updates during sync execution.
  Stream<SyncProgress> get onProgress;
}
