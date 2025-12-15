import 'package:flutter_mytech_case/features/twitter/model/tweet_list_response.dart';
import 'package:flutter_mytech_case/features/twitter/repository/twitter_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class TwitterPagingState {
  final PagingController<int, TweetModel> popular;
  final PagingController<int, TweetModel> forYou;

  TwitterPagingState({required this.popular, required this.forYou});
}

class TwitterViewModel extends Notifier<TwitterPagingState> {
  @override
  TwitterPagingState build() {
    final repository = ref.read(twitterRepositoryProvider);

    final popular = PagingController<int, TweetModel>(
      fetchPage: (pageKey) async {
        final response = await repository.fetchTweets(page: pageKey, isPopular: true);
        return response.items;
      },
      getNextPageKey: (state) {
        if (state.lastPageIsEmpty) return null;
        return state.nextIntPageKey;
      },
    );

    final forYou = PagingController<int, TweetModel>(
      fetchPage: (pageKey) async {
        final response = await repository.fetchTweets(page: pageKey, isPopular: false);
        return response.items;
      },
      getNextPageKey: (state) {
        if (state.lastPageIsEmpty) return null;
        return state.nextIntPageKey;
      },
    );

    ref.onDispose(() {
      popular.dispose();
      forYou.dispose();
    });

    return TwitterPagingState(popular: popular, forYou: forYou);
  }
}

final twitterViewModelProvider = NotifierProvider<TwitterViewModel, TwitterPagingState>(TwitterViewModel.new);
