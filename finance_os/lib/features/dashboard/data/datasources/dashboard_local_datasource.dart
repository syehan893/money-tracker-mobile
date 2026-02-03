import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/dashboard_overview_model.dart';

/// Local data source for caching dashboard data
abstract class DashboardLocalDataSource {
  /// Cache dashboard overview
  Future<void> cacheDashboardOverview(DashboardOverviewModel overview);

  /// Get cached dashboard overview
  Future<DashboardOverviewModel?> getCachedDashboardOverview();

  /// Clear cached dashboard
  Future<void> clearCache();
}

@LazySingleton(as: DashboardLocalDataSource)
class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final Box cacheBox;
  static const String _dashboardKey = 'cached_dashboard';

  DashboardLocalDataSourceImpl({required this.cacheBox});

  @override
  Future<void> cacheDashboardOverview(DashboardOverviewModel overview) async {
    try {
      final jsonData = jsonEncode(overview.toJson());
      await cacheBox.put(_dashboardKey, jsonData);
    } catch (e) {
      throw CacheException(message: 'Failed to cache dashboard');
    }
  }

  @override
  Future<DashboardOverviewModel?> getCachedDashboardOverview() async {
    try {
      final jsonData = cacheBox.get(_dashboardKey);
      if (jsonData != null && jsonData is String) {
        final data = jsonDecode(jsonData) as Map<String, dynamic>;
        return DashboardOverviewModel.fromJson(data);
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to read cached dashboard');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await cacheBox.delete(_dashboardKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear dashboard cache');
    }
  }
}
