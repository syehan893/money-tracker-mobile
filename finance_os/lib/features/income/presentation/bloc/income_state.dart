part of 'income_bloc.dart';

enum IncomeStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error,
}

class IncomeState extends Equatable {
  final IncomeStatus status;
  final List<Income> incomes;
  final double totalIncome;
  final String? errorMessage;
  final String? successMessage;

  const IncomeState({
    this.status = IncomeStatus.initial,
    this.incomes = const [],
    this.totalIncome = 0,
    this.errorMessage,
    this.successMessage,
  });

  factory IncomeState.initial() => const IncomeState();

  bool get isLoading => status == IncomeStatus.loading;
  bool get isSubmitting => status == IncomeStatus.submitting;

  IncomeState copyWith({
    IncomeStatus? status,
    List<Income>? incomes,
    double? totalIncome,
    String? errorMessage,
    String? successMessage,
  }) {
    return IncomeState(
      status: status ?? this.status,
      incomes: incomes ?? this.incomes,
      totalIncome: totalIncome ?? this.totalIncome,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, incomes, totalIncome, errorMessage, successMessage];
}
