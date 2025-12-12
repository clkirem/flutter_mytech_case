import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  final Box _box;
  CacheManager._(this._box);

  static Future<CacheManager> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox('cacheBox');
    return CacheManager._(box);
  }

  Future<void> put(String key, dynamic value) async {
    final item = {'timestamp': DateTime.now().millisecondsSinceEpoch, 'value': value};
    await _box.put(key, item);
  }

  Future<List<dynamic>?> getIfValid(String key, {required int maxAgeSeconds}) async {
    final item = _box.get(key);
    if (item == null) return null;
    final ts = item['timestamp'] as int;
    final age = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(ts)).inSeconds;
    if (age > maxAgeSeconds) {
      await _box.delete(key);
      return null;
    }
    return List<dynamic>.from(item['value']);
  }
}
