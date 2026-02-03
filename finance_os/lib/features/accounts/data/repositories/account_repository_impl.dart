import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_local_datasource.dart';
import '../datasources/account_remote_datasource.dart';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;
  final AccountLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AccountRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Account>>> getAccounts() async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final accounts = await remoteDataSource.getAccounts();
          await localDataSource.cacheAccounts(accounts);
          return Right(accounts.map((e) => e.toEntity()).toList());
        } on ServerException catch (e) {
          // Fall back to cache
          final cached = await localDataSource.getCachedAccounts();
          if (cached.isNotEmpty) {
            return Right(cached.map((e) => e.toEntity()).toList());
          }
          return Left(ServerFailure(message: e.message));
        }
      } else {
        final cached = await localDataSource.getCachedAccounts();
        return Right(cached.map((e) => e.toEntity()).toList());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Account>> getAccountById(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final account = await remoteDataSource.getAccountById(id);
      return Right(account.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get account'));
    }
  }

  @override
  Future<Either<Failure, Account>> createAccount({
    required String name,
    required AccountType type,
    required double balance,
    required String currency,
    String? description,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final account = await remoteDataSource.createAccount(
        name: name,
        type: type,
        balance: balance,
        currency: currency,
        description: description,
      );
      await localDataSource.cacheAccount(account);
      return Right(account.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create account'));
    }
  }

  @override
  Future<Either<Failure, Account>> updateAccount({
    required String id,
    String? name,
    AccountType? type,
    String? currency,
    String? description,
    bool? isActive,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final account = await remoteDataSource.updateAccount(
        id: id,
        name: name,
        type: type,
        currency: currency,
        description: description,
        isActive: isActive,
      );
      await localDataSource.cacheAccount(account);
      return Right(account.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update account'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.deleteAccount(id);
      await localDataSource.removeAccount(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete account'));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalBalance() async {
    final result = await getAccounts();
    return result.fold(
      (failure) => Left(failure),
      (accounts) {
        final total = accounts
            .where((a) => a.isActive)
            .fold<double>(0, (sum, a) => sum + a.balance);
        return Right(total);
      },
    );
  }
}
