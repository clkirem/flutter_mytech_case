import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/core/constants.dart';
import 'package:flutter_mytech_case/features/news/view_models/news_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarouselItemWidget extends StatelessWidget {
  const CarouselItemWidget({
    super.key,
    required this.ref,
    required this.title,
    required this.sourceName,
    required this.sourceColor,
    required this.categoryName,
    required this.imageUrl,
    required this.sourceProfilePictureUrl,
    required this.newsId,
    required this.isSaved,
  });

  final WidgetRef ref;
  final String title;
  final String sourceName;
  final Color sourceColor;
  final String categoryName;
  final String imageUrl;
  final String sourceProfilePictureUrl;
  final String newsId;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
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
                      child: GestureDetector(
                        onTap: () {
                          ref.read(newsViewModelProvider.notifier).saveNews(newsId);
                        },
                        child: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: redAccent, size: 20),
                      ),
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
}
