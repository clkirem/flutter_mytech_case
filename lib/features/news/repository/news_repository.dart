import '../../../core/network/api_service.dart';
import '../../../utils/cache_manager.dart';

class NewsRepository {
  final ApiService api;
  final CacheManager cache;

  NewsRepository(this.api, this.cache);

  Future<List<dynamic>> getPopularNews({int page = 1, int pageSize = 10}) async {
    // cache key
    final cacheKey = 'popular_page_$page';
    final cached = await cache.getIfValid(cacheKey, maxAgeSeconds: 3600); // 1 hour
    if (cached != null) return cached;

    final res = await api.get('/news/popular', queryParameters: {'page': page, 'pageSize': pageSize, 'isLatest': true});
    final list = res.data['data'] as List<dynamic>;
    await cache.put(cacheKey, list);
    return list;
  }

  Future<List<dynamic>> getCategoryNews(String category, {int page = 1, int pageSize = 10}) async {
    final res = await api.get('/news', queryParameters: {'category': category, 'page': page, 'pageSize': pageSize});
    return res.data['data'] as List<dynamic>;
  }
}
