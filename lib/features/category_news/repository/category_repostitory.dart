import 'package:flutter_mytech_case/core/di/core_provider.dart';
import 'package:flutter_mytech_case/core/network/api_service.dart';
import 'package:flutter_mytech_case/features/category_news/model/category_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryRepository {
  final ApiService api;

  CategoryRepository(this.api);

  Future<List<CategoryResponse>> fetchAllCategories() async {
    const String path = '/api/v1/categories';

    try {
      final response = await api.get(path);
      final apiResponse = response.data;

      if (apiResponse != null && apiResponse['success'] == true) {
        final List<dynamic> resultList = apiResponse['result'] as List<dynamic>;
        return resultList.map((json) => CategoryResponse.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception(apiResponse['message'] ?? "Kategori listesi alınamadı.");
      }
    } catch (e) {
      throw Exception("Tüm kategoriler yüklenemedi: $e");
    }
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return CategoryRepository(apiService);
});
