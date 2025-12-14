import 'package:flutter_mytech_case/features/news/model/news_list_response.dart';
import 'package:flutter/material.dart';

class NewsItem {
  final String source;
  final String time;
  final String title;
  final String? imageUrl;
  final Color sourceColor;

  NewsItem({required this.source, required this.time, required this.title, this.imageUrl, required this.sourceColor});
}

extension ItemsToNewsItem on Items {
  NewsItem toNewsItem() {
    return NewsItem(
      source: sourceName ?? sourceTitle ?? '',
      title: title ?? '',
      time: publishedAt ?? '',
      imageUrl: imageUrl,
      sourceColor: _colorFromHex(colorCode),
    );
  }

  Color _colorFromHex(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.red;
    final value = int.tryParse(hex.replaceFirst('#', ''), radix: 16);
    if (value == null) return Colors.red;
    return Color(0xFF000000 | value);
  }
}
