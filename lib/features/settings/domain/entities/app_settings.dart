/// Represents user configuration preferences stored device-locally.
class AppSettings {
  /// Selected visual theme mode configuration ('system', 'light', or 'dark').
  final String themeMode;

  /// Whether app-level notifications are enabled.
  final bool notificationsEnabled;

  /// Default currency tag selected for creating new expenses.
  final String defaultCurrency;

  /// Whether expense listings should be displayed in a compact format.
  final bool compactExpenseList;

  /// Creates a new [AppSettings] instance.
  const AppSettings({
    required this.themeMode,
    required this.notificationsEnabled,
    required this.defaultCurrency,
    required this.compactExpenseList,
  });

  /// Factory providing default settings for a fresh installation.
  const factory AppSettings.defaults() = _DefaultAppSettings;

  /// Returns a new copy of [AppSettings] with updated properties.
  AppSettings copyWith({
    String? themeMode,
    bool? notificationsEnabled,
    String? defaultCurrency,
    bool? compactExpenseList,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      compactExpenseList: compactExpenseList ?? this.compactExpenseList,
    );
  }
}

class _DefaultAppSettings extends AppSettings {
  const _DefaultAppSettings()
    : super(
        themeMode: 'system',
        notificationsEnabled: true,
        defaultCurrency: 'INR',
        compactExpenseList: false,
      );
}
