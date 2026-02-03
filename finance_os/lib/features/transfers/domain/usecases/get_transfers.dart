import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transfer.dart';
import '../repositories/transfer_repository.dart';

@injectable
class GetTransfers implements UseCase<List<Transfer>, GetTransfersParams> {
  final TransferRepository repository;

  GetTransfers(this.repository);

  @override
  Future<Either<Failure, List<Transfer>>> call(GetTransfersParams params) {
    return repository.getTransfers(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetTransfersParams extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;

  const GetTransfersParams({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
