import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/core/constants.dart';
import 'package:flutter_mytech_case/features/category_news/model/category_response.dart';
import 'package:flutter_mytech_case/features/category_news/view_models/category_news_view_model.dart';
import 'package:flutter_mytech_case/features/category_news/view_models/cateroy_list_view_model.dart';
import 'package:flutter_mytech_case/features/news/model/news_by_category_response.dart';
import 'package:flutter_mytech_case/features/news/view_models/news_view_model.dart';
import 'package:flutter_mytech_case/utils/datetime_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CategoryNewsScreen extends ConsumerStatefulWidget {
  String categoryId;
  CategoryNewsScreen({super.key, required this.categoryId});

  @override
  ConsumerState<CategoryNewsScreen> createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends ConsumerState<CategoryNewsScreen> {
  late final categoryVmProvider = categoryNewsViewModelProvider(widget.categoryId);
  late String activeCategoryId;

  @override
  void initState() {
    activeCategoryId = widget.categoryId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryListViewModelProvider.notifier).fetchCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentVmProvider = categoryNewsViewModelProvider(activeCategoryId);
    final categoryViewModel = ref.watch(currentVmProvider.notifier);
    final pagingController = categoryViewModel.pagingController;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: Builder(
          builder: (context) {
            return InkWell(
              onTap: () {
                context.pop();
              },
              child: const Icon(LucideIcons.circleArrowLeft, color: Colors.white),
            );
          },
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: _buildCategoryButtons(),
              ),
            ),

            PagingListener(
              builder: (context, state, fetchNextPage) {
                return PagedSliverList<int, CategoryNewsItems>(
                  state: state,
                  fetchNextPage: fetchNextPage,
                  builderDelegate: PagedChildBuilderDelegate<CategoryNewsItems>(
                    itemBuilder: (context, item, index) {
                      return _buildApiNewsTile(item);
                    },
                    firstPageProgressIndicatorBuilder: (_) => const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator(color: Colors.white)),
                    ),
                    newPageProgressIndicatorBuilder: (_) => const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator(color: Colors.white)),
                    ),
                    noItemsFoundIndicatorBuilder: (_) => const Center(
                      child: Text('Bu kategoride haber yok', style: TextStyle(color: Colors.white)),
                    ),
                    firstPageErrorIndicatorBuilder: (context) {
                      return Center(
                        child: Column(
                          children: [
                            const Text('Haberler yüklenemedi', style: TextStyle(color: Colors.red)),
                            TextButton(
                              onPressed: () => ref.read(categoryVmProvider.notifier).refresh(),
                              child: const Text('Tekrar Dene'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              controller: pagingController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiNewsTile(CategoryNewsItems item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF222222), borderRadius: BorderRadius.circular(10)),
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
                    child: Center(child: Image.network(item.imageUrl ?? "", fit: BoxFit.contain)),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.sourceName ?? '',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        DateTimeHelper.formatPublishedAt(item.publishedAt),
                        style: const TextStyle(color: Color(0xFF555D6B), fontSize: 12),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    ref.read(newsViewModelProvider.notifier).toggleSaveNews(item);
                  },
                  child: Icon(item.isSaved ?? false ? Icons.bookmark : Icons.bookmark_border, color: Colors.red),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              item.title ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    final categoryListState = ref.watch(categoryListViewModelProvider);

    if (categoryListState.isLoading && categoryListState.categories.isEmpty) {
      return SizedBox();
    }

    final List<CategoryResponse> categories = categoryListState.categories;

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final bool isSelected = category.id == activeCategoryId;

          final Color categoryColor = category.colorCode != null
              ? Color(int.parse('0xFF${category.colorCode!.replaceFirst('#', '')}'))
              : Colors.grey;

          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                if (category.id != null && category.id != activeCategoryId) {
                  setState(() {
                    activeCategoryId = category.id!;
                  });
                }
              },
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isSelected ? categoryColor : darkCardColor,
                  borderRadius: BorderRadius.circular(15),
                  border: isSelected ? null : Border.all(color: hintTextColor.withOpacity(0.2), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(category.imageUrl ?? "")),
                    const SizedBox(height: 5),
                    Text(
                      category.name ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : categoryColor,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
