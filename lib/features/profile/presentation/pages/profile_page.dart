import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/settings/presentation/providers/settings_providers.dart';
import 'package:splito_flutter/shared/widgets/confirmation_dialog.dart';
import 'package:splito_flutter/shared/widgets/info_row.dart';
import 'package:splito_flutter/shared/widgets/notification_bell.dart';
import '../widgets/edit_profile_sheet.dart';

/// Screen displaying user profile dashboard, local app preferences, and session controls.
class ProfilePage extends ConsumerWidget {
  /// Creates a const [ProfilePage] instance.
  const ProfilePage({super.key});

  static const List<String> _currencies = [
    'INR',
    'USD',
    'EUR',
    'GBP',
    'SGD',
    'AED',
    'JPY',
    'CAD',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    // Bug 4 fix: use ref.watch so profile rebuilds when auth completes.
    final user = ref.watch(currentUserProvider);
    final settingsState = ref.watch(settingsProvider);

    // Bug 4 fix: show spinner while user is loading — never return empty body.
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_rounded),
            tooltip: 'Offline Sync Status',
            onPressed: () => context.pushNamed(AppRoutes.syncStatusName),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            // Bug 6 fix: push settings so back navigation works.
            onPressed: () => context.pushNamed(AppRoutes.settingsName),
          ),
          const NotificationBell(),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Section 1: Avatar + Name Header
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    user.initials,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => EditProfileSheet.show(context, ref, user),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 2: Account Info Card
          Card(
            elevation: 0,
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(ext.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InfoRow(
                    icon: Icons.currency_rupee_rounded,
                    label: 'Preferred Currency',
                    value: user.preferredCurrency,
                  ),
                  Divider(height: ext.spaceLG),
                  InfoRow(
                    icon: Icons.verified_user_outlined,
                    label: 'Account Status',
                    value: 'Active',
                    valueColor: Colors.green.shade600,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section 3: App Settings Card
          // Bug 4 fix: render section header and user info regardless of settings
          // load state; only gate the settings-specific widgets.
          Text(
            'Preferences',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(ext.spaceMD),
              child: settingsState.when(
                loading: () => Column(
                  children: [
                    _buildSkeleton(ext, theme),
                    Divider(height: ext.spaceLG),
                    _buildSkeleton(ext, theme),
                    Divider(height: ext.spaceLG),
                    _buildSkeleton(ext, theme),
                    Divider(height: ext.spaceLG),
                    _buildSkeleton(ext, theme),
                  ],
                ),
                error: (_, __) => const SizedBox.shrink(),
                data: (settings) => Column(
                  children: [
                    // Theme Selector
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<String>(
                            showSelectedIcon: false,
                            segments: const [
                              ButtonSegment(
                                value: 'system',
                                label: Text('System'),
                                icon: Icon(Icons.brightness_auto_outlined, size: 16),
                              ),
                              ButtonSegment(
                                value: 'light',
                                label: Text('Light'),
                                icon: Icon(Icons.light_mode_outlined, size: 16),
                              ),
                              ButtonSegment(
                                value: 'dark',
                                label: Text('Dark'),
                                icon: Icon(Icons.dark_mode_outlined, size: 16),
                              ),
                            ],
                            selected: {settings.themeMode},
                            onSelectionChanged: (selected) {
                              ref.read(settingsProvider.notifier).updateThemeMode(selected.first);
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(height: ext.spaceLG),
                    // Notifications
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Notifications'),
                      subtitle: Text(
                        'Expense and settlement alerts',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      value: settings.notificationsEnabled,
                      onChanged: (v) {
                        ref.read(settingsProvider.notifier).updateNotifications(v);
                      },
                    ),
                    Divider(height: ext.spaceLG),
                    // Default Currency
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Default Currency'),
                      trailing: DropdownButton<String>(
                        value: settings.defaultCurrency,
                        underline: const SizedBox.shrink(),
                        items: _currencies.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) {
                            ref.read(settingsProvider.notifier).updateDefaultCurrency(v);
                          }
                        },
                      ),
                    ),
                    Divider(height: ext.spaceLG),
                    // Compact Expense List
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Compact Expense List'),
                      subtitle: Text(
                        'Show more expenses on screen',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      value: settings.compactExpenseList,
                      onChanged: (v) {
                        ref.read(settingsProvider.notifier).updateCompactList(v);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section 4: Danger Zone
          Text(
            'Danger Zone',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: theme.colorScheme.errorContainer.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Reset App Settings',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    final confirm = await ConfirmationDialog.show(
                      context,
                      title: 'Reset Settings',
                      message:
                          'This will reset all preferences to defaults. Your account and data are not affected.',
                      confirmLabel: 'Reset',
                      isDestructive: true,
                    );
                    if (confirm == true && context.mounted) {
                      final messenger = ScaffoldMessenger.of(context);
                      await ref.read(settingsProvider.notifier).resetToDefaults();
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Settings reset to defaults')),
                      );
                    }
                  },
                ),
                Divider(height: 1, color: theme.colorScheme.error.withValues(alpha: 0.1)),
                ListTile(
                  title: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Bug 5 fix: guard against null dialog result; use try/catch
                  // so the router redirect handles navigation automatically.
                  onTap: () async {
                    final confirmed = await ConfirmationDialog.show(
                      context,
                      title: 'Sign Out',
                      message: 'You will need to sign in again to access your groups.',
                      confirmLabel: 'Sign Out',
                      isDestructive: true,
                    );
                    if (confirmed != true) return;
                    try {
                      await ref.read(authNotifierProvider.notifier).logout();
                    } catch (_) {}
                  },
                ),
              ],
            ),
          ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSkeleton(AppThemeExtension ext, ThemeData theme) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
