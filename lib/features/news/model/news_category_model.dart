import 'package:flutter_mytech_case/features/news/model/news_list_response.dart';

class NewsCategoryModel {
  String? categoryId;
  String? categoryName;
  List<Items>? items;

  NewsCategoryModel({this.categoryId, this.categoryName, this.items});

  NewsCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    if (items != null) {
      data['Items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  NewsCategoryModel copyWith({String? categoryId, String? categoryName, List<Items>? items}) {
    return NewsCategoryModel(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      items: items ?? this.items,
    );
  }
}
