// Updated category_model.dart
class Category {
  bool? success;
  String? message;
  Meta? meta;
  List<String>? data;

  Category({this.success, this.message, this.meta, this.data});

  Category.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    data['data'] = this.data;
    return data;
  }
}

class Meta {
  int? count;

  Meta({this.count});

  Meta.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = this.count;
    return data;
  }
}

// New models for structured categories
class CategoryStructure {
  List<String>? mainCategories;
  Map<String, List<String>>? subCategories;

  CategoryStructure({this.mainCategories, this.subCategories});

  CategoryStructure.fromJson(Map<String, dynamic> json) {
    mainCategories = json['mainCategories']?.cast<String>();

    subCategories = <String, List<String>>{};
    if (json['subCategories'] != null) {
      json['subCategories'].forEach((key, value) {
        subCategories![key] = List<String>.from(value);
      });
    }
  }
}

class StudentCategory {
  String mainCategory;
  String? subCategory;

  StudentCategory({required this.mainCategory, this.subCategory});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mainCategory'] = mainCategory;
    if (subCategory != null) {
      data['subCategory'] = subCategory;
    }
    return data;
  }

  factory StudentCategory.fromJson(Map<String, dynamic> json) {
    return StudentCategory(
      mainCategory: json['mainCategory'],
      subCategory: json['subCategory'],
    );
  }
}
