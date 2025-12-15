import 'package:dio/dio.dart';
import 'package:flutter_mytech_case/core/di/core_provider.dart';
import 'package:flutter_mytech_case/core/network/api_response.dart';
import 'package:flutter_mytech_case/core/network/api_service.dart';
import 'package:flutter_mytech_case/features/news_source/model/source_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SourceRepository {
  final ApiService api;

  SourceRepository(this.api);

  Future<List<Sources>> fetchAllSources() async {
    try {
      const String path = '/api/v1/sources';

      final response = await api.get(path);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.result != null) {
        final sourceListResponse = SourceListResponse.fromJson(apiResponse.result!);

        return sourceListResponse.sources ?? [];
      } else {
        throw Exception(apiResponse.message ?? "Sunucudan geçerli bir kaynak listesi yanıtı alınamadı.");
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Kaynaklar yüklenemedi: $e");
    }
  }

  Future<List<Sources>> searchSources(String search) async {
    try {
      const String path = '/api/v1/sources/search';

      final response = await api.get(path, queryParameters: {'search': search});

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.result != null) {
        final sourceListResponse = SourceListResponse.fromJson(apiResponse.result!);
        return sourceListResponse.sources ?? [];
      } else {
        throw Exception(apiResponse.message ?? "Sunucudan geçerli bir arama yanıtı alınamadı.");
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? e.message;
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Kaynaklar aranırken bir hata oluştu: $e");
    }
  }

  Future<void> followBulk(List<Map<String, dynamic>> followChanges) async {
    try {
      const String path = '/api/v1/sources/follow/bulk';

      final response = await api.post(path, data: followChanges);

      if (response.statusCode != 200) {
        throw Exception('Takip durumunu kaydetme başarısız oldu. Hata Kodu: ${response.statusCode}');
      }

      print("Takip durumu başarıyla kaydedildi.");
    } catch (e) {
      print("syncFollowState HATA: $e");
      rethrow;
    }
  }
}

final sourceRepositoryProvider = Provider((ref) {
  final apiService = ref.read(apiServiceProvider);
  return SourceRepository(apiService);
});
