import 'package:flutter/material.dart';

/// Icon widget representing the type of activity.
class ActivityIcon extends StatelessWidget {
  /// The key defining the activity type.
  final String iconKey;

  /// The size of the icon.
  final double size;

  /// Creates a new [ActivityIcon] instance.
  const ActivityIcon({required this.iconKey, this.size = 20, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    IconData iconData;

    if (iconKey.contains('EXPENSE_CREATED')) {
      iconData = Icons.receipt_long_outlined;
    } else if (iconKey.contains('EXPENSE_REVERSED')) {
      iconData = Icons.undo_rounded;
    } else if (iconKey.contains('SETTLEMENT')) {
      iconData = Icons.swap_horiz_rounded;
    } else if (iconKey.contains('MEMBER_ADDED')) {
      iconData = Icons.person_add_outlined;
    } else if (iconKey.contains('MEMBER_REMOVED')) {
      iconData = Icons.person_remove_outlined;
    } else if (iconKey.contains('GROUP')) {
      iconData = Icons.group_outlined;
    } else {
      iconData = Icons.history_outlined;
    }

    return Icon(iconData, size: size, color: theme.colorScheme.primary);
  }
}
