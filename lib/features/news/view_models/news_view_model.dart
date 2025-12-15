import 'dart:developer';

import 'package:flutter_mytech_case/core/constants.dart';
import 'package:flutter_mytech_case/features/news/model/news_category_model.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../repository/news_repository.dart';
import '../model/news_list_response.dart';

class NewsState {
  final List<Items> latestNews;

  final List<Items> forYouNews;

  final bool isLoading;
  final String? errorMessage;
  final List<NewsCategoryModel> groupedNews;

  NewsState({
    required this.latestNews,
    required this.forYouNews,
    this.isLoading = false,
    this.errorMessage,
    required this.groupedNews,
  });

  factory NewsState.initial() =>
      NewsState(latestNews: [], forYouNews: [], isLoading: false, errorMessage: null, groupedNews: []);

  NewsState copyWith({
    List<Items>? latestNews,
    List<Items>? forYouNews,
    bool? isLoading,
    String? errorMessage,
    List<NewsCategoryModel>? groupedNews,
  }) {
    final newErrorMessage = errorMessage == 'clear' ? null : (errorMessage ?? this.errorMessage);

    return NewsState(
      groupedNews: groupedNews ?? this.groupedNews,
      latestNews: latestNews ?? this.latestNews,
      forYouNews: forYouNews ?? this.forYouNews,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: newErrorMessage,
    );
  }
}

const int _categoryItemLimit = 2;

class NewsViewModel extends StateNotifier<NewsState> {
  final NewsRepository _repository;

  NewsViewModel(this._repository) : super(NewsState.initial());

  Future<void> fetchPopularNews(int categoryIndex) async {
    state = state.copyWith(isLoading: true, errorMessage: 'clear');

    try {
      if (categoryIndex == PageConstants.latestNewsIndex) {
        final latest = await _repository.fetchNews(isLatest: true, forYou: false);

        state = state.copyWith(latestNews: latest, isLoading: false);
      } else if (categoryIndex == PageConstants.forYouNewsIndex) {
        final forYou = await _repository.fetchNews(isLatest: false, forYou: true);

        state = state.copyWith(forYouNews: forYou, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchCategorizedNews() async {
    state = state.copyWith(isLoading: true, errorMessage: 'clear');

    try {
      final List<Items> allNewsItems = await _repository.fetchNews(isLatest: true, forYou: true);

      final groupedAndLimitedNews = _groupAndLimitNews(allNewsItems);

      state = state.copyWith(groupedNews: groupedAndLimitedNews, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  List<NewsCategoryModel> _groupAndLimitNews(List<Items> items) {
    if (items.isEmpty) return [];

    final Map<String, List<Items>> groupedMap = {};

    for (var item in items) {
      final categoryId = item.categoryId ?? 'default';

      if (!groupedMap.containsKey(categoryId)) {
        groupedMap[categoryId] = [];
      }

      if (groupedMap[categoryId]!.length < _categoryItemLimit) {
        groupedMap[categoryId]!.add(item);
      }
    }

    return groupedMap.entries.map((entry) {
      final categoryName = entry.value.first.categoryName ?? '';
      return NewsCategoryModel(categoryId: entry.key, categoryName: categoryName, items: entry.value);
    }).toList();
  }

  Future<void> saveNews(String newsId) async {
    try {
      final data = {"newsId": newsId};

      final response = await _repository.saveNew(data);

      if (response != null && response['success'] == true) {
        _updateNewsItemSavedState(newsId, true);
      } else {
        throw Exception(response?['message'] ?? 'Kaydetme başarısız');
      }
    } catch (e) {
      log("Save news error: $e");
    }
  }

  void _updateNewsItemSavedState(String newsId, bool isSaved) {
    final updatedGroupedNews = state.groupedNews.map((group) {
      final updatedItems = group.items?.map((item) {
        if (item.id == newsId) {
          return item.copyWith(isSaved: isSaved);
        }
        return item;
      }).toList();

      return group.copyWith(items: updatedItems);
    }).toList();

    state = state.copyWith(groupedNews: updatedGroupedNews);
  }
}

final newsViewModelProvider = StateNotifierProvider<NewsViewModel, NewsState>((ref) {
  final repository = ref.read(newsRepositoryProvider);
  return NewsViewModel(repository);
});
