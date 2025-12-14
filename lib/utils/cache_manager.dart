import 'package:flutter_mytech_case/core/cacheItem.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  static const String _boxName = "cacheBox";
  final Box _box;
  CacheManager._(this._box);
  static Future<CacheManager> init() async {
    await Hive.initFlutter();
    var box = await Hive.openBox(_boxName);
    return CacheManager._(box);
  }

  Future<void> setCache(String key, dynamic data) async {
    final item = CacheItem(data: data, createdAt: DateTime.now());
    await _box.put(key, item.toMap());
  }

  Future<dynamic> getCache(String key) async {
    final map = _box.get(key);

    if (map == null) return null;

    final item = CacheItem.fromMap(Map<String, dynamic>.from(map));

    final now = DateTime.now();
    final diff = now.difference(item.createdAt);

    if (diff.inHours >= 1) {
      await _box.delete(key);
      return null;
    }

    return item.data;
  }
}
