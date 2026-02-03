import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/account_repository.dart';

/// Use case for deleting an account
class DeleteAccount implements UseCase<void, DeleteAccountParams> {
  final AccountRepository repository;

  DeleteAccount(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAccountParams params) async {
    return await repository.deleteAccount(params.id);
  }
}

class DeleteAccountParams extends Equatable {
  final String id;

  const DeleteAccountParams({required this.id});

  @override
  List<Object?> get props => [id];
}
