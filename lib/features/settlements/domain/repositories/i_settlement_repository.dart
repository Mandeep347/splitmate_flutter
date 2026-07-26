import '../entities/settlement.dart';

/// Repository interface governing settlements creation and query operations.
abstract interface class ISettlementRepository {
  /// Fetches settlement transaction logs recorded for a group.
  Future<List<Settlement>> getGroupSettlements({
    required String groupId,
  });

  /// Creates and records a new debt settlement transaction.
  Future<Settlement> createSettlement({
    required String groupId,
    required String fromUserId,
    required String toUserId,
    required double amount,
    required String currency,
    String? note,
    String? idempotencyKey,
  });
}
