import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/offline/domain/entities/offline_action.dart';
import 'package:splito_flutter/core/offline/domain/repositories/i_offline_queue_repository.dart';
import 'package:splito_flutter/core/offline/domain/services/sync_service.dart';
import 'package:splito_flutter/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_split_input.dart';
import 'package:splito_flutter/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:splito_flutter/features/groups/data/repositories/group_repository_impl.dart';
import 'package:splito_flutter/features/groups/domain/repositories/i_group_repository.dart';
import 'package:splito_flutter/features/settlements/data/repositories/settlement_repository_impl.dart';
import 'package:splito_flutter/features/settlements/domain/repositories/i_settlement_repository.dart';

import 'package:splito_flutter/core/offline/presentation/providers/offline_queue_providers.dart';

/// Implementation of [ISyncService] processing queued offline actions upon connectivity restoration.
class SyncServiceImpl implements ISyncService {
  final IOfflineQueueRepository queue;
  final IExpenseRepository expenseRepository;
  final ISettlementRepository settlementRepository;
  final IGroupRepository groupRepository;
  final Ref? ref;

  final _progressController = StreamController<SyncProgress>.broadcast();
  bool _isSyncing = false;

  /// Creates a new [SyncServiceImpl] instance.
  SyncServiceImpl({
    required this.queue,
    required this.expenseRepository,
    required this.settlementRepository,
    required this.groupRepository,
    this.ref,
  });

  @override
  Stream<SyncProgress> get onProgress => _progressController.stream;

  @override
  Future<SyncResult> sync() async {
    if (_isSyncing) {
      return const SyncResult(0, 0, 0);
    }
    _isSyncing = true;
    try {
      final pending = await queue.getPending();
      if (pending.isEmpty) {
        ref?.invalidate(pendingCountProvider);
        return const SyncResult(0, 0, 0);
      }

      int succeeded = 0;
      int failed = 0;
      int exhausted = 0;
      final total = pending.length;

      for (int i = 0; i < pending.length; i++) {
        final action = pending[i];
        final actionTypeStr = _getActionTypeString(action);

        _progressController.add(
          SyncProgress(
            total: total,
            completed: i,
            currentActionType: actionTypeStr,
          ),
        );

        try {
          await _processAction(action);
          await queue.markCompleted(action.id);
          succeeded++;
          ref?.invalidate(pendingCountProvider);
        } catch (e) {
          if (action is AddMemberAction && _isConflictError(e)) {
            // 409 Conflict treated as success (member already added)
            await queue.markCompleted(action.id);
            succeeded++;
            ref?.invalidate(pendingCountProvider);
          } else {
            await queue.incrementRetry(action.id);
            final nextCount = action.retryCount + 1;
            if (nextCount >= action.maxRetries) {
              exhausted++;
            } else {
              failed++;
            }
            ref?.invalidate(pendingCountProvider);
          }
        }
      }

      _progressController.add(
        SyncProgress(total: total, completed: total, currentActionType: 'DONE'),
      );

      ref?.invalidate(pendingCountProvider);
      return SyncResult(succeeded, failed, exhausted);
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processAction(OfflineAction action) async {
    switch (action) {
      case final CreateExpenseAction a:
        final participantsRaw = jsonDecode(a.participantsJson) as List<dynamic>;
        final splitInput = _rebuildSplitInput(a.splitType, participantsRaw);
        await expenseRepository.createExpense(
          groupId: a.groupId,
          title: a.title,
          description: a.description,
          totalAmount: a.totalAmount,
          currency: a.currency,
          paidByUserId: a.paidByUserId,
          splitInput: splitInput,
          idempotencyKey: a.idempotencyKey,
        );

      case final CreateSettlementAction a:
        await settlementRepository.createSettlement(
          groupId: a.groupId,
          fromUserId: a.fromUserId,
          toUserId: a.toUserId,
          amount: a.amount,
          currency: a.currency,
          note: a.note,
          idempotencyKey: a.idempotencyKey,
        );

      case final AddMemberAction a:
        await groupRepository.addMember(groupId: a.groupId, email: a.email);
    }
  }

  ExpenseSplitInput _rebuildSplitInput(
    String splitType,
    List<dynamic> participants,
  ) {
    final upperType = splitType.toUpperCase();
    switch (upperType) {
      case 'EQUAL':
        return EqualSplitInput(
          participants: participants.map((p) {
            final map = p as Map<String, dynamic>;
            return EqualParticipantInput(
              userId: (map['user_id'] ?? map['userId']) as String,
            );
          }).toList(),
        );
      case 'EXACT':
        return ExactSplitInput(
          participants: participants.map((p) {
            final map = p as Map<String, dynamic>;
            return ExactParticipantInput(
              userId: (map['user_id'] ?? map['userId']) as String,
              owedAmount:
                  ((map['owed_amount'] ?? map['owedAmount'] ?? 0) as num)
                      .toDouble(),
            );
          }).toList(),
        );
      case 'PERCENTAGE':
        return PercentageSplitInput(
          participants: participants.map((p) {
            final map = p as Map<String, dynamic>;
            return PercentageParticipantInput(
              userId: (map['user_id'] ?? map['userId']) as String,
              percentage: ((map['percentage'] ?? 0) as num).toDouble(),
            );
          }).toList(),
        );
      case 'SHARE':
        return ShareSplitInput(
          participants: participants.map((p) {
            final map = p as Map<String, dynamic>;
            return ShareParticipantInput(
              userId: (map['user_id'] ?? map['userId']) as String,
              shares: ((map['shares'] ?? 0) as num).toInt(),
            );
          }).toList(),
        );
      default:
        return EqualSplitInput(
          participants: participants.map((p) {
            final map = p as Map<String, dynamic>;
            return EqualParticipantInput(
              userId: (map['user_id'] ?? map['userId']) as String,
            );
          }).toList(),
        );
    }
  }

  String _getActionTypeString(OfflineAction action) {
    return switch (action) {
      CreateExpenseAction() => 'CREATE_EXPENSE',
      CreateSettlementAction() => 'CREATE_SETTLEMENT',
      AddMemberAction() => 'ADD_MEMBER',
    };
  }

  bool _isConflictError(Object error) {
    if (error is ConflictException) return true;
    if (error is Failure) {
      final msg = error.message.toLowerCase();
      if (msg.contains('already') ||
          msg.contains('conflict') ||
          msg.contains('registered')) {
        return true;
      }
    }
    final errStr = error.toString().toLowerCase();
    return errStr.contains('409') ||
        errStr.contains('conflict') ||
        errStr.contains('already');
  }
}

/// Provider exposing [ISyncService] with ref.keepAlive().
final syncServiceProvider = Provider<ISyncService>((ref) {
  ref.keepAlive();
  return SyncServiceImpl(
    queue: ref.watch(offlineQueueRepositoryProvider),
    expenseRepository: ref.watch(expenseRepositoryProvider),
    settlementRepository: ref.watch(settlementRepositoryProvider),
    groupRepository: ref.watch(groupRepositoryProvider),
    ref: ref,
  );
});
