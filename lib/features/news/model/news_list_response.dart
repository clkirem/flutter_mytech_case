class NewsListResponse {
  List<Items>? items;
  int? total;
  int? page;
  int? pageSize;

  NewsListResponse({this.items, this.total, this.page, this.pageSize});

  factory NewsListResponse.fromJson(Map<String, dynamic> json) {
    return NewsListResponse(
      items: (json['items'] as List?)?.map((v) => Items.fromJson(v as Map<String, dynamic>)).toList(),
      total: json['total'] as int?,
      page: json['page'] as int?,
      pageSize: json['pageSize'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['page'] = page;
    data['pageSize'] = pageSize;
    return data;
  }
}

class Items {
  String? id;
  String? title;
  String? content;
  String? imageUrl;
  String? categoryId;
  String? sourceId;
  String? sourceProfilePictureUrl;
  String? sourceTitle;
  String? publishedAt;
  bool? isLatest;
  bool? isPopular;
  String? colorCode;
  bool? isSaved;
  String? sourceName;
  String? categoryName;

  Items({
    this.id,
    this.title,
    this.content,
    this.imageUrl,
    this.categoryId,
    this.sourceId,
    this.sourceProfilePictureUrl,
    this.sourceTitle,
    this.publishedAt,
    this.isLatest,
    this.isPopular,
    this.colorCode,
    this.isSaved,
    this.sourceName,
    this.categoryName,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      id: json['id'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      imageUrl: json['imageUrl'] as String?,
      categoryId: json['categoryId'] as String?,
      sourceId: json['sourceId'] as String?,
      sourceProfilePictureUrl: json['sourceProfilePictureUrl'] as String?,
      sourceTitle: json['sourceTitle'] as String?,
      publishedAt: json['publishedAt'] as String?,
      isLatest: json['isLatest'] as bool?,
      isPopular: json['isPopular'] as bool?,
      colorCode: json['colorCode'] as String?,
      isSaved: json['isSaved'] as bool?,
      sourceName: json['sourceName'] as String?,
      categoryName: json['categoryName'] as String?,
    );
  }

  Items copyWith({
    String? id,
    String? title,
    String? categoryId,
    String? categoryName,
    bool? isSaved,
    String? imageUrl,
    String? publishedAt,
    String? sourceName,
  }) {
    return Items(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      isSaved: isSaved ?? this.isSaved,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      sourceName: title ?? this.sourceName,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['imageUrl'] = imageUrl;
    data['categoryId'] = categoryId;
    data['sourceId'] = sourceId;
    data['sourceProfilePictureUrl'] = sourceProfilePictureUrl;
    data['sourceTitle'] = sourceTitle;
    data['publishedAt'] = publishedAt;
    data['isLatest'] = isLatest;
    data['isPopular'] = isPopular;
    data['colorCode'] = colorCode;
    data['isSaved'] = isSaved;
    data['sourceName'] = sourceName;
    data['categoryName'] = categoryName;
    return data;
  }
}
