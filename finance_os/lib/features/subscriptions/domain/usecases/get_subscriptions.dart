import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

@injectable
class GetSubscriptions implements UseCase<List<Subscription>, NoParams> {
  final SubscriptionRepository repository;

  GetSubscriptions(this.repository);

  @override
  Future<Either<Failure, List<Subscription>>> call(NoParams params) {
    return repository.getSubscriptions();
  }
}
