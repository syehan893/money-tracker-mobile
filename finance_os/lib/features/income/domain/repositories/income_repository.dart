import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/income.dart';

/// Abstract repository interface for income operations
abstract class IncomeRepository {
  /// Get all income types
  Future<Either<Failure, List<IncomeType>>> getIncomeTypes();

  /// Create income type
  Future<Either<Failure, IncomeType>> createIncomeType({
    required String name,
    double targetAmount,
    String? iconName,
    String? color,
  });

  /// Get all income records
  Future<Either<Failure, List<Income>>> getIncomes({
    DateTime? startDate,
    DateTime? endDate,
    String? incomeTypeId,
  });

  /// Create income record
  Future<Either<Failure, Income>> createIncome({
    required double amount,
    required String incomeTypeId,
    required String accountId,
    required DateTime date,
    String? description,
  });

  /// Delete income record
  Future<Either<Failure, void>> deleteIncome(String id);

  /// Get total income for a period
  Future<Either<Failure, double>> getTotalIncome({
    DateTime? startDate,
    DateTime? endDate,
  });
}
