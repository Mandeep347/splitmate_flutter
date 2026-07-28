import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract contract for checking network connectivity and monitoring state changes.
abstract interface class IConnectivityService {
  /// Stream emitting boolean network status (true = online with internet access, false = offline).
  Stream<bool> get onConnectivityChanged;

  /// Performs an immediate connectivity check verifying both interface status and IP reachability.
  Future<bool> isOnline();
}

/// Service implementing [IConnectivityService] using [Connectivity] and real IP reachability lookups.
class ConnectivityService implements IConnectivityService {
  final Connectivity _connectivity;
  final Future<List<InternetAddress>> Function(String host)? _addressLookup;

  /// Creates a new [ConnectivityService] instance.
  ConnectivityService({Connectivity? connectivity, this._addressLookup})
    : _connectivity = connectivity ?? Connectivity();

  Stream<bool>? _debouncedStream;

  @override
  Future<bool> isOnline() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final hasInterface = results.any((r) => r != ConnectivityResult.none);
      if (!hasInterface) return false;
      return await _checkReachability();
    } catch (_) {
      return false;
    }
  }

  /// Performs a real reachability check via DNS lookup to 8.8.8.8 with 3s timeout.
  Future<bool> _checkReachability() async {
    try {
      final lookupFn = _addressLookup ?? InternetAddress.lookup;
      final result = await lookupFn(
        '8.8.8.8',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    _debouncedStream ??= _connectivity.onConnectivityChanged
        .asyncMap((results) async {
          final hasInterface = results.any((r) => r != ConnectivityResult.none);
          if (!hasInterface) return false;
          return await _checkReachability();
        })
        .distinct()
        .transform(
          const _DebounceTransformer<bool>(Duration(milliseconds: 500)),
        );

    return _debouncedStream!;
  }
}

/// Custom stream transformer for debouncing stream events by a specified duration.
class _DebounceTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration duration;

  const _DebounceTransformer(this.duration);

  @override
  Stream<T> bind(Stream<T> stream) {
    StreamController<T>? controller;
    StreamSubscription<T>? subscription;
    Timer? timer;

    controller = StreamController<T>(
      onListen: () {
        subscription = stream.listen(
          (data) {
            timer?.cancel();
            timer = Timer(duration, () {
              if (controller != null && !controller.isClosed) {
                controller.add(data);
              }
            });
          },
          onError: (Object error, StackTrace stackTrace) {
            if (controller != null && !controller.isClosed) {
              controller.addError(error, stackTrace);
            }
          },
          onDone: () {
            timer?.cancel();
            if (controller != null && !controller.isClosed) {
              controller.close();
            }
          },
        );
      },
      onCancel: () {
        timer?.cancel();
        subscription?.cancel();
      },
    );

    return controller.stream;
  }
}

/// Provider exposing [IConnectivityService] with ref.keepAlive().
final connectivityServiceProvider = Provider<IConnectivityService>((ref) {
  ref.keepAlive();
  return ConnectivityService();
});
