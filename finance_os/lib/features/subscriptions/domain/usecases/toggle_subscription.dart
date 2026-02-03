import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

@injectable
class ToggleSubscription implements UseCase<Subscription, String> {
  final SubscriptionRepository repository;

  ToggleSubscription(this.repository);

  @override
  Future<Either<Failure, Subscription>> call(String id) {
    return repository.toggleSubscription(id);
  }
}
