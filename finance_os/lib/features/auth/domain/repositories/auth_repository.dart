import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract repository interface for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  /// Returns [User] on success or [Failure] on error
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register a new user
  /// Returns [User] on success or [Failure] on error
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String fullName,
  });

  /// Logout the current user
  /// Returns void on success or [Failure] on error
  Future<Either<Failure, void>> logout();

  /// Get the currently authenticated user
  /// Returns [User] on success or [Failure] on error
  Future<Either<Failure, User>> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Get the stored access token
  Future<String?> getAccessToken();
}
