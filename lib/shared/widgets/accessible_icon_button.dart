import 'package:flutter/material.dart';

/// Wrapper replacing raw IconButton where the icon alone is not self-describing.
/// Forces tooltip as a Semantics label for screen readers.
class AccessibleIconButton extends StatelessWidget {
  /// The icon widget to display.
  final Widget icon;

  /// Required accessibility tooltip and semantic description.
  final String tooltip;

  /// Callback executed when the icon button is tapped.
  final VoidCallback? onPressed;

  /// Optional icon color override.
  final Color? color;

  /// Optional icon size.
  final double? iconSize;

  /// Optional padding around the icon button.
  final EdgeInsetsGeometry? padding;

  /// Creates a new [AccessibleIconButton] instance.
  const AccessibleIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.color,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tooltip,
      button: true,
      enabled: onPressed != null,
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          icon: icon,
          tooltip: tooltip,
          onPressed: onPressed,
          color: color,
          iconSize: iconSize,
          padding: padding,
        ),
      ),
    );
  }
}
