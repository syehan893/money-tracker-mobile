import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/transfer.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../datasources/transfer_local_datasource.dart';
import '../datasources/transfer_remote_datasource.dart';

@Injectable(as: TransferRepository)
class TransferRepositoryImpl implements TransferRepository {
  final TransferRemoteDataSource _remoteDataSource;
  final TransferLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  TransferRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<Transfer>>> getTransfers({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final transfers = await _remoteDataSource.getTransfers(
          startDate: startDate,
          endDate: endDate,
        );
        await _localDataSource.cacheTransfers(transfers);
        return Right(transfers.map((m) => m.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final cachedTransfers = await _localDataSource.getCachedTransfers();
        return Right(cachedTransfers.map((m) => m.toEntity()).toList());
      } catch (e) {
        return const Left(CacheFailure(message: 'No cached transfers available'));
      }
    }
  }

  @override
  Future<Either<Failure, Transfer>> getTransferById(String id) async {
    try {
      final transfer = await _remoteDataSource.getTransferById(id);
      return Right(transfer.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Transfer>> createTransfer({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    required DateTime date,
    String? description,
  }) async {
    try {
      final transfer = await _remoteDataSource.createTransfer(
        fromAccountId: fromAccountId,
        toAccountId: toAccountId,
        amount: amount,
        date: date,
        description: description,
      );
      return Right(transfer.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransfer(String id) async {
    try {
      await _remoteDataSource.deleteTransfer(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
