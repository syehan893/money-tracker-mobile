import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/account.dart';

/// Abstract repository interface for account operations
abstract class AccountRepository {
  /// Get all accounts
  Future<Either<Failure, List<Account>>> getAccounts();

  /// Get account by ID
  Future<Either<Failure, Account>> getAccountById(String id);

  /// Create a new account
  Future<Either<Failure, Account>> createAccount({
    required String name,
    required AccountType type,
    required double balance,
    required String currency,
    String? description,
  });

  /// Update an existing account
  Future<Either<Failure, Account>> updateAccount({
    required String id,
    String? name,
    AccountType? type,
    String? currency,
    String? description,
    bool? isActive,
  });

  /// Delete an account
  Future<Either<Failure, void>> deleteAccount(String id);

  /// Get total balance across all accounts
  Future<Either<Failure, double>> getTotalBalance();
}
