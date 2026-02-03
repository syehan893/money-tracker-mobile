import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transfer.dart';
import '../repositories/transfer_repository.dart';

@injectable
class CreateTransfer implements UseCase<Transfer, CreateTransferParams> {
  final TransferRepository repository;

  CreateTransfer(this.repository);

  @override
  Future<Either<Failure, Transfer>> call(CreateTransferParams params) {
    return repository.createTransfer(
      fromAccountId: params.fromAccountId,
      toAccountId: params.toAccountId,
      amount: params.amount,
      date: params.date,
      description: params.description,
    );
  }
}

class CreateTransferParams extends Equatable {
  final String fromAccountId;
  final String toAccountId;
  final double amount;
  final DateTime date;
  final String? description;

  const CreateTransferParams({
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    required this.date,
    this.description,
  });

  @override
  List<Object?> get props => [fromAccountId, toAccountId, amount, date, description];
}
