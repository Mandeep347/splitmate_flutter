import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/constants/app_constants.dart';
import 'package:splito_flutter/core/network/dio_client.dart';
import '../models/settlement_model.dart';

/// Abstract contract for settlements remote operations.
abstract interface class ISettlementRemoteDatasource {
  /// Fetches group settlements history list.
  Future<List<SettlementModel>> getGroupSettlements({required String groupId});

  /// Creates and posts a new settlement.
  Future<SettlementModel> createSettlement({
    required String groupId,
    required String fromUserId,
    required String toUserId,
    required double amount,
    required String currency,
    String? note,
    String? idempotencyKey,
  });
}

/// Remote datasource implementation using [DioClient].
class SettlementRemoteDatasource implements ISettlementRemoteDatasource {
  /// The HTTP client dependency.
  final DioClient client;

  /// Creates a new [SettlementRemoteDatasource] instance.
  const SettlementRemoteDatasource({required this.client});

  @override
  Future<List<SettlementModel>> getGroupSettlements({
    required String groupId,
  }) async {
    final response = await client.get<List<dynamic>>(
      ApiEndpoints.groupSettlements(groupId),
    );
    return response.data!
        .map((item) => SettlementModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<SettlementModel> createSettlement({
    required String groupId,
    required String fromUserId,
    required String toUserId,
    required double amount,
    required String currency,
    String? note,
    String? idempotencyKey,
  }) async {
    final options = idempotencyKey != null
        ? Options(headers: {'Idempotency-Key': idempotencyKey})
        : null;

    final response = await client.post<Map<String, dynamic>>(
      ApiEndpoints.groupSettlements(groupId),
      data: {
        'from_user_id': fromUserId,
        'to_user_id': toUserId,
        'amount': amount.toStringAsFixed(2),
        'currency': currency,
        if (note != null) 'note': note,
      },
      options: options,
    );
    return SettlementModel.fromJson(response.data!);
  }
}

/// Provider exposing [ISettlementRemoteDatasource].
final settlementRemoteDatasourceProvider =
    Provider<ISettlementRemoteDatasource>((ref) {
      final client = ref.watch(dioClientProvider);
      return SettlementRemoteDatasource(client: client);
    });
