import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NewsItem {
  final String source;
  final String time;
  final String title;
  final String? imageUrl;
  final Color sourceColor;

  NewsItem(this.source, this.time, this.title, this.sourceColor, {this.imageUrl});
}

class CategoryNewsScreen extends StatefulWidget {
  const CategoryNewsScreen({super.key});

  @override
  State<CategoryNewsScreen> createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends State<CategoryNewsScreen> {
  final Color primaryColor = Colors.blue;
  final Color backgroundColor = const Color(0xFF101922);
  final Color darkCardColor = const Color(0xFF222222);
  final Color hintTextColor = const Color(0xFF555D6B);
  final Color redAccent = Colors.red;
  final Color navBarColor = const Color(0xFF151515);

  int _currentPage = 0;
  final int _carouselItemCount = 5;
  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> newsCategories = const [
    {'label': 'Son Dakika', 'icon': Icons.flash_on, 'color': Colors.red},
    {'label': 'Gündem', 'icon': Icons.newspaper, 'color': Color(0xFF4A90E2)},
    {'label': 'Spor', 'icon': Icons.sports_basketball, 'color': Color(0xFF41A344)},
    {'label': 'Finans', 'icon': Icons.public, 'color': Color(0xFF2B577E)},
  ];
  final List<String> categories = const ['Son Haberler', 'Sana Özel', 'Twitter', 'YouTube'];
  final List<NewsItem> breakingNews = [
    NewsItem(
      'Milli Gazete - Son Dakika',
      '4  Aralık Perşembe- 1 saat önce',
      'Türk Yargısı’ndan, Garanti Dubai’de Gayrimenkul Yatırımına İlgi',
      const Color(0xFFD0021B),
      imageUrl: 'assets/haber_resmi.png',
    ),
    NewsItem(
      'A Haber - Son Dakika',
      '4  Aralık Perşembe-3 saat önce',
      'Destekler Geliyor: Çılgın Sedat’tan yürek ısıtan paylaşım: "Sen bizim mukaddesimiz"',
      const Color(0xFFD0021B),
    ),
    NewsItem(
      'A Haber - Son Dakika',
      '4  Aralık Perşembe-3 saat önce',
      'Destekler Geliyor: Çılgın Sedat’tan yürek ısıtan paylaşım: "Sen bizim mukaddesimiz"',
      const Color(0xFFD0021B),
    ),
    NewsItem(
      'A Haber - Son Dakika',
      '4  Aralık Perşembe-3 saat önce',
      'Destekler Geliyor: Çılgın Sedat’tan yürek ısıtan paylaşım: "Sen bizim mukaddesimiz"',
      const Color(0xFFD0021B),
    ),
    NewsItem(
      'A Haber - Son Dakika',
      '4  Aralık Perşembe-3 saat önce',
      'Destekler Geliyor: Çılgın Sedat’tan yürek ısıtan paylaşım: "Sen bizim mukaddesimiz"',
      const Color(0xFFD0021B),
    ),
  ];

  final List<NewsItem> agendaNews = [
    NewsItem(
      'Sputnik Türkçe',
      '4  Aralık Perşembe-2 saat önce',
      'TBMM Başkanı Kurtulmuş: Süreç en hassas ve kırılgan döneminde',
      const Color(0xFF4A90E2),
    ),
    NewsItem(
      'Akşam Gazetesi',
      '4  Aralık Perşembe-1 saat önce',
      'Yurt dışından nasıl oyuna dönebiliriz? Meğer o soruna sızmışız',
      const Color(0xFF4A90E2),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                children: [
                  InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: const Icon(LucideIcons.circleArrowLeft, color: Colors.white),
                  ),
                ],
              ),

              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(height: 1.0, color: hintTextColor.withOpacity(0.2)),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: _buildCategoryButtons(),
              ),
            ),

            SliverList(
              delegate: SliverChildListDelegate([
                ...breakingNews.map((news) => _buildBreakingNewsTile(news, darkCardColor, redAccent)).toList(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: newsCategories.length,
        itemBuilder: (context, index) {
          final category = newsCategories[index];
          final bool isSelected = index == 0;

          return Padding(
            padding: EdgeInsets.only(right: 15),
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: isSelected ? category['color'] : backgroundColor,
                borderRadius: BorderRadius.circular(15),
                border: isSelected ? null : Border.all(color: hintTextColor.withOpacity(0.2), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: category['color'] as Color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(category['icon'] as IconData, color: Colors.black, size: 40),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    category['label'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : category['color'] as Color,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBreakingNewsTileWithDate(NewsItem news, Color cardColor, Color sourceColor, {bool hasImage = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 20,
                        height: 20,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            news.source.substring(0, 1),
                            style: TextStyle(color: cardColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${news.source} - ${news.time}',
                        style: TextStyle(color: hintTextColor, fontSize: 12, fontWeight: FontWeight.normal),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.bookmark, color: Colors.red, size: 20),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    news.title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    maxLines: hasImage ? 3 : 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasImage)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),

                      child: Image.asset(news.imageUrl!, width: 120, height: 80, fit: BoxFit.cover),
                    ),
                  ),
              ],
            ),
            if (hasImage) const SizedBox(height: 15),
          ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            bool isSelected = index == _selectedCategoryIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? redAccent : hintTextColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          width: categories[index].length * 7.0,
                          height: 3,
                          decoration: BoxDecoration(color: redAccent, borderRadius: BorderRadius.circular(2)),
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
        selectedItemColor: primaryColor,
        unselectedItemColor: hintTextColor,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 10, color: primaryColor),
        unselectedLabelStyle: TextStyle(fontSize: 10, color: hintTextColor),

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 24), label: 'Anasayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule, size: 24), label: 'e-gündem'),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: redAccent),
              child: const Icon(Icons.access_time_filled, color: Colors.white, size: 28),
            ),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border, size: 24), label: 'Kaydedilenler'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined, size: 24), label: 'Yerel'),
        ],
      ),
    );
  }

  Widget _buildPopularNewsCarousel(BuildContext context) {
    final List<Map<String, dynamic>> popularItems = [
      {
        'title': 'Almanya Başbakanı, Rusya’nın dondurulmuş varlıklarıyla ilgili görüş...',
        'source': 'Milli Gazete',
        'isSpecial': true,
      },
      {
        'title': 'Yeni Yapay Zeka Yasası, Dijital Dünyayı Nasıl Değiştirecek?',
        'source': 'Tech Gündem',
        'isSpecial': false,
      },
      {'title': 'Türkiye\'de Elektrikli Otomobil Satışları Rekor Kırdı', 'source': 'Oto Haber', 'isSpecial': false},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: darkCardColor),
            child: PageView.builder(
              itemCount: popularItems.length,
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final item = popularItems[index];
                return _buildCarouselItem(
                  title: item['title'],
                  sourceName: item['source'],
                  sourceColor: Colors.white,
                  isSpecial: item['isSpecial'],
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                popularItems.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: index == _currentPage ? 12 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: index == _currentPage ? redAccent : hintTextColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
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
    required bool isSpecial,
  }) {
    final String tagLabel = isSpecial ? 'Gündem' : 'Siyaset';

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: const AssetImage('assets/haber.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.15), BlendMode.darken),
            ),
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
                    decoration: BoxDecoration(color: redAccent, borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      tagLabel,
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
                          child: Center(
                            child: Text(
                              sourceName.substring(0, 1),
                              style: TextStyle(color: darkCardColor, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
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

  Widget _buildBreakingNewsTile(NewsItem news, Color cardColor, Color sourceColor) {
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

  Widget _buildAgendaNewsTile(NewsItem news, Color cardColor) {
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
}
