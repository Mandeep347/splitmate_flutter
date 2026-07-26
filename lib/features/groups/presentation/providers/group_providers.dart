import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/network/connectivity_notifier.dart';
import 'package:splito_flutter/core/offline/domain/entities/offline_action.dart';
import 'package:splito_flutter/core/offline/presentation/providers/offline_queue_providers.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/groups/data/repositories/group_repository_impl.dart';
import 'package:splito_flutter/features/groups/domain/entities/group.dart';
import 'package:splito_flutter/features/groups/domain/entities/group_member.dart';
import 'package:splito_flutter/features/groups/domain/usecases/add_member_usecase.dart';
import 'package:splito_flutter/features/groups/domain/usecases/archive_group_usecase.dart';
import 'package:splito_flutter/features/groups/domain/usecases/create_group_usecase.dart';
import 'package:splito_flutter/features/groups/domain/usecases/get_group_by_id_usecase.dart';
import 'package:splito_flutter/features/groups/domain/usecases/get_members_usecase.dart';
import 'package:splito_flutter/features/groups/domain/usecases/get_my_groups_usecase.dart';
import 'package:splito_flutter/features/groups/domain/usecases/remove_member_usecase.dart';
import 'package:splito_flutter/features/groups/domain/usecases/update_group_usecase.dart';
import 'package:splito_flutter/features/activity/presentation/providers/activity_providers.dart';
import 'package:splito_flutter/core/utils/provider_ttl.dart';

/// Provider exposing [GetMyGroupsUseCase].
final getMyGroupsUseCaseProvider = Provider<GetMyGroupsUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return GetMyGroupsUseCase(repository: repository);
});

/// Provider exposing [GetGroupByIdUseCase].
final getGroupByIdUseCaseProvider = Provider<GetGroupByIdUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return GetGroupByIdUseCase(repository: repository);
});

/// Provider exposing [CreateGroupUseCase].
final createGroupUseCaseProvider = Provider<CreateGroupUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return CreateGroupUseCase(repository: repository);
});

/// Provider exposing [UpdateGroupUseCase].
final updateGroupUseCaseProvider = Provider<UpdateGroupUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return UpdateGroupUseCase(repository: repository);
});

/// Provider exposing [ArchiveGroupUseCase].
final archiveGroupUseCaseProvider = Provider<ArchiveGroupUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return ArchiveGroupUseCase(repository: repository);
});

/// Provider exposing [GetMembersUseCase].
final getMembersUseCaseProvider = Provider<GetMembersUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return GetMembersUseCase(repository: repository);
});

/// Provider exposing [AddMemberUseCase].
final addMemberUseCaseProvider = Provider<AddMemberUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return AddMemberUseCase(repository: repository);
});

/// Provider exposing [RemoveMemberUseCase].
final removeMemberUseCaseProvider = Provider<RemoveMemberUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return RemoveMemberUseCase(repository: repository);
});

class MyGroupsNotifier extends AsyncNotifier<List<Group>> {
  @override
  FutureOr<List<Group>> build() async {
    final isAuthenticated = ref.watch(authStateProvider);
    if (!isAuthenticated) {
      return [];
    }

    ref.cacheWithTTL(ProviderTTL.mediumTTL);

    final useCase = ref.watch(getMyGroupsUseCaseProvider);
    return useCase();
  }

  /// Invalidates the notifier to force a refresh.
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Provider exposing [MyGroupsNotifier].
final myGroupsProvider =
    AsyncNotifierProvider<MyGroupsNotifier, List<Group>>(() {
  return MyGroupsNotifier();
});

/// Notifier that manages fetching detailed records for a single group by ID.
class GroupDetailNotifier extends FamilyAsyncNotifier<Group, String> {
  @override
  FutureOr<Group> build(String groupId) {
    ref.cacheWithTTL(ProviderTTL.longTTL);
    
    final useCase = ref.watch(getGroupByIdUseCaseProvider);
    return useCase(groupId: groupId);
  }

  /// Invalidates this specific notifier.
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Family provider exposing detailed group states.
final groupDetailProvider =
    AsyncNotifierProvider.family<GroupDetailNotifier, Group, String>(() {
  return GroupDetailNotifier();
});

/// Notifier executing the creation of a new group.
class CreateGroupNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Default initialization, returns nothing
  }

  /// Triggers group creation.
  Future<void> create({
    required String name,
    required String currency,
  }) async {
    state = const AsyncLoading<void>();
    try {
      final useCase = ref.read(createGroupUseCaseProvider);
      await useCase(name: name, currency: currency);
      ref.invalidate(myGroupsProvider);
      state = const AsyncData<void>(null);
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<void>(failure, stackTrace);
      rethrow;
    }
  }
}

/// Provider exposing [CreateGroupNotifier].
final createGroupProvider =
    AsyncNotifierProvider<CreateGroupNotifier, void>(() {
  return CreateGroupNotifier();
});

