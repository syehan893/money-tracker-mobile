import 'package:equatable/equatable.dart';

/// Income type entity
class IncomeType extends Equatable {
  final String id;
  final String name;
  final double targetAmount;
  final String? iconName;
  final String? color;

  const IncomeType({
    required this.id,
    required this.name,
    this.targetAmount = 0,
    this.iconName,
    this.color,
  });

  @override
  List<Object?> get props => [id, name, targetAmount, iconName, color];
}

/// Income record entity
class Income extends Equatable {
  final String id;
  final double amount;
  final String incomeTypeId;
  final String? incomeTypeName;
  final String accountId;
  final String? accountName;
  final DateTime date;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Income({
    required this.id,
    required this.amount,
    required this.incomeTypeId,
    this.incomeTypeName,
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
        incomeTypeId,
        incomeTypeName,
        accountId,
        accountName,
        date,
        description,
        createdAt,
        updatedAt,
      ];
}
