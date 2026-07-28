import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/groups/domain/repositories/i_group_repository.dart';
import 'package:splito_flutter/features/groups/data/repositories/group_repository_impl.dart';
import 'package:splito_flutter/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:splito_flutter/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:splito_flutter/features/settlements/domain/repositories/i_settlement_repository.dart';
import 'package:splito_flutter/features/settlements/data/repositories/settlement_repository_impl.dart';
import 'package:splito_flutter/features/groups/domain/entities/group.dart';
import 'package:splito_flutter/features/expenses/domain/entities/paginated_expenses.dart';
import 'package:splito_flutter/features/settlements/domain/entities/settlement.dart';
import 'package:splito_flutter/features/activity/domain/entities/activity_item.dart';
import '../../domain/entities/activity_feed.dart';
import '../../domain/repositories/i_activity_repository.dart';

/// Repository implementation delivering group activities computed client-side.
class ActivityRepositoryImpl implements IActivityRepository {
  /// The groups repository.
  final IGroupRepository groupRepository;

  /// The expenses repository.
  final IExpenseRepository expenseRepository;

  /// The settlements repository.
  final ISettlementRepository settlementRepository;

  /// Creates a new [ActivityRepositoryImpl] instance.
  const ActivityRepositoryImpl({
    required this.groupRepository,
    required this.expenseRepository,
    required this.settlementRepository,
  });

  @override
  Future<ActivityFeed> getGroupActivities({
    required String groupId,
    int page = 1,
    int limit = 20,
  }) async {
    // Fetch group details, expenses (first 1000 items), and settlements in parallel
    final futures = await Future.wait([
      groupRepository.getGroupById(groupId: groupId),
      expenseRepository.getGroupExpenses(
        groupId: groupId,
        page: 1,
        limit: 1000,
      ),
      settlementRepository.getGroupSettlements(groupId: groupId),
    ]);

    final group = futures[0] as Group;
    final paginatedExpenses = futures[1] as PaginatedExpenses;
    final settlements = futures[2] as List<Settlement>;

    final List<ActivityItem> allActivities = [];

    // 1. MEMBER_ADDED activities (for each member in the group)
    for (final member in group.members) {
      allActivities.add(
        ActivityItem(
          id: 'member-joined-${member.userId}',
          groupId: groupId,
          type: 'MEMBER_ADDED',
          actorName: member.name,
          actorUserId: member.userId,
          description: '${member.name} joined the group',
          createdAt: member.joinedAt,
        ),
      );
    }

    // 2. EXPENSE_CREATED (and potentially EXPENSE_REVERSED) activities
    for (final expense in paginatedExpenses.items) {
      allActivities.add(
        ActivityItem(
          id: 'expense-created-${expense.id}',
          groupId: groupId,
          type: 'EXPENSE_CREATED',
          actorName: expense.paidByName,
          actorUserId: expense.paidByUserId,
          description: '${expense.paidByName} added "${expense.title}"',
          entityId: expense.id,
          entityType: 'expense',
          createdAt: expense.createdAt,
        ),
      );

      if (expense.status == 'REVERSED') {
        allActivities.add(
          ActivityItem(
            id: 'expense-reversed-${expense.id}',
            groupId: groupId,
            type: 'EXPENSE_REVERSED',
            actorName: expense.paidByName,
            actorUserId: expense.paidByUserId,
            description: '"${expense.title}" was reversed',
            entityId: expense.id,
            entityType: 'expense',
            createdAt: expense.createdAt.add(const Duration(seconds: 1)),
          ),
        );
      }
    }

    // 3. SETTLEMENT_RECORDED activities
    for (final settlement in settlements) {
      allActivities.add(
        ActivityItem(
          id: 'settlement-recorded-${settlement.id}',
          groupId: groupId,
          type: 'SETTLEMENT_RECORDED',
          actorName: settlement.fromUserName,
          actorUserId: settlement.fromUserId,
          description:
              '${settlement.fromUserName} paid ${settlement.toUserName}',
          entityId: settlement.id,
          entityType: 'settlement',
          createdAt: settlement.createdAt,
        ),
      );
    }

    // Sort by createdAt descending
    allActivities.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Slice for pagination
    final startIndex = (page - 1) * limit;
    if (startIndex >= allActivities.length) {
      return ActivityFeed(
        groupId: groupId,
        items: const [],
        page: page,
        limit: limit,
        totalPages: (allActivities.length / limit).ceil(),
        totalItems: allActivities.length,
      );
    }

    final endIndex = (startIndex + limit).clamp(0, allActivities.length);
    final paginatedItems = allActivities.sublist(startIndex, endIndex);

    return ActivityFeed(
      groupId: groupId,
      items: paginatedItems,
      page: page,
      limit: limit,
      totalPages: (allActivities.length / limit).ceil(),
      totalItems: allActivities.length,
    );
  }
}

/// Provider exposing [IActivityRepository] implementation.
final activityRepositoryProvider = Provider<IActivityRepository>((ref) {
  final groupRepo = ref.watch(groupRepositoryProvider);
  final expenseRepo = ref.watch(expenseRepositoryProvider);
  final settlementRepo = ref.watch(settlementRepositoryProvider);
  return ActivityRepositoryImpl(
    groupRepository: groupRepo,
    expenseRepository: expenseRepo,
    settlementRepository: settlementRepo,
  );
});
