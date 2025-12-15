import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:flutter_mytech_case/core/constants.dart';
import 'package:flutter_mytech_case/features/twitter/model/tweet_list_response.dart';
import 'package:flutter_mytech_case/features/twitter/view_model/twitter_view_model.dart';

final twitterFeedTabIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class TwitterFeedTab extends ConsumerStatefulWidget {
  const TwitterFeedTab({super.key});

  @override
  ConsumerState<TwitterFeedTab> createState() => _TwitterFeedTabState();
}

class _TwitterFeedTabState extends ConsumerState<TwitterFeedTab> {
  final Color twitterBlue = const Color(0xFF1DA1F2);
  final List<String> twitterFeedTabs = const ['Popüler', 'Sana Özel'];

  void _onTwitterFeedTabTapped(int index) {
    ref.read(twitterFeedTabIndexProvider.notifier).state = index;
    final pagingState = ref.read(twitterViewModelProvider);
    final controller = index == 0 ? pagingState.popular : pagingState.forYou;

    if (controller.items == null || controller.items!.isEmpty) {
      controller.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(twitterFeedTabIndexProvider);

    return Column(
      children: [
        _buildTwitterFeedCategories(selectedIndex),

        Expanded(child: _buildTwitterPagedList(ref, selectedIndex)),
      ],
    );
  }

  Widget _buildTwitterPagedList(WidgetRef ref, int selectedIndex) {
    final pagingState = ref.watch(twitterViewModelProvider);

    final PagingController<int, TweetModel> pagingController = selectedIndex == 0
        ? pagingState.popular
        : pagingState.forYou;

    return PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedListView<int, TweetModel>(
          builderDelegate: PagedChildBuilderDelegate<TweetModel>(
            itemBuilder: (context, tweet, index) {
              return _buildTweetTileFromModel(tweet);
            },
            noItemsFoundIndicatorBuilder: (_) => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Hiç tweet bulunamadı.', style: TextStyle(color: Colors.white70)),
              ),
            ),
            firstPageErrorIndicatorBuilder: (_) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Tweetler yüklenirken bir hata oluştu.', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: () => pagingController.refresh(), child: const Text('Tekrar Dene')),
                ],
              ),
            ),
          ),
          state: state,

          fetchNextPage: fetchNextPage,
        );
      },
    );
  }

  Widget _buildTwitterFeedCategories(int selectedIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        children: [
          _buildTwitterCategoryButton(label: twitterFeedTabs[0], index: 0, isSelected: selectedIndex == 0),
          const SizedBox(width: 10),
          _buildTwitterCategoryButton(label: twitterFeedTabs[1], index: 1, isSelected: selectedIndex == 1),
          const SizedBox(width: 16),
          Expanded(child: Container(height: 1, color: hintTextColor.withOpacity(0.2))),
        ],
      ),
    );
  }

  Widget _buildTwitterCategoryButton({required String label, required int index, required bool isSelected}) {
    return GestureDetector(
      onTap: () => _onTwitterFeedTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : darkCardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.white : hintTextColor.withOpacity(0.5), width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? twitterBlue : Colors.white,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTweetTileFromModel(TweetModel tweet) {
    final String dateString = tweet.createdAt ?? "";
    final DateTime createdAtDateTime = DateTime.tryParse(dateString) ?? DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Card(
        color: darkCardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Container(
                      width: 40,
                      height: 40,
                      color: twitterBlue,
                      child: Center(
                        child: Image.network(tweet.accountImageUrl ?? '', width: 40, height: 40, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tweet.accountName ?? '',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(' @t24', style: TextStyle(color: hintTextColor, fontSize: 14)),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              _formatTimeAgo(createdAtDateTime),
                              style: TextStyle(color: hintTextColor, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        Text(
                          tweet.content ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 5),

                        // Text(
                        //   tweet.,
                        //   style: TextStyle(color: twitterBlue, fontSize: 14, decoration: TextDecoration.underline),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} saat önce';
    } else {
      return '${difference.inDays} gün önce';
    }
  }
}
