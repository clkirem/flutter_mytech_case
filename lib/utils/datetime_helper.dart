import 'dart:developer';

import 'package:intl/intl.dart';

class DateTimeHelper {
  static const List<String> _turkishWeekdays = [
    '',
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  static String formatPublishedAt(String? publishedAtIsoString) {
    if (publishedAtIsoString == null || publishedAtIsoString.isEmpty) {
      return 'Tarih Bilgisi Yok';
    }

    try {
      final DateTime publishedDate = DateTime.parse(publishedAtIsoString).toLocal();
      final DateTime now = DateTime.now().toLocal();

      final Duration difference = now.difference(publishedDate);

      String relativeTime;
      if (difference.inHours < 24) {
        if (difference.inHours < 1) {
          relativeTime = '${difference.inMinutes} dakika önce';
        } else {
          relativeTime = '${difference.inHours} saat önce';
        }
      } else if (difference.inDays < 7) {
        relativeTime = '${difference.inDays} gün önce';
      } else {
        relativeTime = DateFormat('HH:mm').format(publishedDate);
      }

      if (relativeTime == '0 dakika önce') {
        relativeTime = 'Şimdi';
      }

      final String formattedDate = DateFormat('d MMMM', 'tr_TR').format(publishedDate);

      final String weekday = _turkishWeekdays[publishedDate.weekday];
      return '$formattedDate $weekday - $relativeTime';
    } catch (e) {
      log('Tarih formatlama hatası: $e');
      return publishedAtIsoString;
    }
  }
}
