import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpenseTypes implements UseCase<List<ExpenseType>, NoParams> {
  final ExpenseRepository repository;

  GetExpenseTypes(this.repository);

  @override
  Future<Either<Failure, List<ExpenseType>>> call(NoParams params) async {
    return await repository.getExpenseTypes();
  }
}
