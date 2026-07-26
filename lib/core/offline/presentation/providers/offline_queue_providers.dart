import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/offline/data/repositories/offline_queue_repository_impl.dart';

export 'package:splito_flutter/core/offline/data/repositories/offline_queue_repository_impl.dart'
    show offlineQueueRepositoryProvider;

/// FutureProvider that fetches the count of pending offline actions.
/// Auto-refreshes when invalidated.
final pendingCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(offlineQueueRepositoryProvider);
  return repository.getPendingCount();
});

/// Convenience provider indicating whether any offline actions are currently pending.
final hasPendingActionsProvider = Provider<bool>((ref) {
  final count = ref.watch(pendingCountProvider).valueOrNull;
  return count != null && count > 0;
});
