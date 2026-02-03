part of 'income_bloc.dart';

abstract class IncomeEvent extends Equatable {
  const IncomeEvent();

  @override
  List<Object?> get props => [];
}

class IncomeLoadRequested extends IncomeEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? incomeTypeId;

  const IncomeLoadRequested({
    this.startDate,
    this.endDate,
    this.incomeTypeId,
  });

  @override
  List<Object?> get props => [startDate, endDate, incomeTypeId];
}

class IncomeCreateRequested extends IncomeEvent {
  final double amount;
  final String incomeTypeId;
  final String accountId;
  final DateTime date;
  final String? description;

  const IncomeCreateRequested({
    required this.amount,
    required this.incomeTypeId,
    required this.accountId,
    required this.date,
    this.description,
  });

  @override
  List<Object?> get props => [amount, incomeTypeId, accountId, date, description];
}
