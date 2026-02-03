import 'package:equatable/equatable.dart';

/// Expense type (budget category) entity
class ExpenseType extends Equatable {
  final String id;
  final String name;
  final double budgetAmount;
  final double spentAmount;
  final String? iconName;
  final String? color;
  final String? imageUrl;

  const ExpenseType({
    required this.id,
    required this.name,
    this.budgetAmount = 0,
    this.spentAmount = 0,
    this.iconName,
    this.color,
    this.imageUrl,
  });

  double get percentUsed =>
      budgetAmount > 0 ? (spentAmount / budgetAmount * 100).clamp(0, 150) : 0;

  bool get isOverBudget => spentAmount > budgetAmount && budgetAmount > 0;
  bool get isNearLimit => percentUsed >= 80 && percentUsed < 100;

  @override
  List<Object?> get props =>
      [id, name, budgetAmount, spentAmount, iconName, color, imageUrl];
}

/// Expense record entity
class Expense extends Equatable {
  final String id;
  final double amount;
  final String expenseTypeId;
  final String? expenseTypeName;
  final String accountId;
  final String? accountName;
  final DateTime date;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Expense({
    required this.id,
    required this.amount,
    required this.expenseTypeId,
    this.expenseTypeName,
    required this.accountId,
    this.accountName,
    required this.date,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        expenseTypeId,
        expenseTypeName,
        accountId,
        accountName,
        date,
        description,
        createdAt,
        updatedAt,
      ];
}
