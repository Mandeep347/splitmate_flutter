import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/core/theme/financial_colors.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/balances/presentation/providers/balance_providers.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/shared/widgets/balance_row.dart';
import 'package:splito_flutter/shared/widgets/settle_up_button.dart';
import 'package:splito_flutter/core/network/connectivity_notifier.dart';
import 'package:splito_flutter/shared/widgets/shimmer_wrapper.dart';
import 'package:splito_flutter/shared/widgets/skeletons/balance_row_skeleton.dart';

/// Screen displaying the detailed pairwise and simplified debts of a group.
class GroupBalancesPage extends ConsumerWidget {
  /// The unique identifier of the group.
  final String groupId;

  /// The name of the group.
  final String groupName;

  /// The default currency code.
  final String currency;

  /// Creates a const [GroupBalancesPage] instance.
  const GroupBalancesPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.currency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    final groupDetailAsync = ref.watch(groupDetailProvider(groupId));
    final groupBalancesAsync = ref.watch(groupBalancesProvider(groupId));
    final simplifiedBalancesAsync = ref.watch(simplifiedBalancesProvider(groupId));
    final isOnline = ref.watch(isOnlineProvider);

    final group = groupDetailAsync.valueOrNull;
    final members = group?.members ?? const [];

    Future<void> handleRefresh() async {
      ref.invalidate(groupBalancesProvider(groupId));
      ref.invalidate(simplifiedBalancesProvider(groupId));
      // Re-read future explicitly to satisfy pull-to-refresh indicators
      await ref.read(groupBalancesProvider(groupId).future);
      await ref.read(simplifiedBalancesProvider(groupId).future);
    }

    void navigateToCreateSettlement({String? fromUserId, String? toUserId}) {
      context.goNamed(
        AppRoutes.createSettlementName,
        pathParameters: {'groupId': groupId},
        extra: {
          'groupName': groupName,
          'currency': currency,
          'members': members,
          if (fromUserId != null) 'prefilledFromUserId': fromUserId,
          if (toUserId != null) 'prefilledToUserId': toUserId,
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(groupName),
            Text(
              'Balances',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(ext.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isOnline)
                Container(
                  margin: EdgeInsets.only(bottom: ext.spaceMD),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wifi_off_rounded, size: 14, color: Color(0xFFD97706)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Offline mode — Showing saved data (may not be latest)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD97706),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Section 1: Simplified Balances (How to Settle Up)
              Card(
                elevation: 0,
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(ext.spaceMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How to settle up',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Minimum payments to clear all debts',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: ext.spaceMD),
                      Builder(
                        builder: (context) {
                          final simplified = simplifiedBalancesAsync.hasValue ? simplifiedBalancesAsync.requireValue : null;
                          
                          if (simplified == null) {
                            if (simplifiedBalancesAsync.isLoading) {
                              return ShimmerWrapper(
                                isLoading: true,
                                child: Column(
                                  children: List.generate(
                                    3,
                                    (_) => const BalanceRowSkeleton(),
                                  ),
                                ),
                              );
                            }
                            if (!isOnline) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text('Connect to the internet to view balances.', textAlign: TextAlign.center),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(child: Text(simplifiedBalancesAsync.error.toString(), textAlign: TextAlign.center)),
                            );
                          }

                          if (simplified.isAllSettled) {
                            return Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: theme.colorScheme.owedColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'All settled up!',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            );
                          }

                          return Column(
                            children: simplified.transactions.map((balance) {
                              return BalanceRow(
                                balance: balance,
                                showSettleButton: true,
                                onSettle: () => navigateToCreateSettlement(
                                  fromUserId: balance.fromUserId,
                                  toUserId: balance.toUserId,
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ext.spaceMD),

              // Section 2: All Outstanding Balances
              Card(
                elevation: 0,
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(ext.spaceMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All outstanding balances',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Every pairwise debt in the group',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: ext.spaceMD),
                      Builder(
                        builder: (context) {
                          final groupBalances = groupBalancesAsync.hasValue ? groupBalancesAsync.requireValue : null;

                          if (groupBalances == null) {
                            if (groupBalancesAsync.isLoading) {
                              return ShimmerWrapper(
                                isLoading: true,
                                child: Column(
                                  children: List.generate(
                                    3,
                                    (_) => const BalanceRowSkeleton(),
                                  ),
                                ),
                              );
                            }
                            if (!isOnline) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text('Connect to the internet to view balances.', textAlign: TextAlign.center),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(child: Text(groupBalancesAsync.error.toString(), textAlign: TextAlign.center)),
                            );
                          }

                          if (groupBalances.isAllSettled) {
                            return Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: theme.colorScheme.owedColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'No outstanding balances.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            );
                          }

                          return Column(
                            children: groupBalances.balances.map((balance) {
                              return BalanceRow(
                                balance: balance,
                                showSettleButton: false,
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Bottom Settle Up button
              SettleUpButton(
                onPressed: (!isOnline || (groupBalancesAsync.valueOrNull?.isAllSettled ?? true))
                    ? null
                    : navigateToCreateSettlement,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
