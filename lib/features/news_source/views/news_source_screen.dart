import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewsSource {
  final String title;
  final String category;
  final Color color;

  NewsSource(this.title, this.category, this.color);
}

class SelectNewsSourcesScreen extends StatefulWidget {
  const SelectNewsSourcesScreen({super.key});

  @override
  State<SelectNewsSourcesScreen> createState() => _SelectNewsSourcesScreenState();
}

class _SelectNewsSourcesScreenState extends State<SelectNewsSourcesScreen> {
  final Color primaryColor = Colors.blue;
  final Color backgroundColor = Color(0xFF101922);
  final Color inputFillColor = Color(0xFF18212D);
  final Color hintTextColor = Color(0xFF555D6B);
  final Color labelTextColor = const Color(0xFFE0E0E0);

  final List<NewsSource> _allSources = [
    NewsSource('TechCrunch', 'TECHNOLOGY', const Color(0xFF5CB85C)),
    NewsSource('The Verge', 'TECHNOLOGY', const Color(0xFF4A90E2)),
    NewsSource('WIRED', 'TECHNOLOGY', const Color(0xFF999999)),
    NewsSource('BBC News', 'WORLD NEWS', const Color(0xFFD0021B)),
    NewsSource('Reuters', 'WORLD NEWS', const Color(0xFF00589C)),
    NewsSource('ESPN', 'SPORTS', const Color(0xFFCC3333)),
  ];

  late Map<String, bool> _selectedSources;

  @override
  void initState() {
    super.initState();
    _selectedSources = {
      for (var source in _allSources) source.title: true,
      'The Verge': false,
      'BBC News': false,
      'ESPN': false,
    };
  }

  void _toggleSourceSelection(String title, bool newValue) {
    setState(() {
      _selectedSources[title] = newValue;
    });
    print('$title durumu $newValue olarak güncellendi.');
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<NewsSource>> groupedSources = {};
    for (var source in _allSources) {
      if (!groupedSources.containsKey(source.category)) {
        groupedSources[source.category] = [];
      }
      groupedSources[source.category]!.add(source);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Select News Sources',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: hintTextColor, height: 0.1),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              padding: const EdgeInsets.only(top: 10, bottom: 100),
              children: <Widget>[
                _buildSearchBar(inputFillColor: inputFillColor, hintTextColor: hintTextColor),
                const SizedBox(height: 20),

                ...groupedSources.keys.map((category) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryHeader(category, labelTextColor),
                      const SizedBox(height: 5),
                      ...groupedSources[category]!.map((source) {
                        return _buildSourceTile(
                          source.title,
                          source.color,
                          _selectedSources[source.title]!,
                          hintTextColor,
                          primaryColor,
                          _toggleSourceSelection,
                        );
                      }).toList(),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: _buildSaveButton(primaryColor: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar({required Color inputFillColor, required Color hintTextColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search for a source...',
          hintStyle: TextStyle(color: hintTextColor),
          filled: true,
          fillColor: inputFillColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          prefixIcon: Icon(Icons.search, color: hintTextColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSourceTile(
    String title,
    Color avatarColor,
    bool isSelected,
    Color hintTextColor,
    Color primaryColor,
    Function(String, bool) onToggle,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: avatarColor, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            title.substring(0, 1),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: CupertinoSwitch(
        value: isSelected,
        onChanged: (bool newValue) {
          onToggle(title, newValue);
        },
        activeColor: primaryColor,
        inactiveThumbColor: hintTextColor,
        inactiveTrackColor: inputFillColor,
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
      ),
    );
  }

  Widget _buildSaveButton({required Color primaryColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),

      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            print('Seçilen Kaynaklar: ${_selectedSources.entries.where((e) => e.value).map((e) => e.key).toList()}');
            context.go('/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            elevation: 0,
          ),
          child: const Text(
            'Save',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
