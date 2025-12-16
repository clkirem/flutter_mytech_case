import 'package:flutter_mytech_case/features/news/model/news_by_category_response.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_mytech_case/features/news/repository/news_repository.dart';

class CategoryNewsState {
  final String categoryName;

  CategoryNewsState({required this.categoryName});

  CategoryNewsState copyWith({String? categoryName}) {
    return CategoryNewsState(categoryName: categoryName ?? this.categoryName);
  }
}

class CategoryNewsViewModel extends StateNotifier<CategoryNewsState> {
  final NewsRepository _repository;
  //final String _categoryId;

  late final PagingController<int, CategoryNewsItems> pagingController;
  String _currentCategoryId;

  static const int _pageSize = 10;

  CategoryNewsViewModel(this._repository, this._currentCategoryId) : super(CategoryNewsState(categoryName: '')) {
    pagingController = PagingController<int, CategoryNewsItems>(
      getNextPageKey: (state) {
        if (state.lastPageIsEmpty) return null;
        return state.nextIntPageKey;
      },
      fetchPage: (int pageKey) => _fetchPage(pageKey),
    );
  }

  Future<List<CategoryNewsItems>> _fetchPage(int pageKey) async {
    final response = await _repository.getNewsByCategory(
      categoryId: _currentCategoryId,
      page: pageKey,
      pageSize: _pageSize,
    );

    final newItems = response.items ?? [];

    if (pageKey == 1 && newItems.isNotEmpty) {
      state = state.copyWith(categoryName: newItems.first.categoryName ?? '');
    }

    return newItems;
  }

  void changeCategory(String newCategoryId) {
    if (_currentCategoryId == newCategoryId) return; // Aynı kategoriye tıklanırsa işlem yapma.

    // 1. Yeni ID'yi state'e kaydet.
    _currentCategoryId = newCategoryId;

    // 2. Kategori adını geçici olarak sıfırla/yükleniyor yap.
    state = state.copyWith(categoryName: 'Yükleniyor...');

    // 3. PagingController'ı sıfırla/yenile (bu, _fetchPage(1)'i çağırır).
    pagingController.refresh();
  }

  // Getter ile dışarıdan hangi kategorinin seçili olduğunu kontrol edebilmek için ID'yi açığa çıkarıyoruz.
  String get currentCategoryId => _currentCategoryId;

  Future<void> refresh() async {
    pagingController.refresh();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}

final categoryNewsViewModelProvider = StateNotifierProvider.family<CategoryNewsViewModel, CategoryNewsState, String>((
  ref,
  categoryId,
) {
  final repository = ref.watch(newsRepositoryProvider);
  return CategoryNewsViewModel(repository, categoryId);
});
