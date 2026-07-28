import 'package:flutter/material.dart';

/// Design system color constants and schemes for Splito.
/// Features a premium Indigo/Teal/Rose financial theme.
abstract class AppColors {
  // Light Theme Palette
  static const Color lightPrimary = Color(0xFF4F46E5); // Indigo-600
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFE0E7FF);
  static const Color lightOnPrimaryContainer = Color(0xFF312E81);

  static const Color lightSecondary = Color(0xFF0D9488); // Teal-600
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFCCFBF1);
  static const Color lightOnSecondaryContainer = Color(0xFF115E59);

  static const Color lightTertiary = Color(0xFFE11D48); // Rose-600
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xFFFFE4E6);
  static const Color lightOnTertiaryContainer = Color(0xFF881337);

  static const Color lightBackground = Color(
    0xFFF8FAFC,
  ); // Slate-50 (Scaffold background)
  static const Color lightSurface = Color(
    0xFFFFFFFF,
  ); // Pure white (Cards, Dialogs)
  static const Color lightOnSurface = Color(0xFF0F172A); // Slate-900
  static const Color lightSurfaceContainerHighest = Color(
    0xFFE2E8F0,
  ); // Slate-200 (Borders, divider)
  static const Color lightOnSurfaceVariant = Color(
    0xFF475569,
  ); // Slate-600 (Subtitles, labels)

  static const Color lightError = Color(0xFFDC2626); // Red-600
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFFEE2E2);
  static const Color lightOnErrorContainer = Color(0xFF7F1D1D);

  static const Color lightOutline = Color(0xFF94A3B8); // Slate-400

  // Dark Theme Palette
  static const Color darkPrimary = Color(0xFF6366F1); // Indigo-500
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkPrimaryContainer = Color(0xFF312E81); // Indigo-900
  static const Color darkOnPrimaryContainer = Color(0xFFE0E7FF);

  static const Color darkSecondary = Color(0xFF14B8A6); // Teal-500
  static const Color darkOnSecondary = Color(0xFF0F172A);
  static const Color darkSecondaryContainer = Color(0xFF115E59); // Teal-800
  static const Color darkOnSecondaryContainer = Color(0xFFCCFBF1);

  static const Color darkTertiary = Color(0xFFFB7185); // Rose-400
  static const Color darkOnTertiary = Color(0xFF4C0519);
  static const Color darkTertiaryContainer = Color(0xFF881337); // Rose-900
  static const Color darkOnTertiaryContainer = Color(0xFFFFE4E6);

  static const Color darkBackground = Color(
    0xFF090D16,
  ); // Deep dark (Scaffold background)
  static const Color darkSurface = Color(
    0xFF131B2E,
  ); // Dark slate (Cards, Dialogs)
  static const Color darkOnSurface = Color(0xFFF8FAFC); // Slate-50
  static const Color darkSurfaceContainerHighest = Color(
    0xFF1E293B,
  ); // Slate-800
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8); // Slate-400

  static const Color darkError = Color(0xFFEF4444); // Red-500
  static const Color darkOnError = Color(0xFFFFFFFF);
  static const Color darkErrorContainer = Color(0xFF7F1D1D);
  static const Color darkOnErrorContainer = Color(0xFFFEE2E2);

  static const Color darkOutline = Color(0xFF475569); // Slate-600

  // Material 3 Light Color Scheme
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: lightPrimary,
    onPrimary: lightOnPrimary,
    primaryContainer: lightPrimaryContainer,
    onPrimaryContainer: lightOnPrimaryContainer,
    secondary: lightSecondary,
    onSecondary: lightOnSecondary,
    secondaryContainer: lightSecondaryContainer,
    onSecondaryContainer: lightOnSecondaryContainer,
    tertiary: lightTertiary,
    onTertiary: lightOnTertiary,
    tertiaryContainer: lightTertiaryContainer,
    onTertiaryContainer: lightOnTertiaryContainer,
    error: lightError,
    onError: lightOnError,
    errorContainer: lightErrorContainer,
    onErrorContainer: lightOnErrorContainer,
    surface: lightBackground, // Scaffold background
    surfaceContainer: lightSurface, // Cards, containers
    onSurface: lightOnSurface,
    surfaceContainerHighest: lightSurfaceContainerHighest,
    onSurfaceVariant: lightOnSurfaceVariant,
    outline: lightOutline,
  );

  // Material 3 Dark Color Scheme
  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: darkPrimary,
    onPrimary: darkOnPrimary,
    primaryContainer: darkPrimaryContainer,
    onPrimaryContainer: darkOnPrimaryContainer,
    secondary: darkSecondary,
    onSecondary: darkOnSecondary,
    secondaryContainer: darkSecondaryContainer,
    onSecondaryContainer: darkOnSecondaryContainer,
    tertiary: darkTertiary,
    onTertiary: darkOnTertiary,
    tertiaryContainer: darkTertiaryContainer,
    onTertiaryContainer: darkOnTertiaryContainer,
    error: darkError,
    onError: darkOnError,
    errorContainer: darkErrorContainer,
    onErrorContainer: darkOnErrorContainer,
    surface: darkBackground, // Scaffold background
    surfaceContainer: darkSurface, // Cards, containers
    onSurface: darkOnSurface,
    surfaceContainerHighest: darkSurfaceContainerHighest,
    onSurfaceVariant: darkOnSurfaceVariant,
    outline: darkOutline,
  );
}
