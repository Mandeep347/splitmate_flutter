import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:splito_flutter/core/network/connectivity_notifier.dart';
import 'package:splito_flutter/core/offline/data/services/sync_service_impl.dart';
import 'package:splito_flutter/core/offline/domain/entities/offline_action.dart';
import 'package:splito_flutter/core/offline/presentation/providers/offline_queue_providers.dart';

/// Screen allowing users and developers to inspect offline queue state and force sync.
class SyncStatusPage extends ConsumerStatefulWidget {
  const SyncStatusPage({super.key});

  @override
  ConsumerState<SyncStatusPage> createState() => _SyncStatusPageState();
}

class _SyncStatusPageState extends ConsumerState<SyncStatusPage> {
  bool _isSyncing = false;
  List<OfflineAction> _pendingActions = [];
  bool _isLoadingList = true;

  @override
  void initState() {
    super.initState();
    _loadPendingActions();
  }

  Future<void> _loadPendingActions() async {
    setState(() => _isLoadingList = true);
    try {
      final queue = ref.read(offlineQueueRepositoryProvider);
      final actions = await queue.getPending();
      if (mounted) {
        setState(() {
          _pendingActions = actions;
          _isLoadingList = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingList = false);
      }
    }
  }

  Future<void> _triggerSync() async {
    setState(() => _isSyncing = true);
    try {
      final syncService = ref.read(syncServiceProvider);
      final result = await syncService.sync();

      ref.invalidate(pendingCountProvider);
      await _loadPendingActions();

      if (mounted) {
        final message = result.allSucceeded
            ? 'Synced ${result.succeeded} ${result.succeeded == 1 ? 'action' : 'actions'} successfully!'
            : 'Sync completed: ${result.succeeded} succeeded, ${result.failed} failed, ${result.exhausted} exhausted.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _clearCompleted() async {
    try {
      final queue = ref.read(offlineQueueRepositoryProvider);
      await queue.clearCompleted();
      ref.invalidate(pendingCountProvider);
      await _loadPendingActions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Completed logs cleared.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to clear logs: $e')),
        );
      }
    }
  }

  String _formatActionType(OfflineAction action) {
    return switch (action) {
      final CreateExpenseAction a => 'Create Expense ("${a.title}")',
      final CreateSettlementAction a => 'Record Settlement (${a.currency} ${a.amount.toStringAsFixed(2)})',
      final AddMemberAction a => 'Add Member (${a.email})',
    };
  }

  IconData _getActionIcon(OfflineAction action) {
    return switch (action) {
      CreateExpenseAction() => Icons.receipt_long_outlined,
      CreateSettlementAction() => Icons.handshake_outlined,
      AddMemberAction() => Icons.person_add_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOnline = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Sync Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_outlined),
            tooltip: 'Clear Completed Logs',
            onPressed: _clearCompleted,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Queue',
            onPressed: _loadPendingActions,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: RefreshIndicator(
        onRefresh: _loadPendingActions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Connection Status Card
              Card(
                elevation: 0,
                color: isOnline
                    ? const Color(0xFF10B981).withValues(alpha: 0.12)
                    : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isOnline
                        ? const Color(0xFF10B981).withValues(alpha: 0.4)
                        : const Color(0xFFF59E0B).withValues(alpha: 0.4),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isOnline
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isOnline ? 'Online Connection Restored' : 'Device is Offline',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isOnline
                                    ? const Color(0xFF047857)
                                    : const Color(0xFFB45309),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isOnline
                                  ? 'Queued actions will automatically sync in the background.'
                                  : 'Actions queued now will sync once network returns.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action Summary & Sync Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pending Actions (${_pendingActions.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: (isOnline && !_isSyncing && _pendingActions.isNotEmpty)
                        ? _triggerSync
                        : null,
                    icon: _isSyncing
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.sync_rounded, size: 18),
                    label: Text(_isSyncing ? 'Syncing...' : 'Sync Now'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Queue List Items
              if (_isLoadingList)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_pendingActions.isEmpty)
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.check_circle_outline_rounded,
                              size: 40, color: Color(0xFF10B981)),
                          SizedBox(height: 12),
                          Text(
                            'All Actions Synced',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'No pending mutations in the local offline queue.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pendingActions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final action = _pendingActions[index];
                    final dateStr = DateFormat('MMM d, h:mm a').format(action.createdAt);

                    return Card(
                      elevation: 0,
                      color: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getActionIcon(action),
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          _formatActionType(action),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Queued: $dateStr · Retries: ${action.retryCount}/${action.maxRetries}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Pending',
                            style: TextStyle(
                              color: Color(0xFFD97706),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      ),
      ),
    );
  }
}
