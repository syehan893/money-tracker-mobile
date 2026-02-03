import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/subscription_repository.dart';

@injectable
class DeleteSubscription implements UseCase<void, String> {
  final SubscriptionRepository repository;

  DeleteSubscription(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteSubscription(id);
  }
}
