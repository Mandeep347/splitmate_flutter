import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/constants/app_constants.dart';
import 'package:splito_flutter/core/network/dio_client.dart';
import '../models/group_member_model.dart';
import '../models/group_model.dart';

/// Abstract contract governing remote REST calls for Splito groups.
abstract interface class IGroupRemoteDatasource {
  /// Fetches all groups the current user belongs to.
  Future<List<GroupModel>> getMyGroups();

  /// Fetches details of a specific group by ID.
  Future<GroupModel> getGroupById({required String groupId});

  /// Creates a new group.
  Future<GroupModel> createGroup({
    required String name,
    required String currency,
  });

  /// Updates details of an existing group.
  Future<GroupModel> updateGroup({
    required String groupId,
    required String name,
  });

  /// Archives a specific group by ID.
  Future<GroupModel> archiveGroup({required String groupId});

  /// Fetches members belonging to a group.
  Future<List<GroupMemberModel>> getMembers({required String groupId});

  /// Adds a new member to a group by email.
  Future<GroupMemberModel> addMember({
    required String groupId,
    required String email,
  });

  /// Removes an existing member from a group.
  Future<void> removeMember({required String groupId, required String userId});
}

/// Remote datasource implementation using [DioClient].
class GroupRemoteDatasource implements IGroupRemoteDatasource {
  final DioClient _client;

  /// Creates a new [GroupRemoteDatasource] instance.
  const GroupRemoteDatasource(this._client);

  @override
  Future<List<GroupModel>> getMyGroups() async {
    final response = await _client.get<dynamic>(ApiEndpoints.groups);
    final list = response.data as List<dynamic>;
    return list
        .map((item) => GroupModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<GroupModel> getGroupById({required String groupId}) async {
    final response = await _client.get<dynamic>(
      ApiEndpoints.groupById(groupId),
    );
    return GroupModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<GroupModel> createGroup({
    required String name,
    required String currency,
  }) async {
    final response = await _client.post<dynamic>(
      ApiEndpoints.groups,
      data: {'name': name, 'default_currency': currency},
    );
    return GroupModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<GroupModel> updateGroup({
    required String groupId,
    required String name,
  }) async {
    final response = await _client.patch<dynamic>(
      ApiEndpoints.groupById(groupId),
      data: {'name': name},
    );
    return GroupModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<GroupModel> archiveGroup({required String groupId}) async {
    final response = await _client.patch<dynamic>(
      ApiEndpoints.archiveGroup(groupId),
    );
    return GroupModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<GroupMemberModel>> getMembers({required String groupId}) async {
    final response = await _client.get<dynamic>(
      ApiEndpoints.groupMembers(groupId),
    );
    final list = response.data as List<dynamic>;
    return list
        .map((item) => GroupMemberModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<GroupMemberModel> addMember({
    required String groupId,
    required String email,
  }) async {
    final response = await _client.post<dynamic>(
      ApiEndpoints.groupMembers(groupId),
      data: {'email': email},
    );
    return GroupMemberModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> removeMember({
    required String groupId,
    required String userId,
  }) async {
    await _client.delete<dynamic>(
      ApiEndpoints.groupMemberById(groupId, userId),
    );
  }
}

/// Provider exposing [IGroupRemoteDatasource].
final groupRemoteDatasourceProvider = Provider<IGroupRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return GroupRemoteDatasource(dioClient);
});
