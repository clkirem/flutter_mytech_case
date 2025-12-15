class CacheItem {
  final dynamic value;
  final DateTime timestamp;

  CacheItem({required this.value, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {'value': value, 'timestamp': timestamp.millisecondsSinceEpoch};
  }

  static CacheItem fromMap(Map map) {
    return CacheItem(value: map['value'], timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']));
  }
}
