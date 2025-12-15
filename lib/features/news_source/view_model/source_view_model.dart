import 'dart:developer';

import 'package:flutter_mytech_case/features/news_source/model/source_category_model.dart';
import 'package:flutter_mytech_case/features/news_source/model/source_response.dart';
import 'package:flutter_mytech_case/features/news_source/repository/source_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SourceListNotifier extends AsyncNotifier<List<SourceCategoryModel>> {
  @override
  Future<List<SourceCategoryModel>> build() {
    return _fetchAndGroupSources();
  }

  List<SourceCategoryModel> _groupSources(List<Sources> allSources) {
    final Map<String, List<Sources>> groupedMap = {};

    for (var source in allSources) {
      final categoryTitle = source.sourceCategoryTitle ?? '';
      if (!groupedMap.containsKey(categoryTitle)) {
        groupedMap[categoryTitle] = [];
      }
      groupedMap[categoryTitle]!.add(source);
    }

    final List<SourceCategoryModel> categorizedList = groupedMap.entries.map((entry) {
      final categoryId = entry.value.isNotEmpty ? entry.value.first.sourceCategoryId : null;

      return SourceCategoryModel(sourceCategoryId: categoryId, sourceCategoryTitle: entry.key, sources: entry.value);
    }).toList();

    return categorizedList;
  }

  Future<List<SourceCategoryModel>> _fetchAndGroupSources() async {
    final sourceRepository = ref.read(sourceRepositoryProvider);

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final List<Sources> allSources = await sourceRepository.fetchAllSources();

      final Map<String, List<Sources>> groupedMap = {};

      for (var source in allSources) {
        final categoryTitle = source.sourceCategoryTitle ?? '';
        if (!groupedMap.containsKey(categoryTitle)) {
          groupedMap[categoryTitle] = [];
        }
        groupedMap[categoryTitle]!.add(source);
      }

      final List<SourceCategoryModel> categorizedList = groupedMap.entries.map((entry) {
        final categoryId = entry.value.first.sourceCategoryId;

        return SourceCategoryModel(sourceCategoryId: categoryId, sourceCategoryTitle: entry.key, sources: entry.value);
      }).toList();

      return categorizedList;
    });

    return state.value ?? [];
  }

  void performSearch(String query) async {
    final sourceRepository = ref.read(sourceRepositoryProvider);
    if (query.isEmpty) {
      await _fetchAndGroupSources();
      return;
    }
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final List<Sources> searchResults = await sourceRepository.searchSources(query);
      return _groupSources(searchResults);
    });
  }

  void toggleFollowSource(String sourceId, bool isFollowing) {
    final currentCategories = state.value;
    if (currentCategories == null) return;

    final updatedCategories = currentCategories.map((category) {
      final updatedSources = category.sources?.map((source) {
        if (source.id == sourceId) {
          return Sources(
            id: source.id,
            name: source.name,
            description: source.description,
            imageUrl: source.imageUrl,
            sourceCategoryId: source.sourceCategoryId,
            sourceCategoryTitle: source.sourceCategoryTitle,
            isFollowed: isFollowing,
          );
        }
        return source;
      }).toList();

      return SourceCategoryModel(
        sourceCategoryId: category.sourceCategoryId,
        sourceCategoryTitle: category.sourceCategoryTitle,
        sources: updatedSources,
      );
    }).toList();

    state = AsyncValue.data(updatedCategories);
    log('Kaynak $sourceId takip durumu $isFollowing olarak güncellendi.');
  }

  Future<void> saveFollowedSources() async {
    final sourceRepository = ref.read(sourceRepositoryProvider);

    final allSources = state.value?.expand((category) => category.sources ?? []).toList() ?? [];

    final followChanges = allSources
        .map((source) {
          return {'sourceId': source.id, 'isFollowed': source.isFollowed};
        })
        .where((e) => e['sourceId'] != null)
        .toList();

    if (followChanges.isEmpty) {
      log("Kaydedilecek kaynak bulunamadı.");
      return;
    }
    try {
      await sourceRepository.followBulk(followChanges);
    } catch (e) {
      log('Kaydetme sırasında bir hata oluştu: $e');
      rethrow;
    }
  }
}

final sourceListProvider = AsyncNotifierProvider<SourceListNotifier, List<SourceCategoryModel>>(() {
  return SourceListNotifier();
});
