import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract contract governing internet connectivity status checks.
abstract interface class IConnectivityChecker {
  /// Checks if the device is currently online.
  Future<bool> isOnline();
}

/// Connectivity checker implementing [IConnectivityChecker] using [InternetAddress] lookups.
class ConnectivityChecker implements IConnectivityChecker {
  const ConnectivityChecker();

  @override
  Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup(
        '8.8.8.8',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on OSError catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }
}

/// Provider exposing [IConnectivityChecker].
final connectivityCheckerProvider = Provider<IConnectivityChecker>((ref) {
  return const ConnectivityChecker();
});
