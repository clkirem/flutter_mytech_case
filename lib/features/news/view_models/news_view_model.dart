import 'dart:developer';

import 'package:flutter/material.dart';
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
  final String? userMessage;
  final Color? snackBarColor;

  NewsState({
    required this.latestNews,
    required this.forYouNews,
    this.isLoading = false,
    this.errorMessage,
    required this.groupedNews,
    this.userMessage,
    this.snackBarColor,
  });

  factory NewsState.initial() =>
      NewsState(latestNews: [], forYouNews: [], isLoading: false, errorMessage: null, groupedNews: []);

  NewsState copyWith({
    List<Items>? latestNews,
    List<Items>? forYouNews,
    bool? isLoading,
    String? errorMessage,
    List<NewsCategoryModel>? groupedNews,
    String? userMessage,
    Color? snackBarColor,
  }) {
    final newErrorMessage = errorMessage == 'clear' ? null : (errorMessage ?? this.errorMessage);

    return NewsState(
      groupedNews: groupedNews ?? this.groupedNews,
      latestNews: latestNews ?? this.latestNews,
      forYouNews: forYouNews ?? this.forYouNews,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: newErrorMessage,
      userMessage: userMessage,
      snackBarColor: snackBarColor,
    );
  }
}

const int _categoryItemLimit = 10;

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

  Future<void> toggleSaveNews(dynamic item) async {
    final newsId = item.id;
    if (newsId == null) return;

    try {
      if (item.isSaved == true) {
        final response = await _repository.deleteSavedNews(newsId);

        if (response == true) {
          _updateNewsItemSavedState(newsId, false);
          state = state.copyWith(userMessage: "Haber kaydı silindi", snackBarColor: Colors.redAccent);
        }
      } else {
        final data = {"newsId": newsId};
        final response = await _repository.saveNew(data);

        if (response != null && response['success'] == true) {
          _updateNewsItemSavedState(newsId, true);
          state = state.copyWith(userMessage: "Haber kaydedildi", snackBarColor: Colors.green);
        }
      }
    } catch (e) {
      log("Toggle save error: $e");
      state = state.copyWith(errorMessage: e.toString());
      state = state.copyWith(errorMessage: e.toString(), snackBarColor: Colors.green);
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
