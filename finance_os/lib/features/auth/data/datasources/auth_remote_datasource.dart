import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Remote data source for authentication API calls
abstract class AuthRemoteDataSource {
  /// Login with email and password
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String fullName,
  });

  /// Get current user profile
  Future<UserModel> getCurrentUser(String accessToken);

  /// Logout (invalidate token on server)
  Future<void> logout(String accessToken);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return AuthResponseModel.fromJson(data['data']);
        }
        throw ServerException(
          message: data['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
      throw ServerException(
        message: 'Login failed',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'full_name': fullName,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return AuthResponseModel.fromJson(data['data']);
        }
        throw ServerException(
          message: data['message'] ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }
      throw ServerException(
        message: 'Registration failed',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser(String accessToken) async {
    try {
      final response = await dio.get(
        ApiEndpoints.profile,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return UserModel.fromJson(data['data']);
        }
        throw ServerException(
          message: data['message'] ?? 'Failed to get user',
          statusCode: response.statusCode,
        );
      }
      throw ServerException(
        message: 'Failed to get user',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> logout(String accessToken) async {
    try {
      await dio.post(
        ApiEndpoints.logout,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
    } on DioException catch (e) {
      // Logout failures are non-critical, just log them
      throw _handleDioError(e);
    }
  }

  ServerException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException(
          message: 'Connection timeout. Please try again.',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        String message = 'Server error';
        if (data is Map<String, dynamic>) {
          message = data['message'] ?? data['error']?['message'] ?? message;
        }
        return ServerException(
          message: message,
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return ServerException(
          message: 'No internet connection',
          statusCode: null,
        );
      default:
        return ServerException(
          message: e.message ?? 'Unknown error occurred',
          statusCode: e.response?.statusCode,
        );
    }
  }
}
