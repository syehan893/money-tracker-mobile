import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transfer.dart';

/// Abstract repository for transfer operations
abstract class TransferRepository {
  /// Get all transfers with optional date filtering
  Future<Either<Failure, List<Transfer>>> getTransfers({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get a single transfer by ID
  Future<Either<Failure, Transfer>> getTransferById(String id);

  /// Create a new transfer between accounts
  Future<Either<Failure, Transfer>> createTransfer({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    required DateTime date,
    String? description,
  });

  /// Delete a transfer
  Future<Either<Failure, void>> deleteTransfer(String id);
}
