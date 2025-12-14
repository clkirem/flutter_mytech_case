class CacheItem {
  final dynamic data;
  final DateTime createdAt;

  CacheItem({required this.data, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {'data': data, 'createdAt': createdAt.millisecondsSinceEpoch};
  }

  static CacheItem fromMap(Map map) {
    return CacheItem(data: map['data'], createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']));
  }
}