/// Notifier executing group profile details update.
class UpdateGroupNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Default initialization, returns nothing
  }

  /// Triggers updating group details.
  Future<void> updateGroup({
    required String groupId,
    required String name,
  }) async {
    state = const AsyncLoading<void>();
    try {
      final useCase = ref.read(updateGroupUseCaseProvider);
      await useCase(groupId: groupId, name: name);
      ref.invalidate(myGroupsProvider);
      ref.invalidate(groupDetailProvider(groupId));
      state = const AsyncData<void>(null);
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<void>(failure, stackTrace);
      rethrow;
    }
  }
}

/// Provider exposing [UpdateGroupNotifier].
final updateGroupProvider =
    AsyncNotifierProvider<UpdateGroupNotifier, void>(() {
  return UpdateGroupNotifier();
});

/// Notifier executing group archiving operations.
class ArchiveGroupNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Default initialization, returns nothing
  }

  /// Triggers archiving group.
  Future<void> archive({required String groupId}) async {
    state = const AsyncLoading<void>();
    try {
      final useCase = ref.read(archiveGroupUseCaseProvider);
      await useCase(groupId: groupId);
      ref.invalidate(myGroupsProvider);
      ref.invalidate(groupDetailProvider(groupId));
      state = const AsyncData<void>(null);
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<void>(failure, stackTrace);
      rethrow;
    }
  }
}

/// Provider exposing [ArchiveGroupNotifier].
final archiveGroupProvider =
    AsyncNotifierProvider<ArchiveGroupNotifier, void>(() {
  return ArchiveGroupNotifier();
});

/// Notifier that manages fetching and listing the group members.
class GroupMembersNotifier extends FamilyAsyncNotifier<List<GroupMember>, String> {
  @override
  FutureOr<List<GroupMember>> build(String groupId) {
    final useCase = ref.watch(getMembersUseCaseProvider);
    return useCase(groupId: groupId);
  }

  /// Prepends an optimistic member locally to the list.
  void prependMember(GroupMember member) {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData([member, ...current]);
    }
  }
}

/// Family provider exposing the member list of a group.
final groupMembersProvider = AsyncNotifierProvider.family<
    GroupMembersNotifier, List<GroupMember>, String>(() {
  return GroupMembersNotifier();
});

/// Notifier executing member invitation / additions.
class AddMemberNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Default initialization, returns nothing
  }

  /// Adds a new member to a group by email.
  Future<void> add({
    required String groupId,
    required String email,
  }) async {
    state = const AsyncLoading<void>();

    final isOnline = ref.read(isOnlineProvider);

    if (!isOnline) {
      final actionId = const Uuid().v4();
      final action = AddMemberAction(
        id: actionId,
        createdAt: DateTime.now(),
        groupId: groupId,
        email: email,
        idempotencyKey: const Uuid().v4(),
      );

      try {
        await ref.read(offlineQueueRepositoryProvider).enqueue(action);
      } catch (e, st) {
        debugPrint('Error enqueuing AddMemberAction: $e\n$st');
      }

      final localMember = GroupMember(
        userId: 'pending-$actionId',
        name: email.split('@').first,
        email: email,
        role: 'MEMBER',
        status: 'INVITED',
        joinedAt: DateTime.now(),
      );

      ref.read(groupMembersProvider(groupId).notifier).prependMember(localMember);
      ref.invalidate(pendingCountProvider);

      state = const AsyncData<void>(null);
      return;
    }

    try {
      final useCase = ref.read(addMemberUseCaseProvider);
      await useCase(groupId: groupId, email: email);
      ref.invalidate(groupDetailProvider(groupId));
      ref.invalidate(groupMembersProvider(groupId));
      ref.invalidate(groupActivityProvider(groupId));
      ref.invalidate(myGroupsProvider);
      state = const AsyncData<void>(null);
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<void>(failure, stackTrace);
      rethrow;
    }
  }
}

/// Provider exposing [AddMemberNotifier].
final addMemberProvider =
    AsyncNotifierProvider<AddMemberNotifier, void>(() {
  return AddMemberNotifier();
});

/// Notifier executing member removal actions.
class RemoveMemberNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Default initialization, returns nothing
  }

  /// Removes an existing member from a group.
  Future<void> remove({
    required String groupId,
    required String userId,
  }) async {
    state = const AsyncLoading<void>();
    try {
      final useCase = ref.read(removeMemberUseCaseProvider);
      await useCase(groupId: groupId, userId: userId);
      ref.invalidate(groupDetailProvider(groupId));
      ref.invalidate(groupMembersProvider(groupId));
      state = const AsyncData<void>(null);
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<void>(failure, stackTrace);
      rethrow;
    }
  }
}

/// Provider exposing [RemoveMemberNotifier].
final removeMemberProvider =
    AsyncNotifierProvider<RemoveMemberNotifier, void>(() {
  return RemoveMemberNotifier();
});
