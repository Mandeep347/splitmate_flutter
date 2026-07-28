/// Web stub — native reachability via dart:io is not available on web.
/// The [ConnectivityService] class handles web reachability directly via
/// an HTTP HEAD request, so this function should never be called on web.
Future<bool> checkNativeReachability() async {
  // Should not be called on web; web path is handled in connectivity_service.dart.
  return true;
}
