import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/features/news_source/view_model/source_view_model.dart';
import 'package:flutter_mytech_case/utils/debouncer.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mytech_case/core/constants.dart';

class SelectNewsSourcesScreen extends ConsumerStatefulWidget {
  const SelectNewsSourcesScreen({super.key});

  @override
  ConsumerState<SelectNewsSourcesScreen> createState() => _SelectNewsSourcesScreenState();
}

class _SelectNewsSourcesScreenState extends ConsumerState<SelectNewsSourcesScreen> {
  late final Debouncer _debouncer;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    _debouncer.call(() {
      ref.read(sourceListProvider.notifier).performSearch(query);
    });
  }

  void _toggleSourceSelection(String sourceId, bool newValue) {
    ref.read(sourceListProvider.notifier).toggleFollowSource(sourceId, newValue);
  }

  @override
  Widget build(BuildContext context) {
    final sourceCategoryListAsyncValue = ref.watch(sourceListProvider);

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
            child: sourceCategoryListAsyncValue.when(
              loading: () => Center(child: CircularProgressIndicator(color: primaryColor)),
              error: (err, stack) => Center(
                child: Text('Hata oluştu: ${err.toString()}', style: const TextStyle(color: Colors.red)),
              ),
              data: (categoryList) {
                return Column(
                  children: [
                    _buildSearchBar(
                      inputFillColor: inputFillColor,
                      hintTextColor: hintTextColor,
                      onSearch: _handleSearch,
                      controller: _searchController,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(top: 10, bottom: 100),
                        children: <Widget>[
                          ...categoryList.map((category) {
                            final categoryTitle = category.sourceCategoryTitle ?? '';
                            final sources = category.sources ?? [];

                            if (sources.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildCategoryHeader(categoryTitle, labelTextColor),
                                const SizedBox(height: 5),
                                ...sources.map((source) {
                                  return _buildSourceTile(
                                    source.id ?? '',
                                    source.name ?? '',
                                    source.imageUrl ?? '',
                                    source.isFollowed ?? false,
                                    hintTextColor,
                                    primaryColor,
                                    _toggleSourceSelection,
                                  );
                                }),
                                const SizedBox(height: 10),
                              ],
                            );
                          }),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                );
              },
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

  Widget _buildSearchBar({
    required Color inputFillColor,
    required Color hintTextColor,
    required Function(String) onSearch,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: _searchController,
        onChanged: onSearch,
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
        title.toUpperCase(),
        style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSourceTile(
    String sourceId,
    String title,
    String imageUrl,
    bool isFollowed,
    Color hintTextColor,
    Color primaryColor,
    Function(String, bool) onToggle,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            fit: BoxFit.cover,
            // Hata durumunda (404/boş URL) placeholder göstermek için try-catch ekleyebilirsiniz.
            image: NetworkImage(imageUrl),
          ),
        ),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: CupertinoSwitch(
        value: isFollowed,
        onChanged: (bool newValue) {
          onToggle(sourceId, newValue);
        },
        activeColor: primaryColor,
        inactiveThumbColor: hintTextColor,
        inactiveTrackColor: inputFillColor,
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
      ),
    );
  }

  Widget _buildSaveButton({required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.9),
            blurRadius: 10,
            spreadRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () async {
            try {
              await ref.read(sourceListProvider.notifier).saveFollowedSources();
              context.go('/home');
            } catch (e) {
              print('Kaydetme başarısız: $e');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Kaydetme başarısız oldu: ${e.toString()}')));
            }
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
