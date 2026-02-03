import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

/// Use case for getting all accounts
class GetAccounts implements UseCase<List<Account>, NoParams> {
  final AccountRepository repository;

  GetAccounts(this.repository);

  @override
  Future<Either<Failure, List<Account>>> call(NoParams params) async {
    return await repository.getAccounts();
  }
}
