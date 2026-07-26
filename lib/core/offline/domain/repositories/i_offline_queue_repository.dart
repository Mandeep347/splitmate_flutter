import '../entities/offline_action.dart';

/// Abstract contract governing offline queue storage operations.
abstract interface class IOfflineQueueRepository {
  /// Enqueues a new offline action into persistent storage.
  Future<void> enqueue(OfflineAction action);

  /// Retrieves all pending (non-completed and non-exhausted) offline actions in FIFO order.
  Future<List<OfflineAction>> getPending();

  /// Marks an action as completed and removes or flags it in storage.
  Future<void> markCompleted(String actionId);

  /// Increments the retry count for a failed action.
  Future<void> incrementRetry(String actionId);

  /// Marks an action as exhausted after reaching max retries.
  Future<void> markExhausted(String actionId);

  /// Removes all completed actions from storage.
  Future<void> clearCompleted();

  /// Gets the count of pending offline actions.
  Future<int> getPendingCount();
}
