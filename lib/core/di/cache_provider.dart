import 'package:flutter_mytech_case/utils/cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cacheManagerProvider = FutureProvider<CacheManager>((ref) async {
  return CacheManager.init();
});
