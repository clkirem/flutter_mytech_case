import 'package:flutter_mytech_case/features/category_news/model/category_response.dart';
import 'package:flutter_mytech_case/features/category_news/repository/category_repostitory.dart';
import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';

class CategoryListState {
  final List<CategoryResponse> categories;
  final bool isLoading;
  final String? errorMessage;

  CategoryListState({required this.categories, this.isLoading = false, this.errorMessage});

  CategoryListState copyWith({List<CategoryResponse>? categories, bool? isLoading, String? errorMessage}) {
    final newErrorMessage = errorMessage == 'clear' ? null : (errorMessage ?? this.errorMessage);

    return CategoryListState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: newErrorMessage,
    );
  }
}

class CategoryListViewModel extends StateNotifier<CategoryListState> {
  final CategoryRepository _repository;

  CategoryListViewModel(this._repository) : super(CategoryListState(categories: []));

  Future<void> fetchCategories() async {
    state = state.copyWith(isLoading: true, errorMessage: 'clear');

    try {
      final categories = await _repository.fetchAllCategories();

      state = state.copyWith(categories: categories, isLoading: false);
    } catch (e) {
      log('Kategori listesi yüklenirken hata: $e');

      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final categoryListViewModelProvider = StateNotifierProvider<CategoryListViewModel, CategoryListState>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryListViewModel(repository);
});
