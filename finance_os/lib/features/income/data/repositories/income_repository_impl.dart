import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/income.dart';
import '../../domain/repositories/income_repository.dart';
import '../datasources/income_remote_datasource.dart';

@LazySingleton(as: IncomeRepository)
class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  IncomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<IncomeType>>> getIncomeTypes() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final types = await remoteDataSource.getIncomeTypes();
      return Right(types.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, IncomeType>> createIncomeType({
    required String name,
    double targetAmount = 0,
    String? iconName,
    String? color,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final type = await remoteDataSource.createIncomeType(
        name: name,
        targetAmount: targetAmount,
        iconName: iconName,
        color: color,
      );
      return Right(type.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Income>>> getIncomes({
    DateTime? startDate,
    DateTime? endDate,
    String? incomeTypeId,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final incomes = await remoteDataSource.getIncomes(
        startDate: startDate,
        endDate: endDate,
        incomeTypeId: incomeTypeId,
      );
      return Right(incomes.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Income>> createIncome({
    required double amount,
    required String incomeTypeId,
    required String accountId,
    required DateTime date,
    String? description,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final income = await remoteDataSource.createIncome(
        amount: amount,
        incomeTypeId: incomeTypeId,
        accountId: accountId,
        date: date,
        description: description,
      );
      return Right(income.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteIncome(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      await remoteDataSource.deleteIncome(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalIncome({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final result = await getIncomes(startDate: startDate, endDate: endDate);
    return result.fold(
      (failure) => Left(failure),
      (incomes) {
        final total = incomes.fold<double>(0, (sum, i) => sum + i.amount);
        return Right(total);
      },
    );
  }
}
