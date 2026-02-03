import 'package:equatable/equatable.dart';

/// Dashboard overview entity containing financial summary
class DashboardOverview extends Equatable {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final double netSavings;
  final double incomeChange;
  final double expenseChange;
  final List<RecentTransaction> recentTransactions;
  final List<ExpenseCategory> expenseBreakdown;

  const DashboardOverview({
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.netSavings,
    required this.incomeChange,
    required this.expenseChange,
    required this.recentTransactions,
    required this.expenseBreakdown,
  });

  factory DashboardOverview.empty() => const DashboardOverview(
        totalBalance: 0,
        monthlyIncome: 0,
        monthlyExpense: 0,
        netSavings: 0,
        incomeChange: 0,
        expenseChange: 0,
        recentTransactions: [],
        expenseBreakdown: [],
      );

  @override
  List<Object?> get props => [
        totalBalance,
        monthlyIncome,
        monthlyExpense,
        netSavings,
        incomeChange,
        expenseChange,
        recentTransactions,
        expenseBreakdown,
      ];
}

/// Recent transaction entity
class RecentTransaction extends Equatable {
  final String id;
  final String title;
  final String category;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String? iconName;

  const RecentTransaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
    this.iconName,
  });

  @override
  List<Object?> get props => [id, title, category, amount, isIncome, date, iconName];
}

/// Expense category for breakdown
class ExpenseCategory extends Equatable {
  final String name;
  final double amount;
  final double percentage;
  final String? color;

  const ExpenseCategory({
    required this.name,
    required this.amount,
    required this.percentage,
    this.color,
  });

  @override
  List<Object?> get props => [name, amount, percentage, color];
}
