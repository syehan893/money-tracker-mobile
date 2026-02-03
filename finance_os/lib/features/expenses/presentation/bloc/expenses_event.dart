part of 'expenses_bloc.dart';

abstract class ExpensesEvent extends Equatable {
  const ExpensesEvent();

  @override
  List<Object?> get props => [];
}

class ExpensesLoadRequested extends ExpensesEvent {
  const ExpensesLoadRequested();
}

class ExpenseCreateRequested extends ExpensesEvent {
  final double amount;
  final String expenseTypeId;
  final String accountId;
  final DateTime date;
  final String? description;

  const ExpenseCreateRequested({
    required this.amount,
    required this.expenseTypeId,
    required this.accountId,
    required this.date,
    this.description,
  });

  @override
  List<Object?> get props => [amount, expenseTypeId, accountId, date, description];
}
