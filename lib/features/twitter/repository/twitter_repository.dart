import 'dart:developer';

import 'package:flutter_mytech_case/core/di/core_provider.dart';
import 'package:flutter_mytech_case/core/network/api_response.dart';
import 'package:flutter_mytech_case/core/network/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/tweet_list_response.dart';

const int PAGE_SIZE_TWITTER = 10;

class TwitterRepository {
  final ApiService api;

  TwitterRepository(this.api);

  Future<TweetListResponse> fetchTweets({required int page, required bool isPopular}) async {
    try {
      const String path = '/api/v1/twitter/tweets';

      final response = await api.get(
        path,
        queryParameters: {'page': page, 'isPopular': isPopular, 'pageSize': PAGE_SIZE_TWITTER},
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.result != null) {
        final tweetListResponse = TweetListResponse.fromJson(apiResponse.result!);
        return tweetListResponse;
      } else {
        throw Exception(apiResponse.message ?? "Sunucudan geçerli bir yanıt alınamadı.");
      }
    } catch (e) {
      log("fetchTweets HATA: $e");
      throw Exception("Tweetler yüklenemedi: ${e.toString()}");
    }
  }
}

final twitterRepositoryProvider = Provider<TwitterRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return TwitterRepository(apiService);
});
