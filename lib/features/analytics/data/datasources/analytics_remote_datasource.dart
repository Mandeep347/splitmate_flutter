import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/network/dio_client.dart';
import '../models/group_analytics_model.dart';
import '../models/user_analytics_model.dart';

/// Abstract contract governing remote network calls for analytics statistics.
abstract interface class IAnalyticsRemoteDatasource {
  /// Calls GET /groups/{groupId}/analytics.
  Future<GroupAnalyticsModel> getGroupAnalytics(String groupId);

  /// Calls GET /users/me/analytics.
  Future<UserAnalyticsModel> getUserAnalytics();
}

/// Remote datasource implementation using [DioClient].
class AnalyticsRemoteDatasource implements IAnalyticsRemoteDatasource {
  final DioClient _client;

  /// Creates a new [AnalyticsRemoteDatasource] instance.
  const AnalyticsRemoteDatasource(this._client);

  @override
  Future<GroupAnalyticsModel> getGroupAnalytics(String groupId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/groups/$groupId/analytics',
    );
    return GroupAnalyticsModel.fromJson(response.data!);
  }

  @override
  Future<UserAnalyticsModel> getUserAnalytics() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/users/me/analytics',
    );
    return UserAnalyticsModel.fromJson(response.data!);
  }
}

/// Provider exposing [IAnalyticsRemoteDatasource].
final analyticsRemoteDatasourceProvider = Provider<IAnalyticsRemoteDatasource>((
  ref,
) {
  final dioClient = ref.watch(dioClientProvider);
  return AnalyticsRemoteDatasource(dioClient);
});
