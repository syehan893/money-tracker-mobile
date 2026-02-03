import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/dashboard_overview_model.dart';

/// Remote data source for dashboard API calls
abstract class DashboardRemoteDataSource {
  /// Get dashboard overview from API
  Future<DashboardOverviewModel> getDashboardOverview();
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<DashboardOverviewModel> getDashboardOverview() async {
    try {
      final response = await dio.get(ApiEndpoints.dashboardOverview);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return DashboardOverviewModel.fromJson(data['data']);
        }
        throw ServerException(
          message: data['message'] ?? 'Failed to load dashboard',
          statusCode: response.statusCode,
        );
      }
      throw ServerException(
        message: 'Failed to load dashboard',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
