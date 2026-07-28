import 'package:flutter/material.dart';

/// Base custom styling CircleAvatar.
/// Handles network loading states, error fallbacks, and placeholder initials.
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final IconData placeholderIcon;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    required this.placeholderIcon,
    this.size = 40.0,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fallbackBgColor =
        backgroundColor ?? theme.colorScheme.primaryContainer;
    final fallbackTextColor = textColor ?? theme.colorScheme.onPrimaryContainer;

    Widget avatarContent = Icon(
      placeholderIcon,
      size: size * 0.5,
      color: fallbackTextColor,
    );

    // If initials are supplied, render them
    if (initials != null && initials!.isNotEmpty) {
      avatarContent = Text(
        initials!.toUpperCase(),
        style: TextStyle(
          color: fallbackTextColor,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.4,
        ),
      );
    }

    // If imageUrl is supplied, attempt rendering network image
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => CircleAvatar(
              backgroundColor: fallbackBgColor,
              child: avatarContent,
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return CircleAvatar(
                backgroundColor: fallbackBgColor,
                child: SizedBox(
                  width: size * 0.5,
                  height: size * 0.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: fallbackBgColor,
      child: avatarContent,
    );
  }
}

/// Specialized avatar styled for users.
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;

  const UserAvatar({super.key, this.imageUrl, this.name, this.size = 40.0});

  /// Parse initials (e.g. "John Doe" -> "JD").
  String? get _initials {
    if (name == null || name!.isEmpty) return null;
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return null;
    if (parts.length == 1) return parts[0].substring(0, 1);
    return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}';
  }

  @override
  Widget build(BuildContext context) {
    return AppAvatar(
      imageUrl: imageUrl,
      initials: _initials,
      placeholderIcon: Icons.person,
      size: size,
    );
  }
}

/// Specialized avatar styled for groups.
class GroupAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? groupName;
  final double size;

  const GroupAvatar({
    super.key,
    this.imageUrl,
    this.groupName,
    this.size = 40.0,
  });

  String? get _initials {
    if (groupName == null || groupName!.isEmpty) return null;
    final cleanName = groupName!.trim();
    if (cleanName.length > 2) return cleanName.substring(0, 2);
    return cleanName;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppAvatar(
      imageUrl: imageUrl,
      initials: _initials,
      placeholderIcon: Icons.group,
      size: size,
      backgroundColor: theme.colorScheme.secondaryContainer,
      textColor: theme.colorScheme.onSecondaryContainer,
    );
  }
}

/// Horizontal stack of overlapping user avatars.
class AvatarStack extends StatelessWidget {
  final List<UserAvatar> avatars;
  final double size;
  final double overlapOffset;
  final int maxVisible;

  const AvatarStack({
    super.key,
    required this.avatars,
    this.size = 32.0,
    this.overlapOffset = 12.0,
    this.maxVisible = 3,
  });

  @override
  Widget build(BuildContext context) {
    final visibleCount = avatars.length > maxVisible
        ? maxVisible
        : avatars.length;
    final extraCount = avatars.length - visibleCount;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: size,
          // Calculate overall stack width based on overlapping offsets
          width:
              visibleCount * (size - overlapOffset) +
              overlapOffset +
              (extraCount > 0 ? 32 : 0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < visibleCount; i++)
                Positioned(
                  left: i * (size - overlapOffset),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: avatars[i],
                  ),
                ),
              if (extraCount > 0)
                Positioned(
                  left: visibleCount * (size - overlapOffset),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+$extraCount',
                      style: TextStyle(
                        fontSize: size * 0.35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
