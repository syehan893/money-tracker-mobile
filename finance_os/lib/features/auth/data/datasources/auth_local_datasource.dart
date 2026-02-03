import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Local data source for caching auth data
abstract class AuthLocalDataSource {
  /// Cache access token securely
  Future<void> cacheAccessToken(String token);

  /// Get cached access token
  Future<String?> getAccessToken();

  /// Cache refresh token securely
  Future<void> cacheRefreshToken(String token);

  /// Get cached refresh token
  Future<String?> getRefreshToken();

  /// Cache user data
  Future<void> cacheUser(UserModel user);

  /// Get cached user
  Future<UserModel?> getCachedUser();

  /// Clear all auth data (logout)
  Future<void> clearAuthData();

  /// Check if user is authenticated (has valid token)
  Future<bool> isAuthenticated();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final Box cacheBox;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _cachedUserKey = 'cached_user';

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.cacheBox,
  });

  @override
  Future<void> cacheAccessToken(String token) async {
    try {
      await secureStorage.write(key: _accessTokenKey, value: token);
    } catch (e) {
      throw CacheException(message: 'Failed to cache access token');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await secureStorage.read(key: _accessTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to read access token');
    }
  }

  @override
  Future<void> cacheRefreshToken(String token) async {
    try {
      await secureStorage.write(key: _refreshTokenKey, value: token);
    } catch (e) {
      throw CacheException(message: 'Failed to cache refresh token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to read refresh token');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await cacheBox.put(_cachedUserKey, userJson);
    } catch (e) {
      throw CacheException(message: 'Failed to cache user');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = cacheBox.get(_cachedUserKey);
      if (userJson != null && userJson is String) {
        final userData = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to read cached user');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await secureStorage.delete(key: _accessTokenKey);
      await secureStorage.delete(key: _refreshTokenKey);
      await cacheBox.delete(_cachedUserKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear auth data');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
