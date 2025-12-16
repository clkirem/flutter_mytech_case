class NewsByCategoryResponse {
  List<CategoryNewsItems>? items;
  int? total;
  int? page;
  int? pageSize;

  NewsByCategoryResponse({this.items, this.total, this.page, this.pageSize});

  factory NewsByCategoryResponse.fromJson(Map<String, dynamic> json) {
    return NewsByCategoryResponse(
      items: (json['items'] as List?)?.map((v) => CategoryNewsItems.fromJson(v as Map<String, dynamic>)).toList(),
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

class CategoryNewsItems {
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

  CategoryNewsItems({
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

  factory CategoryNewsItems.fromJson(Map<String, dynamic> json) {
    return CategoryNewsItems(
      id: json['_id'] as String?,
      title: json['_title'] as String?,
      content: json['_content'] as String?,
      imageUrl: json['_imageUrl'] as String?,
      categoryId: json['_categoryId'] as String?,
      sourceId: json['_sourceId'] as String?,
      sourceProfilePictureUrl: json['_sourceProfilePictureUrl'] as String?,
      sourceTitle: json['_sourceTitle'] as String?,
      publishedAt: json['_publishedAt'] as String?,
      isLatest: json['_isLatest'] as bool?,
      isPopular: json['_isPopular'] as bool?,
      colorCode: json['_colorCode'] as String?,
      isSaved: json['_isSaved'] as bool?,
      sourceName: json['_sourceName'] as String?,
      categoryName: json['_categoryName'] as String?,
    );
  }

  CategoryNewsItems copyWith({String? id, String? title, String? categoryId, String? categoryName, bool? isSaved}) {
    return CategoryNewsItems(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      isSaved: isSaved ?? this.isSaved,
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
