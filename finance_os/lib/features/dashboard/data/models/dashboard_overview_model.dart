import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_overview.dart';

part 'dashboard_overview_model.freezed.dart';
part 'dashboard_overview_model.g.dart';

@freezed
class DashboardOverviewModel with _$DashboardOverviewModel {
  const DashboardOverviewModel._();

  const factory DashboardOverviewModel({
    @JsonKey(name: 'total_balance') required double totalBalance,
    @JsonKey(name: 'monthly_income') required double monthlyIncome,
    @JsonKey(name: 'monthly_expense') required double monthlyExpense,
    @JsonKey(name: 'net_savings') required double netSavings,
    @JsonKey(name: 'income_change') required double incomeChange,
    @JsonKey(name: 'expense_change') required double expenseChange,
    @JsonKey(name: 'recent_transactions')
    required List<RecentTransactionModel> recentTransactions,
    @JsonKey(name: 'expense_breakdown')
    required List<ExpenseCategoryModel> expenseBreakdown,
  }) = _DashboardOverviewModel;

  factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardOverviewModelFromJson(json);

  DashboardOverview toEntity() => DashboardOverview(
        totalBalance: totalBalance,
        monthlyIncome: monthlyIncome,
        monthlyExpense: monthlyExpense,
        netSavings: netSavings,
        incomeChange: incomeChange,
        expenseChange: expenseChange,
        recentTransactions:
            recentTransactions.map((e) => e.toEntity()).toList(),
        expenseBreakdown: expenseBreakdown.map((e) => e.toEntity()).toList(),
      );
}

@freezed
class RecentTransactionModel with _$RecentTransactionModel {
  const RecentTransactionModel._();

  const factory RecentTransactionModel({
    required String id,
    required String title,
    required String category,
    required double amount,
    @JsonKey(name: 'is_income') required bool isIncome,
    required DateTime date,
    @JsonKey(name: 'icon_name') String? iconName,
  }) = _RecentTransactionModel;

  factory RecentTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$RecentTransactionModelFromJson(json);

  RecentTransaction toEntity() => RecentTransaction(
        id: id,
        title: title,
        category: category,
        amount: amount,
        isIncome: isIncome,
        date: date,
        iconName: iconName,
      );
}

@freezed
class ExpenseCategoryModel with _$ExpenseCategoryModel {
  const ExpenseCategoryModel._();

  const factory ExpenseCategoryModel({
    required String name,
    required double amount,
    required double percentage,
    String? color,
  }) = _ExpenseCategoryModel;

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryModelFromJson(json);

  ExpenseCategory toEntity() => ExpenseCategory(
        name: name,
        amount: amount,
        percentage: percentage,
        color: color,
      );
}
