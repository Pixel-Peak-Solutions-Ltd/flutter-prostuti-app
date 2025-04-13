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
    data = json['data'] != null ? List<String>.from(json['data']) : null;
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

class SubCategory {
  bool? success;
  String? message;
  Meta? meta;
  List<String>? data;

  SubCategory({this.success, this.message, this.meta, this.data});

  SubCategory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    data = json['data'] != null ? List<String>.from(json['data']) : null;
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

class CategoryConstants {
  static const String ACADEMIC = "Academic";
  static const String ADMISSION = "Admission";
  static const String JOB = "Job";

  // Subcategories for Academic
  static const String SCIENCE = "Science";
  static const String COMMERCE = "Commerce";
  static const String ARTS = "Arts";

  // Subcategories for Admission
  static const String ENGINEERING = "Engineering";
  static const String MEDICAL = "Medical";
  static const String UNIVERSITY = "University";

  // Get valid subcategories for a main category
  static List<String> getSubcategoriesFor(String mainCategory) {
    switch (mainCategory) {
      case ACADEMIC:
        return [SCIENCE, COMMERCE, ARTS];
      case ADMISSION:
        return [ENGINEERING, MEDICAL, UNIVERSITY];
      case JOB:
      default:
        return [];
    }
  }

  // Check if a subcategory is valid for a main category
  static bool isValidSubcategory(String mainCategory, String? subcategory) {
    if (subcategory == null) {
      return mainCategory == JOB;
    }
    return getSubcategoriesFor(mainCategory).contains(subcategory);
  }
}
