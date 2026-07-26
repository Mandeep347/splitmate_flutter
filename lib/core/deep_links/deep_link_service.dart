import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/router/route_names.dart';

/// Service managing incoming custom scheme deep links (`splito://`).
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  /// Initializes cold-start and warm-start link listeners with GoRouter.
  void initialize(GoRouter router) {
    // Handle cold start link
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleLink(uri, router);
      }
    });

    // Handle warm start links
    _sub = _appLinks.uriLinkStream.listen(
      (uri) => _handleLink(uri, router),
      onError: (Object err) {
        debugPrint('DeepLink error: $err');
      },
    );
  }

  void _handleLink(Uri uri, GoRouter router) {
    if (uri.scheme != 'splito') return;

    final host = uri.host;
    final path = uri.path;
    final token = uri.queryParameters['token'] ?? '';

    if (host == 'verify' || path == '/verify-email' || path == 'verify-email') {
      debugPrint('DeepLink matched verify with token: $token');
      router.go('${AppRoutes.verifyEmailPath}?token=$token');
    } else if (host == 'reset-password' || path == '/reset-password' || path == 'reset-password') {
      debugPrint('DeepLink matched reset-password with token: $token');
      router.go('${AppRoutes.resetPasswordPath}?token=$token');
    } else if (host == 'groups' || path.startsWith('/groups/') || path.startsWith('groups/')) {
      final String groupId;
      if (host == 'groups') {
        groupId = path.replaceFirst('/', '');
      } else {
        groupId = path.split('/groups/').last;
      }
      debugPrint('DeepLink matched group invite with groupId: $groupId');
      if (groupId.isNotEmpty) {
        router.go('/groups/$groupId');
      }
    } else {
      debugPrint('Unrecognised deep link ignored: $uri');
    }
  }

  /// Cancels stream subscription on disposal.
  void dispose() {
    _sub?.cancel();
  }
}

/// Provider exposing [DeepLinkService].
final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  final service = DeepLinkService();
  ref.onDispose(service.dispose);
  return service;
});
