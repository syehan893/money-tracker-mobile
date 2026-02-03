part of 'expenses_bloc.dart';

enum ExpensesStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error,
}

class ExpensesState extends Equatable {
  final ExpensesStatus status;
  final List<ExpenseType> expenseTypes;
  final List<Expense> expenses;
  final String? errorMessage;
  final String? successMessage;

  const ExpensesState({
    this.status = ExpensesStatus.initial,
    this.expenseTypes = const [],
    this.expenses = const [],
    this.errorMessage,
    this.successMessage,
  });

  factory ExpensesState.initial() => const ExpensesState();

  bool get isLoading => status == ExpensesStatus.loading;
  bool get isSubmitting => status == ExpensesStatus.submitting;

  ExpensesState copyWith({
    ExpensesStatus? status,
    List<ExpenseType>? expenseTypes,
    List<Expense>? expenses,
    String? errorMessage,
    String? successMessage,
  }) {
    return ExpensesState(
      status: status ?? this.status,
      expenseTypes: expenseTypes ?? this.expenseTypes,
      expenses: expenses ?? this.expenses,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, expenseTypes, expenses, errorMessage, successMessage];
}
