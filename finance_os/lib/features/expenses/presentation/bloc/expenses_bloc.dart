import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/create_expense.dart';
import '../../domain/usecases/get_expense_types.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

@injectable
class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final GetExpenseTypes _getExpenseTypes;
  final CreateExpense _createExpense;

  ExpensesBloc({
    required GetExpenseTypes getExpenseTypes,
    required CreateExpense createExpense,
  })  : _getExpenseTypes = getExpenseTypes,
        _createExpense = createExpense,
        super(ExpensesState.initial()) {
    on<ExpensesLoadRequested>(_onLoadRequested);
    on<ExpenseCreateRequested>(_onCreateRequested);
  }

  Future<void> _onLoadRequested(
    ExpensesLoadRequested event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(state.copyWith(status: ExpensesStatus.loading));

    final result = await _getExpenseTypes(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: ExpensesStatus.error,
        errorMessage: failure.message,
      )),
      (types) => emit(state.copyWith(
        status: ExpensesStatus.loaded,
        expenseTypes: types,
      )),
    );
  }

  Future<void> _onCreateRequested(
    ExpenseCreateRequested event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(state.copyWith(status: ExpensesStatus.submitting));

    final result = await _createExpense(CreateExpenseParams(
      amount: event.amount,
      expenseTypeId: event.expenseTypeId,
      accountId: event.accountId,
      date: event.date,
      description: event.description,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: ExpensesStatus.loaded,
        errorMessage: failure.message,
      )),
      (expense) {
        final expenses = [...state.expenses, expense];
        emit(state.copyWith(
          status: ExpensesStatus.success,
          expenses: expenses,
          successMessage: 'Expense recorded successfully',
        ));
      },
    );
  }
}
