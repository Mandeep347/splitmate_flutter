import 'package:flutter/material.dart';

/// A circular avatar displaying the user's initials.
class MemberAvatar extends StatelessWidget {
  /// The user's name used to compute initials.
  final String name;

  /// The radius of the avatar container.
  final double radius;

  /// Optional override for the background color.
  final Color? backgroundColor;

  /// Optional override for the initials text color.
  final Color? textColor;

  /// Creates a const [MemberAvatar] instance.
  const MemberAvatar({
    super.key,
    required this.name,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
  });

  /// Computes uppercase initials from the member's name.
  String get _initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? theme.colorScheme.primaryContainer,
      child: Text(
        _initials,
        style: theme.textTheme.titleSmall?.copyWith(
          color: textColor ?? theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize:
              radius *
              0.8, // Dynamically size initials text based on avatar radius
        ),
      ),
    );
  }
}
