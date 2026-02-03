import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Cache tokens
      await localDataSource.cacheAccessToken(response.accessToken);
      if (response.refreshToken != null) {
        await localDataSource.cacheRefreshToken(response.refreshToken!);
      }

      // Cache user data
      await localDataSource.cacheUser(response.user);

      return Right(response.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await remoteDataSource.register(
        email: email,
        password: password,
        fullName: fullName,
      );

      // Cache tokens
      await localDataSource.cacheAccessToken(response.accessToken);
      if (response.refreshToken != null) {
        await localDataSource.cacheRefreshToken(response.refreshToken!);
      }

      // Cache user data
      await localDataSource.cacheUser(response.user);

      return Right(response.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Try to logout on server (non-critical)
      if (await networkInfo.isConnected) {
        final token = await localDataSource.getAccessToken();
        if (token != null) {
          try {
            await remoteDataSource.logout(token);
          } catch (_) {
            // Server logout failure is non-critical
          }
        }
      }

      // Always clear local auth data
      await localDataSource.clearAuthData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to logout'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // First try to get from cache
      final cachedUser = await localDataSource.getCachedUser();

      // If online, refresh user data
      if (await networkInfo.isConnected) {
        final token = await localDataSource.getAccessToken();
        if (token != null) {
          try {
            final user = await remoteDataSource.getCurrentUser(token);
            await localDataSource.cacheUser(user);
            return Right(user.toEntity());
          } on ServerException catch (e) {
            // If server fails but we have cached data, use it
            if (cachedUser != null) {
              return Right(cachedUser.toEntity());
            }
            return Left(ServerFailure(message: e.message));
          }
        }
      }

      // Return cached user if available
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }

      return Left(CacheFailure(message: 'No cached user found'));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get current user'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await localDataSource.isAuthenticated();
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await localDataSource.getAccessToken();
    } catch (e) {
      return null;
    }
  }
}
