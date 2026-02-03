import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

@injectable
class CreateSubscription implements UseCase<Subscription, CreateSubscriptionParams> {
  final SubscriptionRepository repository;

  CreateSubscription(this.repository);

  @override
  Future<Either<Failure, Subscription>> call(CreateSubscriptionParams params) {
    return repository.createSubscription(
      name: params.name,
      description: params.description,
      amount: params.amount,
      billingCycle: params.billingCycle,
      startDate: params.startDate,
      category: params.category,
      logoUrl: params.logoUrl,
    );
  }
}

class CreateSubscriptionParams extends Equatable {
  final String name;
  final String? description;
  final double amount;
  final BillingCycle billingCycle;
  final DateTime startDate;
  final String? category;
  final String? logoUrl;

  const CreateSubscriptionParams({
    required this.name,
    this.description,
    required this.amount,
    required this.billingCycle,
    required this.startDate,
    this.category,
    this.logoUrl,
  });

  @override
  List<Object?> get props => [name, description, amount, billingCycle, startDate, category, logoUrl];
}
