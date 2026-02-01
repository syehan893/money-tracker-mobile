import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/api_endpoints.dart';
import 'auth_interceptor.dart';

@lazySingleton
class ApiClient {
  final Dio dio;
  final AuthInterceptor authInterceptor;

  ApiClient(this.dio, this.authInterceptor) {
    dio.options.baseUrl = ApiEndpoints.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}
