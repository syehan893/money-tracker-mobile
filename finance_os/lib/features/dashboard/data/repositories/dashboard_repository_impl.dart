import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_datasource.dart';
import '../datasources/dashboard_remote_datasource.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final DashboardLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DashboardOverview>> getDashboardOverview() async {
    try {
      // Try to get from cache first
      final cachedOverview = await localDataSource.getCachedDashboardOverview();

      if (await networkInfo.isConnected) {
        try {
          final overview = await remoteDataSource.getDashboardOverview();
          await localDataSource.cacheDashboardOverview(overview);
          return Right(overview.toEntity());
        } on ServerException catch (e) {
          // If server fails but we have cached data, return it
          if (cachedOverview != null) {
            return Right(cachedOverview.toEntity());
          }
          return Left(ServerFailure(message: e.message));
        }
      } else {
        // Offline - return cached data if available
        if (cachedOverview != null) {
          return Right(cachedOverview.toEntity());
        }
        return Left(NetworkFailure(message: 'No internet connection'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, DashboardOverview>> refreshDashboard() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final overview = await remoteDataSource.getDashboardOverview();
      await localDataSource.cacheDashboardOverview(overview);
      return Right(overview.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to refresh dashboard'));
    }
  }
}
