import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

// News Model (Haber verisi için basit bir model)
class NewsItem {
  final String source;
  final String time;
  final String title;
  final String? imageUrl;
  final Color sourceColor;

  NewsItem(this.source, this.time, this.title, this.sourceColor, {this.imageUrl});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Theme Renkleri ---
  final Color primaryColor = Colors.blue;
  final Color backgroundColor = const Color(0xFF101922);
  final Color darkCardColor = const Color(0xFF222222);
  final Color hintTextColor = const Color(0xFF555D6B);
  final Color redAccent = Colors.red;
  final Color navBarColor = const Color(0xFF151515);

  // --- State ---
  int _currentPage = 0;
  final int _carouselItemCount = 5;
  int _selectedIndex = 0; // Aktif navigasyon öğesi indeksi
  int _selectedCategoryIndex = 0;

  // --- Örnek Veri ---
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
            // 1. En Üst Sabit Çubuk (Sadece İkonlar)
            SliverAppBar(
              backgroundColor: backgroundColor,
              floating: true, // Aşağı kaydırınca hemen görünür
              pinned: true, // Yukar kaydırılınca üstte sabit kalır
              snap: true, // Floating ile birlikte kullanılır
              elevation: 0,
              toolbarHeight: 56, // Standart yükseklik
              // Title: Sadece Menü, Arama ve Profil
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

              // AppBar'ın altındaki ince çizgi
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(height: 1.0, color: hintTextColor.withOpacity(0.2)),
              ),
            ),

            SliverList(
              delegate: SliverChildListDelegate([
                _buildCategories(), // Bu widget _selectedCategoryIndex'i güncelliyor
                const SizedBox(height: 10),
              ]),
            ),

            // 3. Kategoriye Özel İçerik
            if (_selectedCategoryIndex == 2) // Eğer "Twitter" seçiliyse (index 2)
              SliverList(
                delegate: SliverChildListDelegate([
                  // Twitter Feed'ine Özel Kategori Butonları (Popüler, Sana Özel)
                  _buildTwitterFeedCategories(),
                ]),
              ),

            if (_selectedCategoryIndex == 2) // Eğer "Twitter" seçiliyse
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  // Her bir Twitter gönderisini oluştur
                  return _buildTweetTile(tweets[index], darkCardColor);
                }, childCount: tweets.length),
              )
            else // Eğer "Son Haberler" (index 0) veya diğerleri seçiliyse
              SliverList(
                delegate: SliverChildListDelegate([
                  // Popüler Haberler Başlığı ve Slider (Kaydırma sırasında kaybolan kısım)
                  _buildPopularNewsHeader(),
                  _buildPopularNewsCarousel(context),
                  const SizedBox(height: 20),

                  // Son Dakika Bölümü (Liste)
                  _buildSectionHeader('Son Dakika', redAccent),
                  ...breakingNews.map((news) => _buildBreakingNewsTile(news, darkCardColor, redAccent)).toList(),
                  _buildShowMoreButton(redAccent),
                  const SizedBox(height: 20),

                  // Gündem Bölümü (Liste)
                  _buildSectionHeader('Gündem', Colors.blue),
                  ...agendaNews.map((news) => _buildAgendaNewsTile(news, darkCardColor)).toList(),
                  _buildShowMoreButton(primaryColor),
                  const SizedBox(height: 50),
                ]),
              ),
          ],
        ),
      ),

      // Sabit Alt Navigasyon Çubuğu
      bottomNavigationBar: _buildBottomNavBar(navBarColor, primaryColor),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        // Zil İkonu
        Center(child: const Icon(LucideIcons.bell, color: Colors.white, size: 15)),

        // Kırmızı Rozet (Badge)
        Positioned(
          right: 9,
          top: 6,
          child: Container(
            //padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: redAccent, borderRadius: BorderRadius.circular(6)),
            constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
            // Eğer rozet içinde sayı göstermek isterseniz (Opsiyonel)
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
    // Seçilen kategoriye göre vurgu rengini belirle
    Color currentAccentColor = redAccent;
    if (categories[_selectedCategoryIndex] == 'Twitter') {
      currentAccentColor = twitterBlue; // Eğer Twitter seçiliyse Mavi kullan
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
            // Eğer Twitter sekmesi ise, vurgu rengini mavi yap
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
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20), // Sekmeler arası boşluk
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      categories[index],
                      style: TextStyle(
                        // Vurgu rengini burada kullanıyoruz
                        color: highlightColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          width: categories[index].length * 7.0, // Metin uzunluğuna göre ayarlama
                          height: 3,
                          decoration: BoxDecoration(
                            // Vurgu rengini alt çizgi için de kullanıyoruz
                            color: highlightColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
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

  // --- YENİ YARDIMCI WIDGET ---

  Widget _buildPopularNewsHeader() {
    // "Popüler Haberler" Başlığı (Kaydırılabilir içerik içinde)
    return const Padding(
      padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
      child: Text(
        'Popüler Haberler',
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // --- Diğer Yardımcı Widget'lar (Önceki koddan alınmıştır) ---

  // Bottom Navigation Bar Widget'ı
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
          BottomNavigationBarItem(icon: Icon(LucideIcons.home, size: 24), label: 'Anasayfa'),
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

  // ... _HomeScreenState sınıfı içinde ...

  Widget _buildPopularNewsCarousel(BuildContext context) {
    // Popüler haberler için örnek başlıklar ve kaynaklar (Veri çeşitliliği için)
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
      // ... daha fazla örnek ...
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popüler Haberler Carousel
          Container(
            height: 250, // Yüksekliği tasarıma uygun şekilde artırdım
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
                  sourceColor: Colors.white, // Kaynak rengi bu tasarımda genel olarak beyaz
                  isSpecial: item['isSpecial'],
                );
              },
            ),
          ),

          const SizedBox(height: 15), // Noktalar için boşluk artırıldı
          // Nokta Göstergeleri (Dot Indicators)
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                popularItems.length, // Sayı item listesinden alınır
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: index == _currentPage ? 12 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: index == _currentPage ? redAccent : hintTextColor.withOpacity(0.5), // Aktif nokta kırmızı
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

  // ... (Diğer widget'lar) ...

  // ... _HomeScreenState sınıfı içinde ...

  // Carousel içindeki tek bir öğe (Görsel ve metin)
  Widget _buildCarouselItem({
    required String title,
    required String sourceName,
    required Color sourceColor,
    required bool isSpecial,
  }) {
    // Özel etiket yerine, tasarımda "Gündem" gibi genel bir etiket var.
    final String tagLabel = isSpecial ? 'Gündem' : 'Siyaset';

    return Stack(
      children: [
        // 1. Arka Plan Resmi (Tamamen doldurur)
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              // Bu görseli kullanmak için assets/haber.jpg dosyanızın olması gerekir.
              image: const AssetImage('assets/haber.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.15), // Başlıkların okunurluğu için hafif karanlık katman
                BlendMode.darken,
              ),
            ),
          ),
        ),

        // 2. İçerik ve İkonlar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // İçeriği üste ve alta itmek için
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ÜST KISIM (Etiket ve Kaydetme İkonu)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sol Üst Etiket (Gündem, Özel vb.)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: redAccent, // Tasarımdaki kırmızı etiket rengi
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      tagLabel,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Sağ Üst Kaydetme İkonu (Kırmızı dolgulu)
                  ClipOval(
                    child: Container(
                      height: 35,
                      width: 35,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: redAccent.withOpacity(0.5), // Yarı şeffaf arka plan
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(LucideIcons.bookmark, color: redAccent, size: 20), // Kırmızı kaydetme ikonu
                    ),
                  ),
                ],
              ),

              // ALT KISIM (Başlık ve Kaynak Bilgisi)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Haber Başlığı
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 5.0, color: Colors.black)], // Okunurluğu artırmak için gölge
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Kaynak İkonu ve Metni
                  Row(
                    children: [
                      // Kaynak Logosunun Yer Tutucusu (M harfli yuvarlak)
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
                      // Kaynak Adı
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

  // ... (Diğer widget'lar) ...
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
                // Kaynak Logosunun Yer Tutucusu (M harfli yuvarlak)
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
                // Kaynak Adı
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
                // Padding(
                //   padding: const EdgeInsets.only(left: 10),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(8),
                //     child: Container(width: 100, height: 60, color: hintTextColor),
                //   ),
                // ),
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
                // Kaynak Logosunun Yer Tutucusu (M harfli yuvarlak)
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
                // Kaynak Adı
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
                // Padding(
                //   padding: const EdgeInsets.only(left: 10),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(8),
                //     child: Container(width: 100, height: 60, color: hintTextColor),
                //   ),
                // ),
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

  final Color twitterBlue = const Color(0xFF1DA1F2); // Twitter Mavi rengi

  // --- Örnek Twitter Gönderi Verisi ---
  final List<Map<String, String>> tweets = [
    {
      'time': '37 dakika önce',
      'title': 'Japonya büyük bir demans kriziyle karşı karşıya',
      'link': 'https://t.co/9bbjEijekl',
    },
    {
      'time': '47 dakika önce',
      'title': 'Sosyal medyada hakaret davaları sektöre dönüştü: Uzlaşma dönemi sona eriyor',
      'link': 'https://t.co/tSccdEE8ia',
    },
    {
      'time': '57 dakika önce',
      'title': '❄️ Meteorologlardan "Asrın kışı geliyor" 🚩 uyarısı: Arktik soğuk doğrudan Avrupa\'ya taşınabilir',
      'link': 'https://t.co/PHrFeqblBj',
    },
    {
      'time': '1 saat önce',
      'title': 'T24: Depremde hayatını kaybedenlerin anısını yaşatmak için yapılan anıt...',
      'link': 'https://t.co/abcXYZ123',
    },
  ];

  // ... (Diğer state değişkenleri ve fonksiyonlar) ...

  // Twitter akışındaki bir gönderiyi oluşturan Widget
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
                  // Sol Taraftaki T24 Logosu
                  ClipOval(
                    child: Container(
                      width: 40,
                      height: 40,
                      color: twitterBlue, // T24/Twitter Mavi
                      child: const Center(
                        child: Text(
                          'T24',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Gönderi Metni ve Saati
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kullanıcı Adı ve Saat
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'T24',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(' @t24', style: TextStyle(color: hintTextColor, fontSize: 14)),
                            const Spacer(), // Aradaki boşluğu doldurur
                            Text(tweet['time']!, style: TextStyle(color: hintTextColor, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Gönderi Başlığı
                        Text(
                          tweet['title']!,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 5),

                        // Link
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

  // Twitter'a özel kategori düğmeleri (Popüler, Sana Özel)
  Widget _buildTwitterFeedCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        children: [
          // Popüler (Pasif)
          _buildCategoryButton(
            'Popüler',
            false,
            buttonColor: hintTextColor,
            textColor: Colors.black,
            borderColor: hintTextColor.withOpacity(0.5),
          ),
          const SizedBox(width: 10),
          // Sana Özel (Aktif)
          _buildCategoryButton(
            'Sana Özel',
            true,
            buttonColor: darkCardColor,
            textColor: Colors.white,
            borderColor: Colors.transparent,
          ),
          const SizedBox(width: 16),

          // Geri kalan alanı dolduran ince çizgi
          Expanded(child: Container(height: 1, color: hintTextColor.withOpacity(0.2))),
        ],
      ),
    );
  }

  // Özelleştirilmiş Kategori Düğmesi
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
