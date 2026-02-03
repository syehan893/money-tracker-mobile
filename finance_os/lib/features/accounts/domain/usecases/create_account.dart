import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

/// Use case for creating a new account
class CreateAccount implements UseCase<Account, CreateAccountParams> {
  final AccountRepository repository;

  CreateAccount(this.repository);

  @override
  Future<Either<Failure, Account>> call(CreateAccountParams params) async {
    return await repository.createAccount(
      name: params.name,
      type: params.type,
      balance: params.balance,
      currency: params.currency,
      description: params.description,
    );
  }
}

class CreateAccountParams extends Equatable {
  final String name;
  final AccountType type;
  final double balance;
  final String currency;
  final String? description;

  const CreateAccountParams({
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
    this.description,
  });

  @override
  List<Object?> get props => [name, type, balance, currency, description];
}
