import 'package:flutter/material.dart';

/// Extension on [ColorScheme] to provide semantic financial colours.
extension FinancialColors on ColorScheme {
  // WCAG AA requires 4.5:1 for normal text, 3:1 for large
  // Contrast ratio: (L1 + 0.05) / (L2 + 0.05)
  // where L = relative luminance

  /// Color indicating that the current user owes money (red, contrast > 4.5:1).
  Color get oweColor => brightness == Brightness.light
      ? const Color(0xFFDC2626)
      : const Color(0xFFF87171);

  /// Color indicating that someone owes the current user money (green, contrast > 4.5:1).
  Color get owedColor => brightness == Brightness.light
      ? const Color(0xFF15803D)
      : const Color(0xFF34D399);
}
