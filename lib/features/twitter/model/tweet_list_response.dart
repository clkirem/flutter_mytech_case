class TweetListResponse {
  late List<TweetModel> items;
  int? total;
  int? page;
  int? pageSize;

  TweetListResponse({required this.items, this.total, this.page, this.pageSize});

  TweetListResponse.fromJson(Map<String, dynamic> json) {
    items = (json['items'] as List).map((v) => TweetModel.fromJson(v)).toList();
    total = json['total'];
    page = json['page'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['page'] = page;
    data['pageSize'] = pageSize;
    return data;
  }
}

class TweetModel {
  String? id;
  String? accountId;
  String? accountName;
  String? accountImageUrl;
  String? content;
  String? createdAt;
  bool? isPopular;

  TweetModel({
    this.id,
    this.accountId,
    this.accountName,
    this.accountImageUrl,
    this.content,
    this.createdAt,
    this.isPopular,
  });

  TweetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountId = json['accountId'];
    accountName = json['accountName'];
    accountImageUrl = json['accountImageUrl'];
    content = json['content'];
    createdAt = json['createdAt'];
    isPopular = json['isPopular'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['accountId'] = accountId;
    data['accountName'] = accountName;
    data['accountImageUrl'] = accountImageUrl;
    data['content'] = content;
    data['createdAt'] = createdAt;
    data['isPopular'] = isPopular;
    return data;
  }
}
