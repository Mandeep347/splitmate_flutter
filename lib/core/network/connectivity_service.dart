import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/constants/app_constants.dart';

// On non-web platforms we also import dart:io for InternetAddress.
import 'connectivity_service_io.dart'
    if (dart.library.html) 'connectivity_service_web.dart'
    as platform;

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

  /// Creates a new [ConnectivityService] instance.
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  Stream<bool>? _debouncedStream;

  @override
  Future<bool> isOnline() async {
    try {
      // On web, connectivity_plus always reports "wifi" or "ethernet" even when
      // offline, so we skip the interface check and go straight to reachability.
      if (!kIsWeb) {
        final results = await _connectivity.checkConnectivity();
        final hasInterface = results.any((r) => r != ConnectivityResult.none);
        if (!hasInterface) return false;
      }
      return await _checkReachability();
    } catch (_) {
      return false;
    }
  }

  /// Performs a real reachability check.
  /// - On **web**: fires a HEAD request to the backend (avoids dart:io / CORS issues).
  /// - On **native**: delegates to platform-specific DNS lookup (InternetAddress.lookup).
  Future<bool> _checkReachability() async {
    if (kIsWeb) {
      return _checkWebReachability();
    }
    return platform.checkNativeReachability();
  }

  /// Web reachability: HEAD request to the API base URL with a short timeout.
  Future<bool> _checkWebReachability() async {
    try {
      final dio = Dio();
      final response = await dio
          .head<dynamic>(
            AppConstants.baseUrl,
            options: Options(
              sendTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
              validateStatus: (_) =>
                  true, // Accept any HTTP status, we just want a response
            ),
          )
          .timeout(const Duration(seconds: 6));
      // Any valid HTTP response means we are online (even 404/405 etc.)
      return response.statusCode != null;
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    _debouncedStream ??= _connectivity.onConnectivityChanged
        .asyncMap((results) async {
          if (!kIsWeb) {
            final hasInterface = results.any(
              (r) => r != ConnectivityResult.none,
            );
            if (!hasInterface) return false;
          }
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
