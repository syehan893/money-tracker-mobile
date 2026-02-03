import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/account_model.dart';

/// Local data source for caching accounts
abstract class AccountLocalDataSource {
  Future<void> cacheAccounts(List<AccountModel> accounts);
  Future<List<AccountModel>> getCachedAccounts();
  Future<void> cacheAccount(AccountModel account);
  Future<void> removeAccount(String id);
  Future<void> clearCache();
}

@LazySingleton(as: AccountLocalDataSource)
class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  final Box cacheBox;
  static const String _accountsKey = 'cached_accounts';

  AccountLocalDataSourceImpl({required this.cacheBox});

  @override
  Future<void> cacheAccounts(List<AccountModel> accounts) async {
    try {
      final jsonData = jsonEncode(accounts.map((e) => e.toJson()).toList());
      await cacheBox.put(_accountsKey, jsonData);
    } catch (e) {
      throw CacheException(message: 'Failed to cache accounts');
    }
  }

  @override
  Future<List<AccountModel>> getCachedAccounts() async {
    try {
      final jsonData = cacheBox.get(_accountsKey);
      if (jsonData != null && jsonData is String) {
        final List<dynamic> data = jsonDecode(jsonData);
        return data.map((e) => AccountModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException(message: 'Failed to read cached accounts');
    }
  }

  @override
  Future<void> cacheAccount(AccountModel account) async {
    try {
      final accounts = await getCachedAccounts();
      final index = accounts.indexWhere((a) => a.id == account.id);
      if (index >= 0) {
        accounts[index] = account;
      } else {
        accounts.add(account);
      }
      await cacheAccounts(accounts);
    } catch (e) {
      throw CacheException(message: 'Failed to cache account');
    }
  }

  @override
  Future<void> removeAccount(String id) async {
    try {
      final accounts = await getCachedAccounts();
      accounts.removeWhere((a) => a.id == id);
      await cacheAccounts(accounts);
    } catch (e) {
      throw CacheException(message: 'Failed to remove account from cache');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await cacheBox.delete(_accountsKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear accounts cache');
    }
  }
}
