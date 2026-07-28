import 'dart:io';

/// Native (Android/iOS/macOS/Windows/Linux) reachability check via DNS lookup.
Future<bool> checkNativeReachability() async {
  try {
    final result = await InternetAddress.lookup(
      '8.8.8.8',
    ).timeout(const Duration(seconds: 3));
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
