import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/responsive/responsive_layout.dart';
import 'package:splito_flutter/core/router/app_router.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/core/config/app_branding.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/auth/domain/entities/logged_in_user.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/shared/widgets/notification_bell.dart';
import 'package:splito_flutter/shared/widgets/pending_sync_banner.dart';

/// Redesigned navigation shell that dynamically switches between
/// a premium left sidebar on desktop and a bottom navigation bar on mobile/tablet.
class ResponsiveNavigationShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ResponsiveNavigationShell({super.key, required this.navigationShell});

  // Map bottom navigation index to StatefulNavigationShell branch index
  int _bottomNavIndexToBranch(int index) {
    switch (index) {
      case 0:
        return 0; // Dashboard
      case 1:
        return 1; // Groups
      case 2:
        return 1; // FAB - dummy, handled custom
      case 3:
        return 3; // Activity
      case 4:
        return 5; // Profile
      default:
        return 0;
    }
  }

  // Map GoRouter branch index to bottom navigation index
  int _branchToBottomNavIndex(int branchIndex) {
    switch (branchIndex) {
      case 0:
        return 0; // Dashboard
      case 1:
        return 1; // Groups
      case 2:
        return 1; // Expenses -> fallback to Groups tab
      case 3:
        return 3; // Activity
      case 4:
        return 0; // Statistics -> fallback to Dashboard
      case 5:
        return 4; // Profile
      default:
        return 0;
    }
  }

  GlobalKey<NavigatorState> _navigatorKeyForIndex(int index) {
    return switch (index) {
      0 => dashboardTabNavigatorKey,
      1 => groupsTabNavigatorKey,
      2 => expensesTabNavigatorKey,
      3 => activityTabNavigatorKey,
      4 => statisticsTabNavigatorKey,
      5 => profileTabNavigatorKey,
      _ => dashboardTabNavigatorKey,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      // Wrap in PopScope so the system back gesture doesn't exit the app
      // during the transient auth-loading period (startup or post-logout).
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          // During loading there is no meaningful branch to switch to; exit.
          SystemNavigator.pop();
        },
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }

    final shellBody = isDesktop
        ? _DesktopShell(navigationShell: navigationShell, user: user)
        : _MobileShell(
            navigationShell: navigationShell,
            currentIndex: _branchToBottomNavIndex(navigationShell.currentIndex),
            onTabSelected: (index) {
              if (index == 2) {
                _showAddExpenseGroupSelector(context, ref);
              } else {
                navigationShell.goBranch(
                  _bottomNavIndexToBranch(index),
                  initialLocation:
                      _bottomNavIndexToBranch(index) ==
                      navigationShell.currentIndex,
                );
              }
            },
          );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final shell = navigationShell;
        if (shell.currentIndex != 0) {
          // Not on the home tab — go to dashboard first.
          shell.goBranch(0, initialLocation: true);
          return;
        }
        // On dashboard — pop if there's a child page, otherwise exit.
        final navigatorKey = _navigatorKeyForIndex(0);
        if (navigatorKey.currentState?.canPop() == true) {
          navigatorKey.currentState?.pop();
        } else {
          SystemNavigator.pop();
        }
      },
      child: shellBody,
    );
  }

  void _showAddExpenseGroupSelector(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final groupsAsync = ref.read(myGroupsProvider);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ext.radiusLG)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(ext.spaceLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Expense',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Select a group to split an expense in:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: ext.spaceMD),
              groupsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) =>
                    const Center(child: Text('Error loading groups')),
                data: (groups) {
                  final activeGroups = groups.where((g) => g.isActive).toList();
                  if (activeGroups.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: Text(
                          'No active groups found. Create one first!',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    );
                  }
                  return Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: activeGroups.length,
                      itemBuilder: (context, index) {
                        final g = activeGroups[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Text(
                              g.name.isNotEmpty ? g.name[0].toUpperCase() : 'G',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          title: Text(g.name),
                          subtitle: Text('${g.membersCount} members'),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            context.goNamed(
                              AppRoutes.createExpenseName,
                              pathParameters: {'groupId': g.id},
                              extra: {
                                'groupName': g.name,
                                'currency': g.defaultCurrency,
                                'members': g.members,
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: ext.spaceMD),
            ],
          ),
        );
      },
    );
  }
}

