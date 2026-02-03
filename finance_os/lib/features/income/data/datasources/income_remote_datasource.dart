import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/income_model.dart';

abstract class IncomeRemoteDataSource {
  Future<List<IncomeTypeModel>> getIncomeTypes();
  Future<IncomeTypeModel> createIncomeType({
    required String name,
    double targetAmount,
    String? iconName,
    String? color,
  });
  Future<List<IncomeModel>> getIncomes({
    DateTime? startDate,
    DateTime? endDate,
    String? incomeTypeId,
  });
  Future<IncomeModel> createIncome({
    required double amount,
    required String incomeTypeId,
    required String accountId,
    required DateTime date,
    String? description,
  });
  Future<void> deleteIncome(String id);
}

@LazySingleton(as: IncomeRemoteDataSource)
class IncomeRemoteDataSourceImpl implements IncomeRemoteDataSource {
  final Dio dio;

  IncomeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<IncomeTypeModel>> getIncomeTypes() async {
    try {
      final response = await dio.get(ApiEndpoints.incomeTypes);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((e) => IncomeTypeModel.fromJson(e))
              .toList();
        }
      }
      throw ServerException(message: 'Failed to load income types');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<IncomeTypeModel> createIncomeType({
    required String name,
    double targetAmount = 0,
    String? iconName,
    String? color,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.incomeTypes,
        data: {
          'name': name,
          'target_amount': targetAmount,
          if (iconName != null) 'icon_name': iconName,
          if (color != null) 'color': color,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return IncomeTypeModel.fromJson(data['data']);
        }
      }
      throw ServerException(message: 'Failed to create income type');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<List<IncomeModel>> getIncomes({
    DateTime? startDate,
    DateTime? endDate,
    String? incomeTypeId,
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.incomes,
        queryParameters: {
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
          if (incomeTypeId != null) 'income_type_id': incomeTypeId,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((e) => IncomeModel.fromJson(e))
              .toList();
        }
      }
      throw ServerException(message: 'Failed to load incomes');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<IncomeModel> createIncome({
    required double amount,
    required String incomeTypeId,
    required String accountId,
    required DateTime date,
    String? description,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.incomes,
        data: {
          'amount': amount,
          'income_type_id': incomeTypeId,
          'account_id': accountId,
          'date': date.toIso8601String(),
          if (description != null) 'description': description,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return IncomeModel.fromJson(data['data']);
        }
      }
      throw ServerException(message: 'Failed to create income');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<void> deleteIncome(String id) async {
    try {
      final response = await dio.delete('${ApiEndpoints.incomes}/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(message: 'Failed to delete income');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }
}
