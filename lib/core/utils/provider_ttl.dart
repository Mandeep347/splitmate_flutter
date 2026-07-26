import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';

class ProviderTTL {
  static const Duration shortTTL = Duration(minutes: 2);
  static const Duration mediumTTL = Duration(minutes: 5);
  static const Duration longTTL = Duration(minutes: 15);
}

extension ProviderTTLExtension on Ref {
  /// Schedules a self-invalidation after the given [ttl].
  /// Invalidation only occurs if the user is still authenticated.
  void cacheWithTTL(Duration ttl) {
    bool disposed = false;
    onDispose(() => disposed = true);

    final timer = Timer(ttl, () {
      if (!disposed) {
        final isAuthenticated = read(authStateProvider);
        if (isAuthenticated) {
          invalidateSelf();
        }
      }
    });

    onDispose(timer.cancel);
  }
}
