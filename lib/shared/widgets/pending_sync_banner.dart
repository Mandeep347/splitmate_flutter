import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/network/connectivity_notifier.dart';
import 'package:splito_flutter/core/offline/presentation/providers/offline_queue_providers.dart';

/// Modern floating capsule banner displaying pending offline actions count and sync status.
/// Rendered directly above the bottom navigation bar and automatically hides when sync completes.
class PendingSyncBanner extends ConsumerWidget {
  const PendingSyncBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPending = ref.watch(hasPendingActionsProvider);
    final countAsync = ref.watch(pendingCountProvider);
    final isOnline = ref.watch(isOnlineProvider);

    if (!hasPending) {
      return const SizedBox.shrink();
    }

    final count = countAsync.valueOrNull ?? 0;
    if (count <= 0) return const SizedBox.shrink();

    final isSyncing = isOnline;

    final bannerBg = isSyncing
        ? const Color(0xFF1E293B) // Dark Slate
        : const Color(0xFFD97706); // Warm Amber

    final accentColor = isSyncing
        ? const Color(0xFF60A5FA) // Light Blue Accent
        : const Color(0xFFFDE68A); // Light Amber Accent

    final icon = isSyncing
        ? Icons.sync_rounded
        : Icons.cloud_off_rounded;

    final text = isSyncing
        ? 'Syncing $count ${count == 1 ? 'action' : 'actions'}...'
        : '$count ${count == 1 ? 'action' : 'actions'} pending sync';

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: bannerBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: accentColor, size: 14),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
