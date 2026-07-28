import 'dart:ui';
import 'package:flutter/material.dart';

/// Custom style extensions for Splito design system.
/// Adds support for custom spacing, radii, shadows, and gradients.
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  // Spacing Tokens
  final double spaceXXS;
  final double spaceXS;
  final double spaceSM;
  final double spaceMD;
  final double spaceLG;
  final double spaceXL;
  final double spaceXXL;
  final double spaceXXXL;

  // Radius Tokens
  final double radiusXS;
  final double radiusSM;
  final double radiusMD;
  final double radiusLG;
  final double radiusXL;
  final double radiusRound;

  // Custom styling tokens
  final Gradient primaryGradient;
  final Color glassOverlay;
  final List<BoxShadow> cardShadow;

  const AppThemeExtension({
    required this.spaceXXS,
    required this.spaceXS,
    required this.spaceSM,
    required this.spaceMD,
    required this.spaceLG,
    required this.spaceXL,
    required this.spaceXXL,
    required this.spaceXXXL,
    required this.radiusXS,
    required this.radiusSM,
    required this.radiusMD,
    required this.radiusLG,
    required this.radiusXL,
    required this.radiusRound,
    required this.primaryGradient,
    required this.glassOverlay,
    required this.cardShadow,
  });

  /// Factory constructors for default configurations.
  factory AppThemeExtension.light() {
    return const AppThemeExtension(
      spaceXXS: 2.0,
      spaceXS: 4.0,
      spaceSM: 8.0,
      spaceMD: 12.0,
      spaceLG: 16.0,
      spaceXL: 24.0,
      spaceXXL: 32.0,
      spaceXXXL: 48.0,
      radiusXS: 4.0,
      radiusSM: 8.0,
      radiusMD: 12.0,
      radiusLG: 16.0,
      radiusXL: 24.0,
      radiusRound: 999.0,
      primaryGradient: LinearGradient(
        colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      glassOverlay: Color(0x0D000000), // Very light dark tint
      cardShadow: [
        BoxShadow(
          color: Color(0x0D0F172A), // Slate shadow
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  factory AppThemeExtension.dark() {
    return const AppThemeExtension(
      spaceXXS: 2.0,
      spaceXS: 4.0,
      spaceSM: 8.0,
      spaceMD: 12.0,
      spaceLG: 16.0,
      spaceXL: 24.0,
      spaceXXL: 32.0,
      spaceXXXL: 48.0,
      radiusXS: 4.0,
      radiusSM: 8.0,
      radiusMD: 12.0,
      radiusLG: 16.0,
      radiusXL: 24.0,
      radiusRound: 999.0,
      primaryGradient: LinearGradient(
        colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      glassOverlay: Color(0x1AFFFFFF), // Light white tint
      cardShadow: [
        BoxShadow(
          color: Color(0x33000000), // Heavy dark shadow
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    );
  }

  @override
  AppThemeExtension copyWith({
    double? spaceXXS,
    double? spaceXS,
    double? spaceSM,
    double? spaceMD,
    double? spaceLG,
    double? spaceXL,
    double? spaceXXL,
    double? spaceXXXL,
    double? radiusXS,
    double? radiusSM,
    double? radiusMD,
    double? radiusLG,
    double? radiusXL,
    double? radiusRound,
    Gradient? primaryGradient,
    Color? glassOverlay,
    List<BoxShadow>? cardShadow,
  }) {
    return AppThemeExtension(
      spaceXXS: spaceXXS ?? this.spaceXXS,
      spaceXS: spaceXS ?? this.spaceXS,
      spaceSM: spaceSM ?? this.spaceSM,
      spaceMD: spaceMD ?? this.spaceMD,
      spaceLG: spaceLG ?? this.spaceLG,
      spaceXL: spaceXL ?? this.spaceXL,
      spaceXXL: spaceXXL ?? this.spaceXXL,
      spaceXXXL: spaceXXXL ?? this.spaceXXXL,
      radiusXS: radiusXS ?? this.radiusXS,
      radiusSM: radiusSM ?? this.radiusSM,
      radiusMD: radiusMD ?? this.radiusMD,
      radiusLG: radiusLG ?? this.radiusLG,
      radiusXL: radiusXL ?? this.radiusXL,
      radiusRound: radiusRound ?? this.radiusRound,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      glassOverlay: glassOverlay ?? this.glassOverlay,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      spaceXXS: lerpDouble(spaceXXS, other.spaceXXS, t)!,
      spaceXS: lerpDouble(spaceXS, other.spaceXS, t)!,
      spaceSM: lerpDouble(spaceSM, other.spaceSM, t)!,
      spaceMD: lerpDouble(spaceMD, other.spaceMD, t)!,
      spaceLG: lerpDouble(spaceLG, other.spaceLG, t)!,
      spaceXL: lerpDouble(spaceXL, other.spaceXL, t)!,
      spaceXXL: lerpDouble(spaceXXL, other.spaceXXL, t)!,
      spaceXXXL: lerpDouble(spaceXXXL, other.spaceXXXL, t)!,
      radiusXS: lerpDouble(radiusXS, other.radiusXS, t)!,
      radiusSM: lerpDouble(radiusSM, other.radiusSM, t)!,
      radiusMD: lerpDouble(radiusMD, other.radiusMD, t)!,
      radiusLG: lerpDouble(radiusLG, other.radiusLG, t)!,
      radiusXL: lerpDouble(radiusXL, other.radiusXL, t)!,
      radiusRound: lerpDouble(radiusRound, other.radiusRound, t)!,
      primaryGradient: Gradient.lerp(
        primaryGradient,
        other.primaryGradient,
        t,
      )!,
      glassOverlay: Color.lerp(glassOverlay, other.glassOverlay, t)!,
      cardShadow: BoxShadow.lerpList(cardShadow, other.cardShadow, t)!,
    );
  }
}
