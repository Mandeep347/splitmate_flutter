import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/settings/domain/entities/app_settings.dart';
import 'package:splito_flutter/features/settings/presentation/providers/settings_providers.dart';
import 'package:splito_flutter/features/updates/update_notifier.dart';
import 'package:splito_flutter/shared/widgets/confirmation_dialog.dart';
import 'package:splito_flutter/core/utils/package_info_service.dart';

/// Full screen view containing advanced user configurations, danger zones, and app legal info.
class SettingsPage extends ConsumerWidget {
  /// Creates a const [SettingsPage] instance.
  const SettingsPage({super.key});

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
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: settingsState.when(
            loading: () => ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSkeletonCard(ext, theme),
                const SizedBox(height: 16),
                _buildSkeletonCard(ext, theme),
                const SizedBox(height: 16),
                _buildSkeletonCard(ext, theme),
              ],
            ),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: theme.colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      error is Failure ? error.message : error.toString(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        ref.read(settingsProvider.notifier).refresh();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            data: (settings) => ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Section 1: Appearance
                _buildSectionHeader(context, 'Appearance'),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Theme'),
                        subtitle: Text(
                          _getThemeDisplayName(settings.themeMode),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _showThemePicker(context, ref, settings),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('Compact expense list'),
                        subtitle: const Text('Show more expenses per screen'),
                        value: settings.compactExpenseList,
                        onChanged: (v) {
                          ref
                              .read(settingsProvider.notifier)
                              .updateCompactList(v);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section 2: Notifications
                _buildSectionHeader(context, 'Notifications'),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  child: SwitchListTile(
                    title: const Text('Push notifications'),
                    subtitle: const Text('Expense and settlement alerts'),
                    value: settings.notificationsEnabled,
                    onChanged: (v) {
                      ref
                          .read(settingsProvider.notifier)
                          .updateNotifications(v);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Section 3: Preferences
                _buildSectionHeader(context, 'Preferences'),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  child: ListTile(
                    title: const Text('Default Currency'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          settings.defaultCurrency,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                    onTap: () => _showCurrencyPicker(context, ref, settings),
                  ),
                ),
                const SizedBox(height: 24),

                // Section 4: About
                _buildSectionHeader(context, 'About'),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Version'),
                        trailing: Text(
                          PackageInfoService.fullVersion.isNotEmpty
                              ? PackageInfoService.fullVersion
                              : '1.0.0+1',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Privacy Policy'),
                        trailing: const Icon(
                          Icons.open_in_new_outlined,
                          size: 16,
                        ),
                        onTap: () {
                          context.push(AppRoutes.privacyPolicyPath);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Terms of Service'),
                        trailing: const Icon(
                          Icons.open_in_new_outlined,
                          size: 16,
                        ),
                        onTap: () {
                          context.push(AppRoutes.termsOfServicePath);
                        },
                      ),
                      // Check for Updates — Android only
                      if (!kIsWeb && Platform.isAndroid) ...[
                        const Divider(height: 1),
                        Consumer(
                          builder: (context, ref, _) {
                            final updateState =
                                ref.watch(updateNotifierProvider).valueOrNull ??
                                const UpdateState();
                            final bodySmall = theme.textTheme.bodySmall;
                            final colorScheme = theme.colorScheme;
                            return ListTile(
                              leading: const Icon(Icons.system_update_outlined),
                              title: const Text('Check for Updates'),
                              subtitle: switch (updateState.status) {
                                UpdateStatus.idle => null,
                                UpdateStatus.checking => Text(
                                  'Checking…',
                                  style: bodySmall,
                                ),
                                UpdateStatus.upToDate => Text(
                                  'You\'re up to date ✓',
                                  style: bodySmall?.copyWith(
                                    color: Colors.green,
                                  ),
                                ),
                                UpdateStatus.updateAvailable => Text(
                                  'Update available: '
                                  '${updateState.updateInfo?.latestVersion ?? ''}',
                                  style: bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              },
                              trailing: switch (updateState.status) {
                                UpdateStatus.checking => const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                UpdateStatus.updateAvailable => TextButton(
                                  onPressed: () => ref
                                      .read(updateNotifierProvider.notifier)
                                      .downloadUpdate(),
                                  child: const Text('Download'),
                                ),
                                _ => const Icon(Icons.chevron_right_rounded),
                              },
                              onTap:
                                  updateState.status == UpdateStatus.checking ||
                                      updateState.status ==
                                          UpdateStatus.updateAvailable
                                  ? null
                                  : () => ref
                                        .read(updateNotifierProvider.notifier)
                                        .checkForUpdate(),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section 5: Account
                _buildSectionHeader(context, 'Account'),
                Card(
                  elevation: 0,
                  color: theme.colorScheme.errorContainer.withValues(
                    alpha: 0.05,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: theme.colorScheme.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.refresh_outlined,
                          color: theme.colorScheme.error,
                        ),
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
                            await ref
                                .read(settingsProvider.notifier)
                                .resetToDefaults();
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Settings reset')),
                            );
                          }
                        },
                      ),
                      Divider(
                        height: 1,
                        color: theme.colorScheme.error.withValues(alpha: 0.1),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout_outlined,
                          color: theme.colorScheme.error,
                        ),
                        title: Text(
                          'Sign Out',
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Bug 5 fix: guard against null dialog result; router
                        // redirect handles navigation automatically after logout.
                        onTap: () async {
                          final confirmed = await ConfirmationDialog.show(
                            context,
                            title: 'Sign Out',
                            message:
                                'You will need to sign in again to access your groups.',
                            confirmLabel: 'Sign Out',
                            isDestructive: true,
                          );
                          if (confirmed != true) return;
                          try {
                            await ref
                                .read(authNotifierProvider.notifier)
                                .logout();
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
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSkeletonCard(AppThemeExtension ext, ThemeData theme) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  String _getThemeDisplayName(String themeMode) {
    switch (themeMode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'Follow system';
    }
  }

  void _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Choose Theme',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              RadioGroup<String>(
                groupValue: settings.themeMode,
                onChanged: (v) {
                  if (v != null) {
                    ref.read(settingsProvider.notifier).updateThemeMode(v);
                    Navigator.pop(context);
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      secondary: Icon(Icons.brightness_auto_outlined),
                      title: Text('Follow system'),
                      value: 'system',
                    ),
                    RadioListTile<String>(
                      secondary: Icon(Icons.light_mode_outlined),
                      title: Text('Light'),
                      value: 'light',
                    ),
                    RadioListTile<String>(
                      secondary: Icon(Icons.dark_mode_outlined),
                      title: Text('Dark'),
                      value: 'dark',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencyPicker(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        final theme = Theme.of(context);
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  'Default Currency',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _currencies.length,
                    itemBuilder: (context, index) {
                      final currency = _currencies[index];
                      final isSelected = settings.defaultCurrency == currency;
                      return ListTile(
                        title: Text(currency),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_rounded,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                        onTap: () {
                          ref
                              .read(settingsProvider.notifier)
                              .updateDefaultCurrency(currency);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
