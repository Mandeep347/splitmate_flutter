import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/groups/domain/entities/group.dart';
import 'package:intl/intl.dart';

/// Redesigned card displaying metadata and user-specific balance for a single group.
class GroupCard extends ConsumerStatefulWidget {
  final Group group;
  final bool compact;

  const GroupCard({
    super.key,
    required this.group,
    this.compact = false,
  });

  @override
  ConsumerState<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends ConsumerState<GroupCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    final firstLetter = widget.group.name.trim().isNotEmpty
        ? widget.group.name.trim()[0].toUpperCase()
        : 'G';

    // Group avatar gradient color
    final List<Color> avatarGradient = _getAvatarGradient(widget.group.name);

    return Semantics(
      label: '${widget.group.name}, ${widget.group.membersCount} members',
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(
          horizontal: ext.spaceSM,
          vertical: widget.compact ? ext.spaceXXS : ext.spaceXS,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(widget.compact ? 12 : 20),
          border: Border.all(
            color: _isHovered
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: _isHovered ? ext.cardShadow : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.compact ? 12 : 20),
          child: InkWell(
            onTap: () {
              context.goNamed(
                AppRoutes.groupDetailsName,
                pathParameters: {'groupId': widget.group.id},
              );
            },
            child: Padding(
              padding: EdgeInsets.all(widget.compact ? ext.spaceMD : ext.spaceLG),
              child: Row(
                children: [
                  // Group Avatar with Gradient
                  Container(
                    width: widget.compact ? 40 : 52,
                    height: widget.compact ? 40 : 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: avatarGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(widget.compact ? 12 : 16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      firstLetter,
                      style: (widget.compact
                              ? theme.textTheme.titleMedium
                              : theme.textTheme.titleLarge)
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: widget.compact ? ext.spaceSM : ext.spaceMD),
 
                  // Group details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.group.name,
                                style: (widget.compact
                                        ? theme.textTheme.titleSmall
                                        : theme.textTheme.titleMedium)
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.group.isArchived) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Archived',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onErrorContainer,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.group.membersCount} members · ${widget.group.defaultCurrency}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Created ${DateFormat.yMMMd().format(widget.group.createdAt)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                        // PERF: balance/analytics removed from card to prevent N+1 API calls. See GroupDetailsPage.
                      ],
                    ),
                  ),

                  // Trailing Action
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

  List<Color> _getAvatarGradient(String name) {
    final int hash = name.codeUnits.fold(0, (prev, element) => prev + element);
    final List<List<Color>> gradients = [
      [const Color(0xFF6366F1), const Color(0xFF818CF8)], // Indigo
      [const Color(0xFF14B8A6), const Color(0xFF34D399)], // Teal/Green
      [const Color(0xFFEC4899), const Color(0xFFF472B6)], // Pink
      [const Color(0xFFF59E0B), const Color(0xFFFBBF24)], // Amber
      [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)], // Violet
    ];
    return gradients[hash % gradients.length];
  }
}
