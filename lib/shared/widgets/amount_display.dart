import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A reusable widget to display formatted currency values.
class AmountDisplay extends StatelessWidget {
  /// The numeric amount value.
  final double amount;

  /// The ISO currency code (e.g., USD, INR).
  final String currency;

  /// Custom typography style.
  final TextStyle? style;

  /// Custom text color.
  final Color? color;

  /// Option to prepend positive values with a '+' sign.
  final bool showSign;

  /// Maximum lines to render before truncating.
  final int? maxLines;

  /// Text overflow handling algorithm.
  final TextOverflow? overflow;

  /// Creates a const [AmountDisplay] instance.
  const AmountDisplay({
    super.key,
    required this.amount,
    required this.currency,
    this.style,
    this.color,
    this.showSign = false,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  String _currencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'INR':
        return '₹';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return '$currencyCode ';
    }
  }

  @override
  Widget build(BuildContext context) {
    final symbol = _currencySymbol(currency);
    final formatter = NumberFormat('#,##0.00');
    var formatted = '$symbol${formatter.format(amount)}';

    if (showSign && amount > 0) {
      formatted = '+$formatted';
    }

    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium;

    return Text(
      formatted,
      maxLines: maxLines,
      overflow: overflow,
      style: baseStyle?.copyWith(
        color: color ?? baseStyle.color,
      ),
    );
  }
}
