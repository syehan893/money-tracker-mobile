import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/income.dart';
import '../repositories/income_repository.dart';

class GetIncomes implements UseCase<List<Income>, GetIncomesParams> {
  final IncomeRepository repository;

  GetIncomes(this.repository);

  @override
  Future<Either<Failure, List<Income>>> call(GetIncomesParams params) async {
    return await repository.getIncomes(
      startDate: params.startDate,
      endDate: params.endDate,
      incomeTypeId: params.incomeTypeId,
    );
  }
}

class GetIncomesParams extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? incomeTypeId;

  const GetIncomesParams({
    this.startDate,
    this.endDate,
    this.incomeTypeId,
  });

  @override
  List<Object?> get props => [startDate, endDate, incomeTypeId];
}
