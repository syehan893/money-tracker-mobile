import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/income.dart';
import '../repositories/income_repository.dart';

class CreateIncome implements UseCase<Income, CreateIncomeParams> {
  final IncomeRepository repository;

  CreateIncome(this.repository);

  @override
  Future<Either<Failure, Income>> call(CreateIncomeParams params) async {
    return await repository.createIncome(
      amount: params.amount,
      incomeTypeId: params.incomeTypeId,
      accountId: params.accountId,
      date: params.date,
      description: params.description,
    );
  }
}

class CreateIncomeParams extends Equatable {
  final double amount;
  final String incomeTypeId;
  final String accountId;
  final DateTime date;
  final String? description;

  const CreateIncomeParams({
    required this.amount,
    required this.incomeTypeId,
    required this.accountId,
    required this.date,
    this.description,
  });

  @override
  List<Object?> get props => [amount, incomeTypeId, accountId, date, description];
}
