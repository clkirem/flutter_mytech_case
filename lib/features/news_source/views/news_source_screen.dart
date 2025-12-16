import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/features/news_source/model/source_category_model.dart';
import 'package:flutter_mytech_case/features/news_source/view_model/source_view_model.dart';
import 'package:flutter_mytech_case/features/news_source/widgets/custom_search_bar.dart';
import 'package:flutter_mytech_case/features/news_source/widgets/source_tile_widget.dart';
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
                    CustomSearchBar(
                      searchController: _searchController,
                      inputFillColor: inputFillColor,
                      hintTextColor: hintTextColor,
                      onSearch: _handleSearch,
                      controller: _searchController,
                    ),
                    const SizedBox(height: 10),
                    buildCategoryAndSourceTile(categoryList),
                  ],
                );
              },
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: _buildSaveButton()),
        ],
      ),
    );
  }

  buildCategoryAndSourceTile(List<SourceCategoryModel> categoryList) {
    return Expanded(
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
                  return SourceTileWidget(
                    sourceId: source.id ?? '',
                    title: source.name ?? '',
                    imageUrl: source.imageUrl ?? '',
                    isFollowed: source.isFollowed ?? false,
                    hintTextColor: hintTextColor,
                    primaryColor: primaryColor,
                    onToggle: _toggleSourceSelection,
                  );
                }),
                const SizedBox(height: 10),
              ],
            );
          }),
          const SizedBox(height: 20),
        ],
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

  Widget _buildSaveButton() {
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
