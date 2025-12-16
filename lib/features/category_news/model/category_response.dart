class CategoryResponse {
  String? id;
  String? name;
  String? description;
  String? colorCode;
  String? imageUrl;

  CategoryResponse({this.id, this.name, this.description, this.colorCode, this.imageUrl});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    colorCode = json['colorCode'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['colorCode'] = colorCode;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
