import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/income.dart';
import '../../domain/usecases/create_income.dart';
import '../../domain/usecases/get_incomes.dart';

part 'income_event.dart';
part 'income_state.dart';

@injectable
class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  final GetIncomes _getIncomes;
  final CreateIncome _createIncome;

  IncomeBloc({
    required GetIncomes getIncomes,
    required CreateIncome createIncome,
  })  : _getIncomes = getIncomes,
        _createIncome = createIncome,
        super(IncomeState.initial()) {
    on<IncomeLoadRequested>(_onLoadRequested);
    on<IncomeCreateRequested>(_onCreateRequested);
  }

  Future<void> _onLoadRequested(
    IncomeLoadRequested event,
    Emitter<IncomeState> emit,
  ) async {
    emit(state.copyWith(status: IncomeStatus.loading));

    final result = await _getIncomes(GetIncomesParams(
      startDate: event.startDate,
      endDate: event.endDate,
      incomeTypeId: event.incomeTypeId,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: IncomeStatus.error,
        errorMessage: failure.message,
      )),
      (incomes) => emit(state.copyWith(
        status: IncomeStatus.loaded,
        incomes: incomes,
        totalIncome: incomes.fold<double>(0, (sum, i) => sum + i.amount),
      )),
    );
  }

  Future<void> _onCreateRequested(
    IncomeCreateRequested event,
    Emitter<IncomeState> emit,
  ) async {
    emit(state.copyWith(status: IncomeStatus.submitting));

    final result = await _createIncome(CreateIncomeParams(
      amount: event.amount,
      incomeTypeId: event.incomeTypeId,
      accountId: event.accountId,
      date: event.date,
      description: event.description,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: IncomeStatus.loaded,
        errorMessage: failure.message,
      )),
      (income) {
        final incomes = [...state.incomes, income];
        emit(state.copyWith(
          status: IncomeStatus.success,
          incomes: incomes,
          totalIncome: incomes.fold<double>(0, (sum, i) => sum + i.amount),
          successMessage: 'Income recorded successfully',
        ));
      },
    );
  }
}
