import 'package:flutter_mytech_case/features/news_source/model/source_response.dart';

class SourceCategoryModel {
  String? sourceCategoryId;
  String? sourceCategoryTitle;
  List<Sources>? sources;

  SourceCategoryModel({this.sourceCategoryId, this.sourceCategoryTitle, this.sources});

  SourceCategoryModel.fromJson(Map<String, dynamic> json) {
    sourceCategoryId = json['sourceCategoryId'];
    sourceCategoryTitle = json['sourceCategoryTitle'];
    if (json['sources'] != null) {
      sources = <Sources>[];
      json['sources'].forEach((v) {
        sources!.add(new Sources.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sourceCategoryId'] = sourceCategoryId;
    data['sourceCategoryTitle'] = sourceCategoryTitle;
    if (sources != null) {
      data['sources'] = sources!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
