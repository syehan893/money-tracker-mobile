import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_local_datasource.dart';
import '../datasources/subscription_remote_datasource.dart';

@Injectable(as: SubscriptionRepository)
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource _remoteDataSource;
  final SubscriptionLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  SubscriptionRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<Subscription>>> getSubscriptions() async {
    if (await _networkInfo.isConnected) {
      try {
        final subscriptions = await _remoteDataSource.getSubscriptions();
        await _localDataSource.cacheSubscriptions(subscriptions);
        return Right(subscriptions.map((m) => m.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        final cachedSubscriptions = await _localDataSource.getCachedSubscriptions();
        return Right(cachedSubscriptions.map((m) => m.toEntity()).toList());
      } catch (e) {
        return const Left(CacheFailure(message: 'No cached subscriptions available'));
      }
    }
  }

  @override
  Future<Either<Failure, Subscription>> getSubscriptionById(String id) async {
    try {
      final subscription = await _remoteDataSource.getSubscriptionById(id);
      return Right(subscription.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Subscription>> createSubscription({
    required String name,
    String? description,
    required double amount,
    required BillingCycle billingCycle,
    required DateTime startDate,
    String? category,
    String? logoUrl,
  }) async {
    try {
      final subscription = await _remoteDataSource.createSubscription(
        name: name,
        description: description,
        amount: amount,
        billingCycle: billingCycle,
        startDate: startDate,
        category: category,
        logoUrl: logoUrl,
      );
      return Right(subscription.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Subscription>> updateSubscription({
    required String id,
    String? name,
    String? description,
    double? amount,
    BillingCycle? billingCycle,
    DateTime? startDate,
    String? category,
    String? logoUrl,
    bool? isActive,
  }) async {
    try {
      final subscription = await _remoteDataSource.updateSubscription(
        id: id,
        name: name,
        description: description,
        amount: amount,
        billingCycle: billingCycle,
        startDate: startDate,
        category: category,
        logoUrl: logoUrl,
        isActive: isActive,
      );
      return Right(subscription.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSubscription(String id) async {
    try {
      await _remoteDataSource.deleteSubscription(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Subscription>> toggleSubscription(String id) async {
    try {
      final subscription = await _remoteDataSource.toggleSubscription(id);
      return Right(subscription.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
