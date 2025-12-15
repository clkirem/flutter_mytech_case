import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_mytech_case/core/di/cache_provider.dart';
import 'package:flutter_mytech_case/core/di/core_provider.dart';
import 'package:flutter_mytech_case/features/news/model/news_list_response.dart';
import 'package:flutter_mytech_case/utils/cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mytech_case/core/network/api_response.dart';
import 'package:flutter_mytech_case/core/network/api_service.dart';

const String _kLatestNewsCacheKey = 'latest_news_cache';
const String _kForYouNewsCacheKey = 'for_you_news_cache';

class NewsRepository {
  final ApiService api;
  final CacheManager? cacheManager;

  NewsRepository(this.api, this.cacheManager);

  Future<List<Items>> fetchNews({required bool isLatest, required bool forYou}) async {
    String cacheKey = isLatest ? _kLatestNewsCacheKey : _kForYouNewsCacheKey;

    if (cacheManager != null) {
      final cachedData = await cacheManager!.getCache(cacheKey);

      if (cachedData != null) {
        try {
          final List<Items> newsList = (cachedData as List)
              .map((json) => Items.fromJson(Map<String, dynamic>.from(json)))
              .toList();
          log('CACHE: $cacheKey cache\'den yüklendi. (1 saatlik geçerlilik)');
          return newsList;
        } catch (e) {
          log('CACHE OKUMA HATA: Dönüşüm hatası. API çağrılıyor. Hata: $e');
        }
      }
    }

    try {
      const String path = '/api/v1/news';

      final response = await api.get(path, queryParameters: {'isLatest': isLatest, 'forYou': forYou});

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.result != null) {
        final NewsListResponse newsListResponse = NewsListResponse.fromJson(apiResponse.result!);

        final List<Items> apiItems = newsListResponse.items ?? [];

        final List<Items> newsList = apiItems.map((apiItem) => apiItem).toList();

        await cacheManager!.setCache(cacheKey, newsList.map((e) => e.toJson()).toList());
        log('CACHE: $cacheKey cache\'e kaydedildi. (1 saatlik geçerlilik)');

        return newsList;
      } else {
        throw Exception(apiResponse.message ?? "Sunucudan geçerli bir yanıt alınamadı.");
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Haberler yüklenemedi: $e");
    }
  }
}

final newsRepositoryProvider = Provider((ref) {
  final cacheManagerAsync = ref.watch(cacheManagerProvider);
  final apiService = ref.read(apiServiceProvider);

  final cacheManager = cacheManagerAsync.when(
    data: (manager) => manager,
    loading: () => null,
    error: (err, stack) => null,
  );

  return NewsRepository(apiService, cacheManager);
});
