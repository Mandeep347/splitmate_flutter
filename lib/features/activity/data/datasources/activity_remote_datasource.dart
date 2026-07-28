import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/constants/app_constants.dart';
import 'package:splito_flutter/core/network/dio_client.dart';
import '../models/activity_item_model.dart';

/// Abstract contract governing remote REST calls for group activities.
abstract interface class IActivityRemoteDatasource {
  /// Fetches raw activities list for a specific group.
  Future<List<ActivityItemModel>> getGroupActivities({required String groupId});
}

/// Remote datasource implementation using [DioClient].
class ActivityRemoteDatasource implements IActivityRemoteDatasource {
  /// The dio client instance.
  final DioClient client;

  /// Creates a new [ActivityRemoteDatasource] instance.
  const ActivityRemoteDatasource({required this.client});

  @override
  Future<List<ActivityItemModel>> getGroupActivities({
    required String groupId,
  }) async {
    final response = await client.get<dynamic>(
      ApiEndpoints.groupActivities(groupId),
    );
    final list = response.data as List<dynamic>;
    return list
        .map((item) => ActivityItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

/// Provider exposing [IActivityRemoteDatasource] implementation.
final activityRemoteDatasourceProvider = Provider<IActivityRemoteDatasource>((
  ref,
) {
  final dioClient = ref.watch(dioClientProvider);
  return ActivityRemoteDatasource(client: dioClient);
});
