import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

@injectable
class UpdateSubscription implements UseCase<Subscription, UpdateSubscriptionParams> {
  final SubscriptionRepository repository;

  UpdateSubscription(this.repository);

  @override
  Future<Either<Failure, Subscription>> call(UpdateSubscriptionParams params) {
    return repository.updateSubscription(
      id: params.id,
      name: params.name,
      description: params.description,
      amount: params.amount,
      billingCycle: params.billingCycle,
      startDate: params.startDate,
      category: params.category,
      logoUrl: params.logoUrl,
      isActive: params.isActive,
    );
  }
}

class UpdateSubscriptionParams extends Equatable {
  final String id;
  final String? name;
  final String? description;
  final double? amount;
  final BillingCycle? billingCycle;
  final DateTime? startDate;
  final String? category;
  final String? logoUrl;
  final bool? isActive;

  const UpdateSubscriptionParams({
    required this.id,
    this.name,
    this.description,
    this.amount,
    this.billingCycle,
    this.startDate,
    this.category,
    this.logoUrl,
    this.isActive,
  });

  @override
  List<Object?> get props => [id, name, description, amount, billingCycle, startDate, category, logoUrl, isActive];
}
