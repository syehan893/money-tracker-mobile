import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/subscription.dart';

/// Abstract repository for subscription operations
abstract class SubscriptionRepository {
  /// Get all subscriptions
  Future<Either<Failure, List<Subscription>>> getSubscriptions();

  /// Get a single subscription by ID
  Future<Either<Failure, Subscription>> getSubscriptionById(String id);

  /// Create a new subscription
  Future<Either<Failure, Subscription>> createSubscription({
    required String name,
    String? description,
    required double amount,
    required BillingCycle billingCycle,
    required DateTime startDate,
    String? category,
    String? logoUrl,
  });

  /// Update an existing subscription
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
  });

  /// Delete a subscription
  Future<Either<Failure, void>> deleteSubscription(String id);

  /// Toggle subscription active status
  Future<Either<Failure, Subscription>> toggleSubscription(String id);
}