/// Mobile Layout Shell
class _MobileShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const _MobileShell({
    required this.navigationShell,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PendingSyncBanner(),
          NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onTabSelected,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.group_outlined),
                selectedIcon: Icon(Icons.group_rounded),
                label: 'Groups',
              ),
              // Placeholder for FAB
              NavigationDestination(
                icon: Icon(Icons.add_circle_outline_rounded),
                selectedIcon: Icon(Icons.add_circle_rounded),
                label: 'Add',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history_rounded),
                label: 'Activity',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Desktop Sidebar + Top Header Shell
class _DesktopShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final LoggedInUser user;

  const _DesktopShell({required this.navigationShell, required this.user});

  String _getBranchTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Groups';
      case 2:
        return 'Expenses';
      case 3:
        return 'Activity';
      case 4:
        return 'Statistics';
      case 5:
        return 'Profile';
      default:
        return AppBranding.name;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            color: theme.colorScheme.surfaceContainer,
            child: Column(
              children: [
                // Header / Logo
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ext.spaceXL,
                    vertical: ext.spaceXL,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ext.spaceSM),
                        decoration: BoxDecoration(
                          gradient: ext.primaryGradient,
                          borderRadius: BorderRadius.circular(ext.radiusSM),
                        ),
                        child: const Icon(
                          Icons.grain_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: ext.spaceMD),
                      Text(
                        AppBranding.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Navigation items
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: ext.spaceMD),
                    children: [
                      _SidebarItem(
                        icon: Icons.dashboard_outlined,
                        selectedIcon: Icons.dashboard_rounded,
                        label: 'Dashboard',
                        selected: navigationShell.currentIndex == 0,
                        onTap: () => navigationShell.goBranch(0),
                      ),
                      _SidebarItem(
                        icon: Icons.group_outlined,
                        selectedIcon: Icons.group_rounded,
                        label: 'Groups',
                        selected: navigationShell.currentIndex == 1,
                        onTap: () => navigationShell.goBranch(1),
                      ),
                      _SidebarItem(
                        icon: Icons.receipt_long_outlined,
                        selectedIcon: Icons.receipt_long_rounded,
                        label: 'Expenses',
                        selected: navigationShell.currentIndex == 2,
                        onTap: () => navigationShell.goBranch(2),
                      ),
                      _SidebarItem(
                        icon: Icons.history_outlined,
                        selectedIcon: Icons.history_rounded,
                        label: 'Activity',
                        selected: navigationShell.currentIndex == 3,
                        onTap: () => navigationShell.goBranch(3),
                      ),
                      _SidebarItem(
                        icon: Icons.swap_horiz_rounded,
                        selectedIcon: Icons.swap_horiz_rounded,
                        label: 'Settle Up',
                        selected: false,
                        onTap: () => _showSettleUpSelector(context, ref),
                      ),
                      _SidebarItem(
                        icon: Icons.bar_chart_outlined,
                        selectedIcon: Icons.bar_chart_rounded,
                        label: 'Statistics',
                        selected: navigationShell.currentIndex == 4,
                        onTap: () => navigationShell.goBranch(4),
                      ),
                      const Divider(),
                      _SidebarItem(
                        icon: Icons.settings_outlined,
                        selectedIcon: Icons.settings_rounded,
                        label: 'Settings',
                        selected: false,
                        onTap: () => context.goNamed(AppRoutes.settingsName),
                      ),
                    ],
                  ),
                ),
                // User Profile Drawer at Bottom
                Padding(
                  padding: EdgeInsets.all(ext.spaceLG),
                  child: InkWell(
                    onTap: () => navigationShell.goBranch(5),
                    borderRadius: BorderRadius.circular(ext.radiusMD),
                    child: Container(
                      padding: EdgeInsets.all(ext.spaceSM),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(ext.radiusMD),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Text(
                              user.initials,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(width: ext.spaceSM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  user.email,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          // Main Body
          Expanded(
            child: Column(
              children: [
                // Top AppBar
                Container(
                  height: 70,
                  color: theme.colorScheme.surface,
                  padding: EdgeInsets.symmetric(horizontal: ext.spaceXL),
                  child: Row(
                    children: [
                      Text(
                        _getBranchTitle(navigationShell.currentIndex),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      // Add Expense Button
                      ElevatedButton.icon(
                        onPressed: () => _showAddExpenseSelector(context, ref),
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('Add Expense'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: ext.spaceLG,
                            vertical: ext.spaceMD,
                          ),
                        ),
                      ),
                      SizedBox(width: ext.spaceMD),
                      // Notification Bell
                      const NotificationBell(),
                      SizedBox(width: ext.spaceMD),
                      // Profile Avatar Icon
                      InkWell(
                        onTap: () => navigationShell.goBranch(5),
                        borderRadius: BorderRadius.circular(ext.radiusRound),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(
                            user.initials,
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                // Nested view
                Expanded(child: navigationShell),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseSelector(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.read(myGroupsProvider);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Expense'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select a group to split an expense in:'),
                const SizedBox(height: 16),
                groupsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Error loading groups'),
                  data: (groups) {
                    final activeGroups = groups
                        .where((g) => g.isActive)
                        .toList();
                    if (activeGroups.isEmpty) {
                      return const Center(
                        child: Text('No active groups found.'),
                      );
                    }
                    return Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: activeGroups.length,
                        itemBuilder: (context, index) {
                          final g = activeGroups[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                g.name.isNotEmpty
                                    ? g.name[0].toUpperCase()
                                    : 'G',
                              ),
                            ),
                            title: Text(g.name),
                            subtitle: Text('${g.membersCount} members'),
                            onTap: () {
                              Navigator.pop(context);
                              context.goNamed(
                                AppRoutes.createExpenseName,
                                pathParameters: {'groupId': g.id},
                                extra: {
                                  'groupName': g.name,
                                  'currency': g.defaultCurrency,
                                  'members': g.members,
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showSettleUpSelector(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.read(myGroupsProvider);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Settle Up'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select a group to record a settlement payment:'),
                const SizedBox(height: 16),
                groupsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Error loading groups'),
                  data: (groups) {
                    final activeGroups = groups
                        .where((g) => g.isActive)
                        .toList();
                    if (activeGroups.isEmpty) {
                      return const Center(
                        child: Text('No active groups found.'),
                      );
                    }
                    return Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: activeGroups.length,
                        itemBuilder: (context, index) {
                          final g = activeGroups[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                g.name.isNotEmpty
                                    ? g.name[0].toUpperCase()
                                    : 'G',
                              ),
                            ),
                            title: Text(g.name),
                            subtitle: Text('${g.membersCount} members'),
                            onTap: () {
                              Navigator.pop(context);
                              context.goNamed(
                                AppRoutes.createSettlementName,
                                pathParameters: {'groupId': g.id},
                                extra: {
                                  'groupName': g.name,
                                  'currency': g.defaultCurrency,
                                  'members': g.members,
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

/// Sidebar Item Navigation Tile
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Container(
      margin: EdgeInsets.symmetric(vertical: ext.spaceXXS),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ext.radiusMD),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ext.spaceMD,
            vertical: ext.spaceMD,
          ),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(ext.radiusMD),
          ),
          child: Row(
            children: [
              Icon(
                selected ? selectedIcon : icon,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              SizedBox(width: ext.spaceMD),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
