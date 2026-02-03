import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/subscription.dart';
import '../models/subscription_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<SubscriptionModel>> getSubscriptions();
  Future<SubscriptionModel> getSubscriptionById(String id);
  Future<SubscriptionModel> createSubscription({
    required String name,
    String? description,
    required double amount,
    required BillingCycle billingCycle,
    required DateTime startDate,
    String? category,
    String? logoUrl,
  });
  Future<SubscriptionModel> updateSubscription({
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
  Future<void> deleteSubscription(String id);
  Future<SubscriptionModel> toggleSubscription(String id);
}

@Injectable(as: SubscriptionRemoteDataSource)
class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final Dio _dio;

  SubscriptionRemoteDataSourceImpl(this._dio);

  @override
  Future<List<SubscriptionModel>> getSubscriptions() async {
    try {
      final response = await _dio.get(ApiEndpoints.subscriptions);
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => SubscriptionModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch subscriptions',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<SubscriptionModel> getSubscriptionById(String id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.subscriptions}/$id');
      return SubscriptionModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch subscription',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<SubscriptionModel> createSubscription({
    required String name,
    String? description,
    required double amount,
    required BillingCycle billingCycle,
    required DateTime startDate,
    String? category,
    String? logoUrl,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.subscriptions,
        data: {
          'name': name,
          if (description != null) 'description': description,
          'amount': amount,
          'billing_cycle': SubscriptionModel.billingCycleToString(billingCycle),
          'start_date': startDate.toIso8601String(),
          if (category != null) 'category': category,
          if (logoUrl != null) 'logo_url': logoUrl,
        },
      );
      return SubscriptionModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to create subscription',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<SubscriptionModel> updateSubscription({
    required String id,
    String? name,
    String? description,
    double? amount,
    BillingCycle? billingCycle,
    DateTime? startDate,
    String? category,
    String? logoUrl,
    bool? isActive,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiEndpoints.subscriptions}/$id',
        data: {
          if (name != null) 'name': name,
          if (description != null) 'description': description,
          if (amount != null) 'amount': amount,
          if (billingCycle != null)
            'billing_cycle': SubscriptionModel.billingCycleToString(billingCycle),
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (category != null) 'category': category,
          if (logoUrl != null) 'logo_url': logoUrl,
          if (isActive != null) 'is_active': isActive,
        },
      );
      return SubscriptionModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to update subscription',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> deleteSubscription(String id) async {
    try {
      await _dio.delete('${ApiEndpoints.subscriptions}/$id');
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to delete subscription',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<SubscriptionModel> toggleSubscription(String id) async {
    try {
      final response = await _dio.patch('${ApiEndpoints.subscriptions}/$id/toggle');
      return SubscriptionModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to toggle subscription',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
