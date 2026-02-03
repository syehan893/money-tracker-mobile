import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/transfer_repository.dart';

@injectable
class DeleteTransfer implements UseCase<void, String> {
  final TransferRepository repository;

  DeleteTransfer(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteTransfer(id);
  }
}
