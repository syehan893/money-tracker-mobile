import 'package:equatable/equatable.dart';

/// Transfer entity representing money movement between accounts
class Transfer extends Equatable {
  final String id;
  final String fromAccountId;
  final String toAccountId;
  final String fromAccountName;
  final String toAccountName;
  final double amount;
  final DateTime date;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transfer({
    required this.id,
    required this.fromAccountId,
    required this.toAccountId,
    required this.fromAccountName,
    required this.toAccountName,
    required this.amount,
    required this.date,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        fromAccountId,
        toAccountId,
        fromAccountName,
        toAccountName,
        amount,
        date,
        description,
        createdAt,
        updatedAt,
      ];
}
