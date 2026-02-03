import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/transfer_model.dart';

abstract class TransferRemoteDataSource {
  Future<List<TransferModel>> getTransfers({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<TransferModel> getTransferById(String id);
  Future<TransferModel> createTransfer({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    required DateTime date,
    String? description,
  });
  Future<void> deleteTransfer(String id);
}

@Injectable(as: TransferRemoteDataSource)
class TransferRemoteDataSourceImpl implements TransferRemoteDataSource {
  final Dio _dio;

  TransferRemoteDataSourceImpl(this._dio);

  @override
  Future<List<TransferModel>> getTransfers({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        ApiEndpoints.transfers,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => TransferModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch transfers',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<TransferModel> getTransferById(String id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.transfers}/$id');
      return TransferModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch transfer',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<TransferModel> createTransfer({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    required DateTime date,
    String? description,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.transfers,
        data: {
          'from_account_id': fromAccountId,
          'to_account_id': toAccountId,
          'amount': amount,
          'date': date.toIso8601String(),
          if (description != null) 'description': description,
        },
      );
      return TransferModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to create transfer',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> deleteTransfer(String id) async {
    try {
      await _dio.delete('${ApiEndpoints.transfers}/$id');
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to delete transfer',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
