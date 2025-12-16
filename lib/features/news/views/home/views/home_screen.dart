import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/core/constants.dart';
import 'package:flutter_mytech_case/features/auth/providers.dart';
import 'package:flutter_mytech_case/features/news/model/news_category_model.dart';
import 'package:flutter_mytech_case/features/news/model/news_list_response.dart';
import 'package:flutter_mytech_case/features/news/view_models/news_view_model.dart';
import 'package:flutter_mytech_case/features/news/widgets/bottom_navigation_bar.dart';
import 'package:flutter_mytech_case/features/news/widgets/carousel_item_widget.dart';
import 'package:flutter_mytech_case/features/twitter/views/tweet_tile.widget.dart';
import 'package:flutter_mytech_case/utils/datetime_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentPage = 0;
  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;

  final List<String> categories = const ['Son Haberler', 'Sana Özel', 'Twitter', 'YouTube'];

  @override
  void initState() {
    Future.microtask(() => {ref.read(newsViewModelProvider.notifier).fetchPopularNews(PageConstants.latestNewsIndex)});
    Future.microtask(() => {ref.read(newsViewModelProvider.notifier).fetchCategorizedNews()});
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    String path = '';

    switch (index) {
      case 0:
        path = '/news';
        break;
      case 1:
        path = '/egundem';
        break;
      case 3:
        path = '/saved';
        break;
      case 4:
        path = '/local';
        break;
      default:
        return;
    }

    if (path.isNotEmpty) {
      context.go(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsViewModelProvider);

    final List<Items> activeList = _selectedCategoryIndex == PageConstants.latestNewsIndex
        ? newsState.latestNews
        : newsState.forYouNews;

    final popularNews = activeList.where((e) => e.isPopular == true).toList();

    final List<NewsCategoryModel> categorizedNews = newsState.groupedNews;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            buildAppBar(),

            SliverList(delegate: SliverChildListDelegate([_buildCategories(), const SizedBox(height: 10)])),

            if (_selectedCategoryIndex == PageConstants.twitterFeedIndex)
              const SliverFillRemaining(child: TwitterFeedTab())
            else
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildPopularNewsHeader(),
                  _buildPopularNewsCarousel(context, popularNews),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      popularNews.length,
                      (index) => _buildDotIndicator(index: index, currentPage: _currentPage),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._buildCategorizedNewsSections(categorizedNews),

                  const SizedBox(height: 50),
                ]),
              ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }

  Widget buildAppBar() {
    return SliverAppBar(
      backgroundColor: backgroundColor,
      floating: true,
      pinned: true,
      snap: true,
      elevation: 0,
      toolbarHeight: 56,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.menu, color: Colors.white),
              const SizedBox(width: 20),
              const Icon(LucideIcons.alarmClock, color: Colors.white),
            ],
          ),
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(color: darkCardColor, borderRadius: BorderRadius.circular(17.5)),
                  child: const Icon(LucideIcons.search, color: Colors.white, size: 15),
                ),
              ),
              const SizedBox(width: 10),
              ClipOval(
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(color: darkCardColor, borderRadius: BorderRadius.circular(17.5)),
                  child: _buildNotificationIcon(),
                ),
              ),
              const SizedBox(width: 10),
              _buildProfileAvatar(ref),
            ],
          ),
        ],
      ),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(height: 1.0, color: hintTextColor.withOpacity(0.2)),
      ),
    );
  }

  List<Widget> _buildCategorizedNewsSections(List<NewsCategoryModel> groupedNews) {
    List<Widget> sections = [];

    for (var group in groupedNews) {
      sections.add(
        _buildSectionHeader(
          group.categoryName ?? "",
          group.items != null && group.items!.isNotEmpty
              ? (group.items!.first.colorCode != null
                    ? Color(int.parse('0xFF${group.items!.first.colorCode!.replaceFirst('#', '')}'))
                    : redAccent)
              : redAccent,
          group.categoryId ?? "",
        ),
      );

      sections.addAll(
        group.items!.map((newsItem) {
          return _buildNewsTileFromViewModelItem(newsItem);
        }).toList(),
      );

      sections.add(
        _buildShowMoreButton(
          group.items!.first.colorCode != null
              ? Color(int.parse('0xFF${group.items!.first.colorCode!.replaceFirst('#', '')}'))
              : redAccent,
          categoryId: group.items!.first.categoryId,
        ),
      );

      sections.add(const SizedBox(height: 20));
    }

    return sections;
  }

  Widget _buildNewsTileFromViewModelItem(Items newsItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: darkCardColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.white,
                    child: Image.network(
                      newsItem.sourceProfilePictureUrl ?? 'https://via.placeholder.com/100x100.png?text=No+Image',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newsItem.sourceName ?? newsItem.sourceTitle ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        DateTimeHelper.formatPublishedAt(newsItem.publishedAt),
                        style: TextStyle(color: hintTextColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    ref.read(newsViewModelProvider.notifier).saveNews(newsItem.id!);
                  },
                  child: Icon(
                    newsItem.isSaved ?? false ? Icons.bookmark : Icons.bookmark_border,
                    color: redAccent,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    newsItem.title ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildShowMoreButton(Color backgroundColor, {String? categoryId}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            context.push('/categorynews/${categoryId ?? ''}');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text(
            'Daha Fazla Göster',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final String? profileImageUrl = authState.userProfile?.imageUrl;
    ImageProvider imageProvider;

    if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
      imageProvider = NetworkImage(profileImageUrl);
    } else {
      imageProvider = const AssetImage('assets/haber.jpg');
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ClipOval(
        child: SizedBox(
          width: 35,
          height: 35,
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/haber.jpg', fit: BoxFit.cover);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        Center(child: const Icon(LucideIcons.bell, color: Colors.white, size: 15)),

        Positioned(
          right: 9,
          top: 6,
          child: Container(
            decoration: BoxDecoration(color: redAccent, borderRadius: BorderRadius.circular(6)),
            constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    Color currentAccentColor = redAccent;
    if (_selectedCategoryIndex == PageConstants.twitterFeedIndex) {
      currentAccentColor = primaryColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            bool isSelected = index == _selectedCategoryIndex;

            final Color highlightColor = isSelected && categories[index] == PageConstants.twitterFeedIndex.toString()
                ? primaryColor
                : isSelected
                ? redAccent
                : hintTextColor;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });

                ref.read(newsViewModelProvider.notifier).fetchPopularNews(index);
              },

              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      categories[index],
                      style: TextStyle(color: highlightColor, fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          width: categories[index].length * 7.0,
                          height: 3,
                          decoration: BoxDecoration(color: highlightColor, borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPopularNewsHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
      child: Text(
        'Popüler Haberler',
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPopularNewsCarousel(BuildContext context, List<Items> popularNews) {
    if (popularNews.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: PageView.builder(
              itemCount: popularNews.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final news = popularNews[index];
                return CarouselItemWidget(
                  ref: ref,
                  title: news.title ?? '',
                  sourceName: news.sourceName ?? '',
                  isSaved: news.isSaved ?? false,
                  categoryName: news.categoryName ?? '',
                  sourceColor: news.colorCode != null
                      ? Color(int.parse('0xFF${news.colorCode!.replaceFirst('#', '')}'))
                      : Colors.red,
                  sourceProfilePictureUrl: news.imageUrl ?? 'https://via.placeholder.com/400x200.png?text=No+Image',
                  newsId: news.categoryName ?? '',
                  imageUrl: news.sourceProfilePictureUrl ?? 'https://via.placeholder.com/100x100.png?text=No+Image',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator({required int index, required int currentPage}) {
    final bool isActive = index == currentPage;

    const Color activeColor = Colors.redAccent;
    final Color inactiveColor = Colors.redAccent.withOpacity(0.3);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color accentColor, String categoryId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.only(right: 8),
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              context.push('/categorynews/${categoryId ?? ''}');
            },
            child: Text('Daha Fazla Göster', style: TextStyle(color: hintTextColor, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
