import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/groups/domain/entities/group.dart';
import 'package:splito_flutter/core/theme/financial_colors.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/balances/presentation/providers/balance_providers.dart';
import 'package:splito_flutter/features/analytics/presentation/providers/analytics_providers.dart';
import 'package:splito_flutter/shared/widgets/amount_display.dart';

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
    final currentUser = ref.watch(currentUserProvider);
    final totalSpent = ref.watch(groupTotalSpentProvider(widget.group.id));

    final firstLetter = widget.group.name.trim().isNotEmpty
        ? widget.group.name.trim()[0].toUpperCase()
        : 'G';

    // Group avatar gradient color
    final List<Color> avatarGradient = _getAvatarGradient(widget.group.name);

    return MouseRegion(
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
                        Text(
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
                        const SizedBox(height: 4),
                        Text(
                          '${widget.group.membersCount} members · ${widget.group.defaultCurrency}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Balance row
                        ref.watch(groupBalancesProvider(widget.group.id)).when(
                              loading: () => const SizedBox.shrink(),
                              error: (_, __) => const SizedBox.shrink(),
                              data: (groupBalances) {
                                if (groupBalances.isAllSettled) {
                                  return Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        size: 12,
                                        color: theme.colorScheme.owedColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'All settled',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.owedColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                // Calculate net balance for current user in this group
                                double userNetBalance = 0.0;
                                if (currentUser != null) {
                                  for (final b in groupBalances.balances) {
                                    if (b.fromUserId == currentUser.id) {
                                      userNetBalance -= b.amount;
                                    } else if (b.toUserId == currentUser.id) {
                                      userNetBalance += b.amount;
                                    }
                                  }
                                }

                                if (userNetBalance == 0.0) {
                                  return Text(
                                    'Settled in this group',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  );
                                }

                                final owedText = userNetBalance > 0 ? 'You will get' : 'You need to pay';
                                final balanceColor = userNetBalance > 0
                                    ? theme.colorScheme.owedColor
                                    : theme.colorScheme.oweColor;

                                return Row(
                                  children: [
                                    Text(
                                      '$owedText ',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    Flexible(
                                      child: AmountDisplay(
                                        amount: userNetBalance.abs(),
                                        currency: widget.group.defaultCurrency,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: balanceColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                      ],
                    ),
                  ),

                  // Trailing Info / Action
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (totalSpent > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${_currencySymbol(widget.group.defaultCurrency)}${totalSpent.toStringAsFixed(0)} total',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
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

  String _currencySymbol(String c) {
    switch (c) {
      case 'INR':
        return '₹';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return '$c ';
    }
  }
}
