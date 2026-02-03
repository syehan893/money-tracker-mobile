import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasource.dart';

@LazySingleton(as: ExpenseRepository)
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ExpenseRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ExpenseType>>> getExpenseTypes() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final types = await remoteDataSource.getExpenseTypes();
      return Right(types.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ExpenseType>> createExpenseType({
    required String name,
    double budgetAmount = 0,
    String? iconName,
    String? color,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final type = await remoteDataSource.createExpenseType(
        name: name,
        budgetAmount: budgetAmount,
        iconName: iconName,
        color: color,
      );
      return Right(type.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ExpenseType>> updateExpenseType({
    required String id,
    String? name,
    double? budgetAmount,
    String? iconName,
    String? color,
  }) async {
    // Implementation for updating expense type
    return Left(ServerFailure(message: 'Not implemented'));
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? expenseTypeId,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final expenses = await remoteDataSource.getExpenses(
        startDate: startDate,
        endDate: endDate,
        expenseTypeId: expenseTypeId,
      );
      return Right(expenses.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Expense>> createExpense({
    required double amount,
    required String expenseTypeId,
    required String accountId,
    required DateTime date,
    String? description,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final expense = await remoteDataSource.createExpense(
        amount: amount,
        expenseTypeId: expenseTypeId,
        accountId: accountId,
        date: date,
        description: description,
      );
      return Right(expense.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      await remoteDataSource.deleteExpense(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalExpenses({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final result = await getExpenses(startDate: startDate, endDate: endDate);
    return result.fold(
      (failure) => Left(failure),
      (expenses) {
        final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
        return Right(total);
      },
    );
  }
}
