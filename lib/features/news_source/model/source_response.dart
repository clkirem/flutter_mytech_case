class SourceListResponse {
  List<Sources>? sources;

  SourceListResponse({this.sources});

  SourceListResponse.fromJson(Map<String, dynamic> json) {
    if (json['sources'] != null) {
      sources = <Sources>[];
      json['sources'].forEach((v) {
        sources!.add(Sources.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sources != null) {
      data['sources'] = sources!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sources {
  String? id;
  String? name;
  String? description;
  String? imageUrl;
  String? sourceCategoryId;
  String? sourceCategoryTitle;
  bool? isFollowed;

  Sources({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.sourceCategoryId,
    this.sourceCategoryTitle,
    this.isFollowed,
  });

  Sources.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    sourceCategoryId = json['sourceCategoryId'];
    sourceCategoryTitle = json['sourceCategoryTitle'];
    isFollowed = json['isFollowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['sourceCategoryId'] = sourceCategoryId;
    data['sourceCategoryTitle'] = sourceCategoryTitle;
    data['isFollowed'] = isFollowed;
    return data;
  }
}
