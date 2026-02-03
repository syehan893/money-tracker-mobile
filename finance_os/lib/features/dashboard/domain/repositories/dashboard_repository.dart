import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dashboard_overview.dart';

/// Abstract repository interface for dashboard operations
abstract class DashboardRepository {
  /// Get dashboard overview data
  Future<Either<Failure, DashboardOverview>> getDashboardOverview();

  /// Refresh dashboard data
  Future<Either<Failure, DashboardOverview>> refreshDashboard();
}
