import 'package:flutter_mytech_case/core/constants.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../repository/news_repository.dart';
import '../model/news_list_response.dart';

class NewsState {
  final List<Items> latestNews;

  final List<Items> forYouNews;

  final bool isLoading;
  final String? errorMessage;

  NewsState({required this.latestNews, required this.forYouNews, this.isLoading = false, this.errorMessage});

  factory NewsState.initial() => NewsState(latestNews: [], forYouNews: [], isLoading: false, errorMessage: null);

  NewsState copyWith({List<Items>? latestNews, List<Items>? forYouNews, bool? isLoading, String? errorMessage}) {
    final newErrorMessage = errorMessage == 'clear' ? null : (errorMessage ?? this.errorMessage);

    return NewsState(
      latestNews: latestNews ?? this.latestNews,
      forYouNews: forYouNews ?? this.forYouNews,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: newErrorMessage,
    );
  }
}

class NewsViewModel extends StateNotifier<NewsState> {
  final NewsRepository _repository;

  NewsViewModel(this._repository) : super(NewsState.initial());

  Future<void> fetchAllNews() async {
    state = state.copyWith(isLoading: true, errorMessage: 'clear');

    try {
      final latestNewsFuture = _repository.fetchNews(isLatest: true, forYou: false);

      final forYouNewsFuture = _repository.fetchNews(isLatest: false, forYou: true);

      final results = await Future.wait([latestNewsFuture, forYouNewsFuture]);

      state = state.copyWith(latestNews: results[0], forYouNews: results[1], isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString().replaceFirst('Exception: ', 'Hata: '));
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Bilinmeyen bir hata oluştu: $e');
    }
  }

  Future<void> fetchByCategory(int categoryIndex) async {
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

  List<Items> getPopularNews(List<Items> source) {
    return source.where((item) => item.isPopular!).toList();
  }
}

final newsViewModelProvider = StateNotifierProvider<NewsViewModel, NewsState>((ref) {
  final repository = ref.read(newsRepositoryProvider);
  return NewsViewModel(repository);
});
