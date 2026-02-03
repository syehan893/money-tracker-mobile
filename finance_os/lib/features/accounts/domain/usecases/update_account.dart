import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

/// Use case for updating an account
class UpdateAccount implements UseCase<Account, UpdateAccountParams> {
  final AccountRepository repository;

  UpdateAccount(this.repository);

  @override
  Future<Either<Failure, Account>> call(UpdateAccountParams params) async {
    return await repository.updateAccount(
      id: params.id,
      name: params.name,
      type: params.type,
      currency: params.currency,
      description: params.description,
      isActive: params.isActive,
    );
  }
}

class UpdateAccountParams extends Equatable {
  final String id;
  final String? name;
  final AccountType? type;
  final String? currency;
  final String? description;
  final bool? isActive;

  const UpdateAccountParams({
    required this.id,
    this.name,
    this.type,
    this.currency,
    this.description,
    this.isActive,
  });

  @override
  List<Object?> get props => [id, name, type, currency, description, isActive];
}
