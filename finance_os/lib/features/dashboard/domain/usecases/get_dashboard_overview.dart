import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dashboard_overview.dart';
import '../repositories/dashboard_repository.dart';

/// Use case for getting dashboard overview
class GetDashboardOverview implements UseCase<DashboardOverview, NoParams> {
  final DashboardRepository repository;

  GetDashboardOverview(this.repository);

  @override
  Future<Either<Failure, DashboardOverview>> call(NoParams params) async {
    return await repository.getDashboardOverview();
  }
}
