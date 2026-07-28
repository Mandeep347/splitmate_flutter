import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:splito_flutter/features/activity/domain/entities/activity_feed.dart';
import 'package:splito_flutter/features/activity/domain/entities/activity_item.dart';
import 'package:splito_flutter/features/activity/domain/usecases/get_group_activities_usecase.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/core/events/app_events.dart';

// ============================================================================
// UseCase Providers
// ============================================================================

/// Provider exposing [GetGroupActivitiesUseCase].
final getGroupActivitiesUseCaseProvider = Provider<GetGroupActivitiesUseCase>((ref) {
  final repository = ref.watch(activityRepositoryProvider);
  return GetGroupActivitiesUseCase(repository: repository);
});

// ============================================================================
// Notifiers
// ============================================================================

/// Notifier managing the paginated activity feed for a specific group.
class GroupActivityNotifier extends FamilyAsyncNotifier<ActivityFeed, String> {
  @override
  FutureOr<ActivityFeed> build(String groupId) {
    final isAuthenticated = ref.watch(authStateProvider);
    if (!isAuthenticated) {
      return ActivityFeed(
        groupId: groupId,
        items: const [],
        page: 1,
        limit: 0,
        totalPages: 1,
        totalItems: 0,
      );
    }
    final useCase = ref.watch(getGroupActivitiesUseCaseProvider);
    return useCase(groupId: groupId, page: 1);
  }

  /// Loads the next page of activities for this group.
  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (state.isLoading || current == null || !current.hasMore) {
      return;
    }

    final nextPage = current.page + 1;
    final useCase = ref.read(getGroupActivitiesUseCaseProvider);

    try {
      final newResult = await useCase(
        groupId: arg,
        page: nextPage,
        limit: current.limit,
      );

      state = AsyncData(ActivityFeed(
        groupId: arg,
        items: [...current.items, ...newResult.items],
        page: nextPage,
        limit: newResult.limit,
        totalPages: newResult.totalPages,
        totalItems: newResult.totalItems,
      ));
    } catch (e) {
      rethrow;
    }
  }

  /// Refreshes the activity feed by invalidating itself.
  void refresh() {
    ref.invalidateSelf();
  }
}

/// Family provider exposing the paginated activity feed.
final groupActivityProvider =
    AsyncNotifierProvider.family<GroupActivityNotifier, ActivityFeed, String>(() {
  return GroupActivityNotifier();
});

/// Aggregates recent activity items across all active groups.
final globalActivityProvider = Provider<AsyncValue<List<ActivityItem>>>((ref) {
  ref.watch(syncCompletedProvider);
  final groupsState = ref.watch(myGroupsProvider);

  return groupsState.when(
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
    data: (groups) {
      final activeGroups = groups.where((g) => g.isActive).toList();
      final List<ActivityItem> items = [];
      bool anyLoading = false;
      Object? firstError;
      StackTrace? firstStack;

      for (final group in activeGroups) {
        final feedState = ref.watch(groupActivityProvider(group.id));
        feedState.when(
          data: (feed) {
            items.addAll(feed.items);
          },
          loading: () => anyLoading = true,
          error: (err, stack) {
            firstError ??= err;
            firstStack ??= stack;
          },
        );
      }

      if (anyLoading && items.isEmpty) {
        return const AsyncValue.loading();
      }

      if (firstError != null && items.isEmpty) {
        return AsyncValue.error(firstError!, firstStack!);
      }

      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return AsyncValue.data(items);
    },
  );
});
