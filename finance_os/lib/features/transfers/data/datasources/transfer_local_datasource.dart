import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../models/transfer_model.dart';

abstract class TransferLocalDataSource {
  Future<List<TransferModel>> getCachedTransfers();
  Future<void> cacheTransfers(List<TransferModel> transfers);
  Future<void> clearCache();
}

@Injectable(as: TransferLocalDataSource)
class TransferLocalDataSourceImpl implements TransferLocalDataSource {
  static const String _boxName = 'transfers_cache';
  static const String _transfersKey = 'cached_transfers';

  Future<Box> get _box async => await Hive.openBox(_boxName);

  @override
  Future<List<TransferModel>> getCachedTransfers() async {
    final box = await _box;
    final jsonString = box.get(_transfersKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => TransferModel.fromJson(json)).toList();
  }

  @override
  Future<void> cacheTransfers(List<TransferModel> transfers) async {
    final box = await _box;
    final jsonList = transfers.map((t) => t.toJson()).toList();
    await box.put(_transfersKey, json.encode(jsonList));
  }

  @override
  Future<void> clearCache() async {
    final box = await _box;
    await box.delete(_transfersKey);
  }
}
