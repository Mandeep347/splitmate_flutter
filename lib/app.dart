import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/router/app_router.dart';
import 'package:splito_flutter/core/deep_links/deep_link_service.dart';
import 'package:splito_flutter/core/theme/custom_theme.dart';
import 'package:splito_flutter/core/theme/theme_provider.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/notifications/presentation/providers/notification_providers.dart';
import 'package:splito_flutter/features/settings/presentation/providers/settings_providers.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/features/expenses/presentation/providers/expense_providers.dart';
import 'package:splito_flutter/features/balances/presentation/providers/balance_providers.dart';
import 'package:splito_flutter/core/network/connectivity_notifier.dart';
import 'package:splito_flutter/core/offline/data/services/sync_service_impl.dart';
import 'package:splito_flutter/core/notifications/local_notification_service.dart';
import 'package:splito_flutter/shared/widgets/connectivity_banner.dart';
import 'package:splito_flutter/shared/widgets/download_app_banner.dart';

import 'package:splito_flutter/core/config/app_branding.dart';

/// The root layout widget of the Splito application.
/// Inherits [ConsumerStatefulWidget] to watch navigation configurations,
/// active theme states, and monitor application lifecycle events.
class SplitoApp extends ConsumerStatefulWidget {
  /// Creates a const [SplitoApp] instance.
  const SplitoApp({super.key});

  @override
  ConsumerState<SplitoApp> createState() => _SplitoAppState();
}

class _SplitoAppState extends ConsumerState<SplitoApp> {
  late final AppLifecycleListener _lifecycleListener;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onResume: _onAppResume,
      onPause: _onAppPause,
    );
    _startPolling();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final router = ref.read(goRouterProvider);
      ref.read(deepLinkServiceProvider).initialize(router);
      ref.read(localNotificationServiceProvider).initialize();
    });
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _refreshData();
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void _onAppResume() {
    _startPolling();
    _refreshData();

    if (ref.read(isOnlineProvider)) {
      ref.read(syncServiceProvider).sync().then((result) {
        if (result.succeeded > 0) {
          ref.invalidate(myGroupsProvider);
          ref.invalidate(myOverallBalancesProvider);
        }
      });
    }
  }

  void _onAppPause() {
    _stopPolling();
  }

  void _refreshData() {
    if (ref.read(authStateProvider)) {
      // Refresh core global providers
      ref.read(unreadCountProvider.notifier).refresh();
      ref.read(notificationsProvider.notifier).refresh();
      ref.read(myGroupsProvider.notifier).refresh();
      ref.read(myOverallBalancesProvider.notifier).refresh();

      // Trigger system tray notifications outside app for unread items
      ref
          .read(notificationsProvider.future)
          .then((notifications) {
            final localNotifService = ref.read(
              localNotificationServiceProvider,
            );
            for (final notif in notifications) {
              if (!notif.isRead) {
                localNotifService.notifyIfNew(
                  notificationId: notif.id,
                  title: notif.title ?? 'New Update',
                  body: notif.message ?? '',
                );
              }
            }
          })
          .catchError((_) {});

      // Dynamically detect if we are on a group details or nested group page,
      // and refresh providers for that group.
      try {
        final router = ref.read(goRouterProvider);
        final pathParams =
            router.routerDelegate.currentConfiguration.pathParameters;
        final groupId = pathParams['groupId'];
        if (groupId != null && groupId.isNotEmpty) {
          ref.invalidate(groupDetailProvider(groupId));
          ref.invalidate(groupExpensesProvider(groupId));
          ref.invalidate(groupBalancesProvider(groupId));
          ref.invalidate(groupMembersProvider(groupId));
        }
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _stopPolling();
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeSyncProvider);
    final router = ref.watch(goRouterProvider);
    final selectedThemeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppBranding.name,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: selectedThemeMode,
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            const ConnectivityBanner(),
            const DownloadAppBanner(),
          ],
        );
      },
    );
  }
}
