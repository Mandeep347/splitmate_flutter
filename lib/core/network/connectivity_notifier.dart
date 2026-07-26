import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/network/connectivity_service.dart';
import 'package:splito_flutter/core/offline/domain/services/sync_service.dart';
import 'package:splito_flutter/core/offline/data/services/sync_service_impl.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/features/balances/presentation/providers/balance_providers.dart';
import 'package:splito_flutter/core/offline/presentation/providers/offline_queue_providers.dart';
import 'package:splito_flutter/features/activity/presentation/providers/activity_providers.dart';
import 'package:splito_flutter/features/analytics/presentation/providers/analytics_providers.dart';

/// Notifier managing real-time internet connectivity status.
class ConnectivityNotifier extends AsyncNotifier<bool> {
  StreamSubscription<bool>? _subscription;

  @override
  FutureOr<bool> build() async {
    ref.keepAlive();
    final service = ref.watch(connectivityServiceProvider);

    _subscription?.cancel();
    _subscription = service.onConnectivityChanged.listen((isOnline) {
      state = AsyncData(isOnline);
      if (isOnline) {
        _triggerAutoSync();
      }
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    final initialIsOnline = await service.isOnline();
    if (initialIsOnline) {
      _triggerAutoSync();
    }
    return initialIsOnline;
  }

  void _triggerAutoSync() {
    Future.microtask(() async {
      final queueRepo = ref.read(offlineQueueRepositoryProvider);
      final count = await queueRepo.getPendingCount();
      if (count > 0) {
        final result = await ref.read(syncServiceProvider).sync();
        ref.invalidate(pendingCountProvider);
        if (result.succeeded > 0) {
          ref.invalidate(myGroupsProvider);
          ref.invalidate(myOverallBalancesProvider);
          ref.invalidate(globalActivityProvider);
          ref.invalidate(userAnalyticsProvider);
        }
      }
    });
  }
}

/// Provider exposing [ConnectivityNotifier] state with ref.keepAlive().
final connectivityProvider =
    AsyncNotifierProvider<ConnectivityNotifier, bool>(() {
  return ConnectivityNotifier();
});

/// Convenience provider for checking boolean connectivity state.
/// Defaults to true to assume online state on startup until proven otherwise,
/// preventing false offline UI on cold start.
final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider).valueOrNull ?? true;
});
