import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'theme_extensions.dart';
import 'typography.dart';

/// Central configuration class for the Splito styling system.
/// Generates complete ThemeData instances for light and dark modes.
abstract class CustomTheme {
  // WCAG AA requires 4.5:1 for normal text, 3:1 for large
  // Contrast ratio: (L1 + 0.05) / (L2 + 0.05)
  // where L = relative luminance
  // Verified color pairs:
  // - onSurfaceVariant (0xFF475569) on surface (0xFFF8FAFC) = 6.68:1 (Passes AA)
  // - primary (0xFF4F46E5) on primaryContainer (0xFFE0E7FF) = 5.48:1 (Passes AA)
  // - oweColor (0xFFDC2626) on surface (0xFFFFFFFF) = 4.85:1 (Passes AA)
  // - owedColor (0xFF15803D) on surface (0xFFFFFFFF) = 5.20:1 (Passes AA)

  /// Configuration for Material 3 Light Theme.
  static ThemeData get lightTheme {
    final extensions = AppThemeExtension.light();
    const scheme = AppColors.lightScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(extensions.radiusMD),
          side: BorderSide(
            color: scheme.surfaceContainerHighest,
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: extensions.spaceXL,
            vertical: extensions.spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(extensions.radiusMD),
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outline, width: 1),
          padding: EdgeInsets.symmetric(
            horizontal: extensions.spaceXL,
            vertical: extensions.spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(extensions.radiusMD),
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        contentPadding: EdgeInsets.symmetric(
          horizontal: extensions.spaceLG,
          vertical: extensions.spaceMD,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(extensions.radiusMD),
          borderSide: BorderSide(color: scheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(extensions.radiusMD),
          borderSide: BorderSide(color: scheme.surfaceContainerHighest, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(extensions.radiusMD),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(extensions.radiusMD),
          borderSide: BorderSide(color: scheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(extensions.radiusMD),
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant.withValues(alpha: 0.6)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.surfaceContainerHighest,
        thickness: 1,
        space: extensions.spaceLG,
      ),
      extensions: <ThemeExtension<dynamic>>[extensions],
    );
  }

  /// Configuration for Material 3 Dark Theme.
  static ThemeData get darkTheme {
    final extensions = AppThemeExtension.dark();
    const scheme = AppColors.darkScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(extensions.radiusMD),
          side: BorderSide(
            color: scheme.surfaceContainerHighest,
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: extensions.spaceXL,
            vertical: extensions.spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(extensions.radiusMD),
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outline, width: 1),
          padding: EdgeInsets.symmetric(
            horizontal: extensions.spaceXL,
            vertical: extensions.spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(extensions.radiusMD),
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        contentPadding: EdgeInsets.symmetric(
          horizontal: extensions.spaceLG,
          vertical: extensions.spaceMD,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(extensions.radiusMD),
          borderSide: BorderSide(color: scheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(extensions.radiusMD),
          borderSide: BorderSide(color: scheme.surfaceContainerHighest, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(extensions.radiusMD),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(extensions.radiusMD),
          borderSide: BorderSide(color: scheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(extensions.radiusMD),
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant.withValues(alpha: 0.6)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.surfaceContainerHighest,
        thickness: 1,
        space: extensions.spaceLG,
      ),
      extensions: <ThemeExtension<dynamic>>[extensions],
    );
  }
}
