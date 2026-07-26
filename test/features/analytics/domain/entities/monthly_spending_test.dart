import 'package:flutter_test/flutter_test.dart';
import 'package:splito_flutter/features/analytics/domain/entities/monthly_spending.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_participant.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'package:splito_flutter/features/settlements/domain/entities/settlement.dart';

const tParticipant1 = ExpenseParticipant(
  userId: 'user-1',
  name: 'Mandeep',
  owedAmount: 1000.0,
);
const tParticipant2 = ExpenseParticipant(
  userId: 'user-2',
  name: 'Rahul',
  owedAmount: 2000.0,
);

final tExpense1 = Expense(
  id: 'exp-1',
  groupId: 'group-1',
  paidByUserId: 'user-1',
  paidByName: 'Mandeep',
  title: 'Dinner',
  totalAmount: 3000.0,
  currency: 'INR',
  splitType: SplitType.equal,
  status: 'ACTIVE',
  createdAt: DateTime(2026, 1, 15),
  participants: [tParticipant1, tParticipant2],
);

final tExpense2 = Expense(
  id: 'exp-2',
  groupId: 'group-1',
  paidByUserId: 'user-2',
  paidByName: 'Rahul',
  title: 'Hotel',
  totalAmount: 6000.0,
  currency: 'INR',
  splitType: SplitType.exact,
  status: 'ACTIVE',
  createdAt: DateTime(2026, 2, 10),
  participants: [tParticipant1, tParticipant2],
);

final tReversedExpense = Expense(
  id: 'exp-3',
  groupId: 'group-1',
  paidByUserId: 'user-1',
  paidByName: 'Mandeep',
  title: 'Cancelled',
  totalAmount: 500.0,
  currency: 'INR',
  splitType: SplitType.equal,
  status: 'REVERSED',
  createdAt: DateTime(2026, 1, 20),
  participants: const [],
);

final tSettlement = Settlement(
  id: 'set-1',
  groupId: 'group-1',
  fromUserId: 'user-2',
  fromUserName: 'Rahul',
  toUserId: 'user-1',
  toUserName: 'Mandeep',
  amount: 1000.0,
  currency: 'INR',
  status: 'COMPLETED',
  createdAt: DateTime(2026, 2, 1),
);

void main() {
  group('MonthlySpending', () {
    test('monthLabel returns correct abbreviation', () {
      const spendingJan = MonthlySpending(
        year: 2026,
        month: 1,
        monthLabel: 'Jan',
        totalAmount: 1000.0,
        expenseCount: 1,
        currency: 'INR',
      );
      expect(spendingJan.monthLabel, 'Jan');

      const spendingDec = MonthlySpending(
        year: 2026,
        month: 12,
        monthLabel: 'Dec',
        totalAmount: 2000.0,
        expenseCount: 2,
        currency: 'INR',
      );
      expect(spendingDec.monthLabel, 'Dec');
    });

    test('periodLabel combines monthLabel and year', () {
      const spendingMar = MonthlySpending(
        year: 2026,
        month: 3,
        monthLabel: 'Mar',
        totalAmount: 1500.0,
        expenseCount: 1,
        currency: 'INR',
      );
      expect(spendingMar.periodLabel, 'Mar 2026');
    });
  });
}
