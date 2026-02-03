import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/account.dart';
import '../models/account_model.dart';

/// Remote data source for account API calls
abstract class AccountRemoteDataSource {
  Future<List<AccountModel>> getAccounts();
  Future<AccountModel> getAccountById(String id);
  Future<AccountModel> createAccount({
    required String name,
    required AccountType type,
    required double balance,
    required String currency,
    String? description,
  });
  Future<AccountModel> updateAccount({
    required String id,
    String? name,
    AccountType? type,
    String? currency,
    String? description,
    bool? isActive,
  });
  Future<void> deleteAccount(String id);
}

@LazySingleton(as: AccountRemoteDataSource)
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final Dio dio;

  AccountRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AccountModel>> getAccounts() async {
    try {
      final response = await dio.get(ApiEndpoints.accounts);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((e) => AccountModel.fromJson(e))
              .toList();
        }
      }
      throw ServerException(message: 'Failed to load accounts');
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<AccountModel> getAccountById(String id) async {
    try {
      final response = await dio.get('${ApiEndpoints.accounts}/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return AccountModel.fromJson(data['data']);
        }
      }
      throw ServerException(message: 'Account not found');
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<AccountModel> createAccount({
    required String name,
    required AccountType type,
    required double balance,
    required String currency,
    String? description,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.accounts,
        data: {
          'name': name,
          'type': type.name,
          'balance': balance,
          'currency': currency,
          if (description != null) 'description': description,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return AccountModel.fromJson(data['data']);
        }
      }
      throw ServerException(message: 'Failed to create account');
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<AccountModel> updateAccount({
    required String id,
    String? name,
    AccountType? type,
    String? currency,
    String? description,
    bool? isActive,
  }) async {
    try {
      final response = await dio.put(
        '${ApiEndpoints.accounts}/$id',
        data: {
          if (name != null) 'name': name,
          if (type != null) 'type': type.name,
          if (currency != null) 'currency': currency,
          if (description != null) 'description': description,
          if (isActive != null) 'is_active': isActive,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return AccountModel.fromJson(data['data']);
        }
      }
      throw ServerException(message: 'Failed to update account');
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> deleteAccount(String id) async {
    try {
      final response = await dio.delete('${ApiEndpoints.accounts}/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(message: 'Failed to delete account');
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
