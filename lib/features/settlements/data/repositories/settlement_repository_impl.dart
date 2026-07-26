import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/settlement.dart';
import '../../domain/repositories/i_settlement_repository.dart';
import '../datasources/settlement_remote_datasource.dart';

/// Repository implementation handling settlement serialization mappings.
class SettlementRepositoryImpl implements ISettlementRepository {
  /// The remote datasource dependency.
  final ISettlementRemoteDatasource datasource;

  /// Creates a new [SettlementRepositoryImpl] instance.
  const SettlementRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<List<Settlement>> getGroupSettlements({
    required String groupId,
  }) async {
    final list = await datasource.getGroupSettlements(groupId: groupId);
    return list.map((s) => s.toEntity()).toList();
  }

  @override
  Future<Settlement> createSettlement({
    required String groupId,
    required String fromUserId,
    required String toUserId,
    required double amount,
    required String currency,
    String? note,
    String? idempotencyKey,
  }) async {
    final model = await datasource.createSettlement(
      groupId: groupId,
      fromUserId: fromUserId,
      toUserId: toUserId,
      amount: amount,
      currency: currency,
      note: note,
      idempotencyKey: idempotencyKey,
    );
    return model.toEntity();
  }
}

/// Provider exposing [ISettlementRepository].
final settlementRepositoryProvider = Provider<ISettlementRepository>((ref) {
  final datasource = ref.watch(settlementRemoteDatasourceProvider);
  return SettlementRepositoryImpl(datasource: datasource);
});
