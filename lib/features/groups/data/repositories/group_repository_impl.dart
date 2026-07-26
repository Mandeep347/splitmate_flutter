import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/group_member.dart';
import '../../domain/repositories/i_group_repository.dart';
import '../datasources/group_local_datasource.dart';
import '../datasources/group_remote_datasource.dart';

/// Implementation of the domain [IGroupRepository] contract.
class GroupRepositoryImpl implements IGroupRepository {
  /// The remote datasource dependency.
  final IGroupRemoteDatasource datasource;

  /// The local datasource dependency.
  final IGroupLocalDatasource localDatasource;

  /// Creates a new [GroupRepositoryImpl] instance.
  const GroupRepositoryImpl({
    required this.datasource,
    required this.localDatasource,
  });

  @override
  Future<List<Group>> getMyGroups() async {
    try {
      final models = await datasource.getMyGroups();
      await localDatasource.cacheGroups(models);
      return models.map((m) => m.toEntity()).toList();
    } catch (_) {
      final cached = await localDatasource.getCachedGroups();
      if (cached != null && cached.isNotEmpty) {
        return cached.map((m) => m.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Future<Group> getGroupById({required String groupId}) async {
    try {
      final model = await datasource.getGroupById(groupId: groupId);
      await localDatasource.cacheGroup(model);
      return model.toEntity();
    } catch (_) {
      final cached = await localDatasource.getCachedGroup(groupId);
      if (cached != null) {
        return cached.toEntity();
      }
      rethrow;
    }
  }

  @override
  Future<Group> createGroup({
    required String name,
    required String currency,
  }) async {
    final model = await datasource.createGroup(name: name, currency: currency);
    return model.toEntity();
  }

  @override
  Future<Group> updateGroup({
    required String groupId,
    required String name,
  }) async {
    final model = await datasource.updateGroup(groupId: groupId, name: name);
    return model.toEntity();
  }

  @override
  Future<Group> archiveGroup({required String groupId}) async {
    final model = await datasource.archiveGroup(groupId: groupId);
    return model.toEntity();
  }

  @override
  Future<List<GroupMember>> getMembers({required String groupId}) async {
    final models = await datasource.getMembers(groupId: groupId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<GroupMember> addMember({
    required String groupId,
    required String email,
  }) async {
    final model = await datasource.addMember(groupId: groupId, email: email);
    return model.toEntity();
  }

  @override
  Future<void> removeMember({
    required String groupId,
    required String userId,
  }) async {
    await datasource.removeMember(groupId: groupId, userId: userId);
  }
}

/// Provider exposing [IGroupRepository] interface.
final groupRepositoryProvider = Provider<IGroupRepository>((ref) {
  final datasource = ref.watch(groupRemoteDatasourceProvider);
  final localDatasource = ref.watch(groupLocalDatasourceProvider);
  return GroupRepositoryImpl(
    datasource: datasource,
    localDatasource: localDatasource,
  );
});
