import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/features/groups/domain/repositories/i_group_repository.dart';
import 'package:splito_flutter/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:splito_flutter/features/settlements/domain/repositories/i_settlement_repository.dart';
import 'package:splito_flutter/features/groups/domain/entities/group.dart';
import 'package:splito_flutter/features/groups/domain/entities/group_member.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/paginated_expenses.dart';
import 'package:splito_flutter/features/settlements/domain/entities/settlement.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'package:splito_flutter/features/activity/data/repositories/activity_repository_impl.dart';

class MockIGroupRepository extends Mock implements IGroupRepository {}

class MockIExpenseRepository extends Mock implements IExpenseRepository {}

class MockISettlementRepository extends Mock implements ISettlementRepository {}

void main() {
  late MockIGroupRepository mockGroupRepo;
  late MockIExpenseRepository mockExpenseRepo;
  late MockISettlementRepository mockSettlementRepo;
  late ActivityRepositoryImpl repository;

  final tMember1 = GroupMember(
    userId: 'user-1',
    name: 'Mandeep',
    email: 'mandeep@gmail.com',
    role: 'ADMIN',
    status: 'ACTIVE',
    joinedAt: DateTime(2026, 1, 1),
  );

  final tMember2 = GroupMember(
    userId: 'user-2',
    name: 'Rahul',
    email: 'rahul@gmail.com',
    role: 'MEMBER',
    status: 'ACTIVE',
    joinedAt: DateTime(2026, 1, 2),
  );

  final tGroup = Group(
    id: 'group-1',
    name: 'Test Group',
    defaultCurrency: 'INR',
    status: 'ACTIVE',
    createdBy: 'user-1',
    createdAt: DateTime(2026, 1, 1),
    membersCount: 2,
    members: [tMember1, tMember2],
  );

  final tExpense1 = Expense(
    id: 'expense-1',
    groupId: 'group-1',
    paidByUserId: 'user-1',
    paidByName: 'Mandeep',
    title: 'Dinner',
    description: 'Yummy food',
    totalAmount: 1000.0,
    currency: 'INR',
    splitType: SplitType.equal,
    status: 'ACTIVE',
    createdAt: DateTime(2026, 1, 3),
    participants: const [],
  );

  final tExpense2 = Expense(
    id: 'expense-2',
    groupId: 'group-1',
    paidByUserId: 'user-2',
    paidByName: 'Rahul',
    title: 'Uber',
    description: 'Ride home',
    totalAmount: 200.0,
    currency: 'INR',
    splitType: SplitType.equal,
    status: 'REVERSED',
    createdAt: DateTime(2026, 1, 4),
    participants: const [],
  );

  final tSettlement = Settlement(
    id: 'settlement-1',
    groupId: 'group-1',
    fromUserId: 'user-2',
    fromUserName: 'Rahul',
    toUserId: 'user-1',
    toUserName: 'Mandeep',
    amount: 500.0,
    currency: 'INR',
    note: 'Settling Dinner',
    status: 'COMPLETED',
    createdAt: DateTime(2026, 1, 5),
  );

  setUp(() {
    mockGroupRepo = MockIGroupRepository();
    mockExpenseRepo = MockIExpenseRepository();
    mockSettlementRepo = MockISettlementRepository();
    repository = ActivityRepositoryImpl(
      groupRepository: mockGroupRepo,
      expenseRepository: mockExpenseRepo,
      settlementRepository: mockSettlementRepo,
    );
  });

  group('getGroupActivities client-side aggregation', () {
    test(
      'aggregates, sorts descending, and returns paginated ActivityFeed',
      () async {
        when(
          () => mockGroupRepo.getGroupById(groupId: 'group-1'),
        ).thenAnswer((_) async => tGroup);
        when(
          () => mockExpenseRepo.getGroupExpenses(
            groupId: 'group-1',
            page: 1,
            limit: 1000,
          ),
        ).thenAnswer(
          (_) async => PaginatedExpenses(
            items: [tExpense1, tExpense2],
            page: 1,
            limit: 1000,
            totalItems: 2,
            totalPages: 1,
          ),
        );
        when(
          () => mockSettlementRepo.getGroupSettlements(groupId: 'group-1'),
        ).thenAnswer((_) async => [tSettlement]);

        // There should be:
        // - 2 MEMBER_ADDED (Mandeep on Jan 1, Rahul on Jan 2)
        // - 1 EXPENSE_CREATED (Dinner on Jan 3)
        // - 1 EXPENSE_CREATED (Uber on Jan 4)
        // - 1 EXPENSE_REVERSED (Uber on Jan 4 + 1s)
        // - 1 SETTLEMENT_RECORDED (Settlement on Jan 5)
        // Total 6 activities. Sorted by time descending:
        // 1. Settlement (Jan 5)
        // 2. Expense reversed (Jan 4 + 1s)
        // 3. Expense created (Jan 4)
        // 4. Expense created (Jan 3)
        // 5. Member joined (Jan 2)
        // 6. Member joined (Jan 1)

        final feed = await repository.getGroupActivities(
          groupId: 'group-1',
          page: 1,
          limit: 4,
        );

        expect(feed.totalItems, equals(6));
        expect(feed.items.length, equals(4));

        expect(feed.items[0].type, equals('SETTLEMENT_RECORDED'));
        expect(feed.items[0].createdAt, equals(DateTime(2026, 1, 5)));

        expect(feed.items[1].type, equals('EXPENSE_REVERSED'));
        expect(feed.items[1].id, equals('expense-reversed-expense-2'));

        expect(feed.items[2].type, equals('EXPENSE_CREATED'));
        expect(feed.items[2].id, equals('expense-created-expense-2'));

        expect(feed.items[3].type, equals('EXPENSE_CREATED'));
        expect(feed.items[3].id, equals('expense-created-expense-1'));

        // Test page 2 pagination
        final feedPage2 = await repository.getGroupActivities(
          groupId: 'group-1',
          page: 2,
          limit: 4,
        );
        expect(feedPage2.items.length, equals(2));
        expect(feedPage2.items[0].type, equals('MEMBER_ADDED'));
        expect(feedPage2.items[0].actorName, equals('Rahul'));
        expect(feedPage2.items[1].actorName, equals('Mandeep'));
      },
    );
  });
}
