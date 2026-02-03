import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/expense.dart';

/// Abstract repository interface for expense operations
abstract class ExpenseRepository {
  /// Get all expense types (budgets)
  Future<Either<Failure, List<ExpenseType>>> getExpenseTypes();

  /// Create expense type (budget)
  Future<Either<Failure, ExpenseType>> createExpenseType({
    required String name,
    double budgetAmount,
    String? iconName,
    String? color,
  });

  /// Update expense type budget
  Future<Either<Failure, ExpenseType>> updateExpenseType({
    required String id,
    String? name,
    double? budgetAmount,
    String? iconName,
    String? color,
  });

  /// Get all expense records
  Future<Either<Failure, List<Expense>>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? expenseTypeId,
  });

  /// Create expense record
  Future<Either<Failure, Expense>> createExpense({
    required double amount,
    required String expenseTypeId,
    required String accountId,
    required DateTime date,
    String? description,
  });

  /// Delete expense record
  Future<Either<Failure, void>> deleteExpense(String id);

  /// Get total expenses for a period
  Future<Either<Failure, double>> getTotalExpenses({
    DateTime? startDate,
    DateTime? endDate,
  });
}
