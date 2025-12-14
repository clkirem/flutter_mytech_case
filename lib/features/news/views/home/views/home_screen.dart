import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/core/constants.dart';
import 'package:flutter_mytech_case/features/news/model/news_list_response.dart';
import 'package:flutter_mytech_case/features/news/view_models/news_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NewsItem2 {
  final String source;
  final String time;
  final String title;
  final String? imageUrl;
  final Color sourceColor;

  NewsItem2(this.source, this.time, this.title, this.sourceColor, {this.imageUrl});
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Color primaryColor = Colors.blue;
  final Color backgroundColor = const Color(0xFF101922);
  final Color darkCardColor = const Color(0xFF222222);
  final Color hintTextColor = const Color(0xFF555D6B);
  final Color redAccent = Colors.red;
  final Color navBarColor = const Color(0xFF151515);

  int _currentPage = 0;
  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;
  bool isLoading = false;

  final List<String> categories = const ['Son Haberler', 'Sana Özel', 'Twitter', 'YouTube'];
  final List<NewsItem2> breakingNews = [
    NewsItem2(
      'Milli Gazete - Son Dakika',
      '4  Aralık Perşembe- 1 saat önce',
      'Türk Yargısı’ndan, Garanti Dubai’de Gayrimenkul Yatırımına İlgi',
      const Color(0xFFD0021B),
      imageUrl: 'assets/haber_resmi.png',
    ),
    NewsItem2(
      'A Haber - Son Dakika',
      '4  Aralık Perşembe-3 saat önce',
      'Destekler Geliyor: Çılgın Sedat’tan yürek ısıtan paylaşım: "Sen bizim mukaddesimiz"',
      const Color(0xFFD0021B),
    ),
  ];

  final List<NewsItem2> agendaNews = [
    NewsItem2(
      'Sputnik Türkçe',
      '4  Aralık Perşembe-2 saat önce',
      'TBMM Başkanı Kurtulmuş: Süreç en hassas ve kırılgan döneminde',
      const Color(0xFF4A90E2),
    ),
    NewsItem2(
      'Akşam Gazetesi',
      '4  Aralık Perşembe-1 saat önce',
      'Yurt dışından nasıl oyuna dönebiliriz? Meğer o soruna sızmışız',
      const Color(0xFF4A90E2),
    ),
  ];
  @override
  void initState() {
    Future.microtask(() => {ref.read(newsViewModelProvider.notifier).fetchByCategory(PageConstants.latestNewsIndex)});
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsViewModelProvider);

    final List<Items> activeList = _selectedCategoryIndex == PageConstants.latestNewsIndex
        ? newsState.latestNews
        : newsState.forYouNews;

    final popularNews = activeList.where((e) => e.isPopular == true).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
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
                      ClipOval(child: Container(width: 35, height: 35, child: Image.asset('assets/haber.jpg'))),
                    ],
                  ),
                ],
              ),

              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(height: 1.0, color: hintTextColor.withOpacity(0.2)),
              ),
            ),

            SliverList(delegate: SliverChildListDelegate([_buildCategories(), const SizedBox(height: 10)])),

            if (_selectedCategoryIndex == PageConstants.twitterFeedIndex)
              SliverList(delegate: SliverChildListDelegate([_buildTwitterFeedCategories()])),

            if (_selectedCategoryIndex == PageConstants.twitterFeedIndex)
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildTweetTile(tweets[index], darkCardColor);
                }, childCount: tweets.length),
              )
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

                  _buildSectionHeader('Son Dakika', redAccent),
                  ...breakingNews.map((news) => _buildBreakingNewsTile(news, darkCardColor, redAccent)).toList(),
                  _buildShowMoreButton(redAccent),
                  const SizedBox(height: 20),

                  _buildSectionHeader('Gündem', Colors.blue),
                  ...agendaNews.map((news) => _buildAgendaNewsTile(news, darkCardColor)).toList(),
                  _buildShowMoreButton(primaryColor),
                  const SizedBox(height: 50),
                ]),
              ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavBar(navBarColor, primaryColor),
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

            /*
              child: Text(
                '$_notificationCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
              */
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    Color currentAccentColor = redAccent;
    if (categories[_selectedCategoryIndex] == 'Twitter') {
      currentAccentColor = twitterBlue;
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

            final Color highlightColor = isSelected && categories[index] == 'Twitter'
                ? twitterBlue
                : isSelected
                ? redAccent
                : hintTextColor;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });

                ref.read(newsViewModelProvider.notifier).fetchByCategory(index);
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

  Widget _buildBottomNavBar(Color navBarColor, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: navBarColor,
        border: Border(top: BorderSide(color: hintTextColor.withOpacity(0.1), width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: redAccent,
        unselectedItemColor: hintTextColor,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 10, color: redAccent),
        unselectedLabelStyle: TextStyle(fontSize: 10, color: hintTextColor),

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(LucideIcons.newspaper, size: 24), label: 'Anasayfa'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.compass, size: 24), label: 'e-gündem'),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: redAccent),
              child: const Icon(Icons.alarm, color: Colors.white, size: 28),
            ),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border, size: 24), label: 'Kaydedilenler'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined, size: 24), label: 'Yerel'),
        ],
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
          Container(
            height: 250,
            child: PageView.builder(
              itemCount: popularNews.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final news = popularNews[index];
                return _buildCarouselItem(
                  title: news.title ?? '',
                  sourceName: news.sourceName ?? news.sourceTitle ?? '',
                  sourceColor: news.colorCode != null
                      ? Color(int.parse('0xFF' + news.colorCode!.replaceFirst('#', '')))
                      : Colors.red,
                  imageUrl: news.imageUrl ?? 'https://via.placeholder.com/400x200.png?text=No+Image',
                  categoryName: news.categoryName ?? '',
                  sourceProfilePictureUrl:
                      news.sourceProfilePictureUrl ?? 'https://via.placeholder.com/100x100.png?text=No+Image',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem({
    required String title,
    required String sourceName,
    required Color sourceColor,
    required String categoryName,
    required String imageUrl,
    required String sourceProfilePictureUrl,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: sourceColor, borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      categoryName,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),

                  ClipOval(
                    child: Container(
                      height: 35,
                      width: 35,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: redAccent.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(LucideIcons.bookmark, color: redAccent, size: 20),
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 5.0, color: Colors.black)],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 24,
                          height: 24,
                          color: Colors.white,
                          child: Center(child: Image.network(sourceProfilePictureUrl)),
                        ),
                      ),
                      const SizedBox(width: 8),

                      Text(
                        sourceName,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildSectionHeader(String title, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 4, height: 18, color: accentColor, margin: const EdgeInsets.only(right: 8)),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text('Daha Fazla Göster', style: TextStyle(color: hintTextColor, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildBreakingNewsTile(NewsItem2 news, Color cardColor, Color sourceColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10)),
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
                    child: Center(
                      child: Text(
                        news.source.substring(0, 1),
                        style: TextStyle(color: darkCardColor, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.source,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(news.time, style: TextStyle(color: hintTextColor, fontSize: 12)),
                    ],
                  ),
                ),

                Icon(LucideIcons.bookmark, color: redAccent, size: 20),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    news.title,
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

  Widget _buildAgendaNewsTile(NewsItem2 news, Color cardColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10)),
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
                    child: Center(
                      child: Text(
                        news.source.substring(0, 1),
                        style: TextStyle(color: darkCardColor, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.source,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(news.time, style: TextStyle(color: hintTextColor, fontSize: 12)),
                    ],
                  ),
                ),

                Icon(LucideIcons.bookmark, color: redAccent, size: 20),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    news.title,
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

  Widget _buildActionRow(Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(Icons.link, 'Anasayfa'),
        _buildActionButton(Icons.history, 'Gündem'),
        _buildActionButton(Icons.thumb_up_alt_outlined, '0 Beğeni', isRed: true, accentColor: accentColor),
        _buildActionButton(Icons.share_outlined, 'Kopyala/Paylaş'),
        _buildActionButton(Icons.more_horiz, 'Yarat'),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, {bool isRed = false, Color? accentColor}) {
    return Column(
      children: [
        Icon(icon, color: isRed ? accentColor : hintTextColor, size: 20),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: hintTextColor, fontSize: 10)),
      ],
    );
  }

  Widget _buildShowMoreButton(Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/category');
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

  final Color twitterBlue = const Color(0xFF1DA1F2);

  final List<Map<String, String>> tweets = [
    {'time': '37 dakika önce', 'title': 'Japonya büyük bir demans kriziyle karşı karşıya', 'link': 'https:'},
    {
      'time': '47 dakika önce',
      'title': 'Sosyal medyada hakaret davaları sektöre dönüştü: Uzlaşma dönemi sona eriyor',
      'link': 'https:',
    },
    {
      'time': '57 dakika önce',
      'title': '❄️ Meteorologlardan "Asrın kışı geliyor" 🚩 uyarısı: Arktik soğuk doğrudan Avrupa\'ya taşınabilir',
      'link': 'https:',
    },
    {
      'time': '1 saat önce',
      'title': 'T24: Depremde hayatını kaybedenlerin anısını yaşatmak için yapılan anıt...',
      'link': 'https:',
    },
  ];

  Widget _buildTweetTile(Map<String, String> tweet, Color cardColor) {
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
                      child: const Center(
                        child: Text(
                          'T24',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
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
                            const Text(
                              'T24',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(' @t24', style: TextStyle(color: hintTextColor, fontSize: 14)),
                            const Spacer(),
                            Text(tweet['time']!, style: TextStyle(color: hintTextColor, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 5),

                        Text(
                          tweet['title']!,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 5),

                        Text(
                          tweet['link']!,
                          style: TextStyle(color: twitterBlue, fontSize: 14, decoration: TextDecoration.underline),
                        ),
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

  Widget _buildTwitterFeedCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        children: [
          _buildCategoryButton(
            'Popüler',
            false,
            buttonColor: hintTextColor,
            textColor: Colors.black,
            borderColor: hintTextColor.withOpacity(0.5),
          ),
          const SizedBox(width: 10),

          _buildCategoryButton(
            'Sana Özel',
            true,
            buttonColor: darkCardColor,
            textColor: Colors.white,
            borderColor: Colors.transparent,
          ),
          const SizedBox(width: 16),

          Expanded(child: Container(height: 1, color: hintTextColor.withOpacity(0.2))),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
    String label,
    bool isSelected, {
    required Color buttonColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
