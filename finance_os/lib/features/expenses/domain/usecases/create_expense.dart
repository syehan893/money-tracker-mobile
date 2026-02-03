import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class CreateExpense implements UseCase<Expense, CreateExpenseParams> {
  final ExpenseRepository repository;

  CreateExpense(this.repository);

  @override
  Future<Either<Failure, Expense>> call(CreateExpenseParams params) async {
    return await repository.createExpense(
      amount: params.amount,
      expenseTypeId: params.expenseTypeId,
      accountId: params.accountId,
      date: params.date,
      description: params.description,
    );
  }
}

class CreateExpenseParams extends Equatable {
  final double amount;
  final String expenseTypeId;
  final String accountId;
  final DateTime date;
  final String? description;

  const CreateExpenseParams({
    required this.amount,
    required this.expenseTypeId,
    required this.accountId,
    required this.date,
    this.description,
  });

  @override
  List<Object?> get props => [amount, expenseTypeId, accountId, date, description];
}
