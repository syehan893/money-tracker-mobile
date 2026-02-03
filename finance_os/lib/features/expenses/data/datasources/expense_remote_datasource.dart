import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<ExpenseTypeModel>> getExpenseTypes();
  Future<ExpenseTypeModel> createExpenseType({
    required String name,
    double budgetAmount,
    String? iconName,
    String? color,
  });
  Future<List<ExpenseModel>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? expenseTypeId,
  });
  Future<ExpenseModel> createExpense({
    required double amount,
    required String expenseTypeId,
    required String accountId,
    required DateTime date,
    String? description,
  });
  Future<void> deleteExpense(String id);
}

@LazySingleton(as: ExpenseRemoteDataSource)
class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final Dio dio;

  ExpenseRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ExpenseTypeModel>> getExpenseTypes() async {
    try {
      final response = await dio.get(ApiEndpoints.expenseTypes);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((e) => ExpenseTypeModel.fromJson(e))
              .toList();
        }
      }
      throw ServerException(message: 'Failed to load expense types');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<ExpenseTypeModel> createExpenseType({
    required String name,
    double budgetAmount = 0,
    String? iconName,
    String? color,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.expenseTypes,
        data: {
          'name': name,
          'budget_amount': budgetAmount,
          if (iconName != null) 'icon_name': iconName,
          if (color != null) 'color': color,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return ExpenseTypeModel.fromJson(data['data']);
        }
      }
      throw ServerException(message: 'Failed to create expense type');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<List<ExpenseModel>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? expenseTypeId,
  }) async {
    try {
      final response = await dio.get(
        ApiEndpoints.expenses,
        queryParameters: {
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
          if (expenseTypeId != null) 'expense_type_id': expenseTypeId,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((e) => ExpenseModel.fromJson(e))
              .toList();
        }
      }
      throw ServerException(message: 'Failed to load expenses');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<ExpenseModel> createExpense({
    required double amount,
    required String expenseTypeId,
    required String accountId,
    required DateTime date,
    String? description,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.expenses,
        data: {
          'amount': amount,
          'expense_type_id': expenseTypeId,
          'account_id': accountId,
          'date': date.toIso8601String(),
          if (description != null) 'description': description,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return ExpenseModel.fromJson(data['data']);
        }
      }
      throw ServerException(message: 'Failed to create expense');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      final response = await dio.delete('${ApiEndpoints.expenses}/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(message: 'Failed to delete expense');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }
}
