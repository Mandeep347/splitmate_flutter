import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A callback that the auth layer registers to handle session
/// expiry events triggered by the network layer.
///
/// When the [_AuthInterceptor] detects an unrecoverable 401
/// (refresh token also expired or missing), it calls this
/// callback so the auth state is reset without the network
/// layer needing to import anything from the auth feature.
typedef SessionExpiredCallback = void Function();

/// Holds the currently registered [SessionExpiredCallback].
///
/// The auth feature registers its callback once on app start.
/// The network interceptor reads and invokes it on session expiry.
/// Using a plain Riverpod [StateProvider] keeps this decoupled
/// from both layers — neither imports the other directly.
final sessionExpiredCallbackProvider = StateProvider<SessionExpiredCallback?>(
  (ref) => null,
);
