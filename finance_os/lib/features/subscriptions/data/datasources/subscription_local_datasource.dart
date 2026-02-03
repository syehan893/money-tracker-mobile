import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../models/subscription_model.dart';

abstract class SubscriptionLocalDataSource {
  Future<List<SubscriptionModel>> getCachedSubscriptions();
  Future<void> cacheSubscriptions(List<SubscriptionModel> subscriptions);
  Future<void> clearCache();
}

@Injectable(as: SubscriptionLocalDataSource)
class SubscriptionLocalDataSourceImpl implements SubscriptionLocalDataSource {
  static const String _boxName = 'subscriptions_cache';
  static const String _subscriptionsKey = 'cached_subscriptions';

  Future<Box> get _box async => await Hive.openBox(_boxName);

  @override
  Future<List<SubscriptionModel>> getCachedSubscriptions() async {
    final box = await _box;
    final jsonString = box.get(_subscriptionsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => SubscriptionModel.fromJson(json)).toList();
  }

  @override
  Future<void> cacheSubscriptions(List<SubscriptionModel> subscriptions) async {
    final box = await _box;
    final jsonList = subscriptions.map((s) => s.toJson()).toList();
    await box.put(_subscriptionsKey, json.encode(jsonList));
  }

  @override
  Future<void> clearCache() async {
    final box = await _box;
    await box.delete(_subscriptionsKey);
  }
}
