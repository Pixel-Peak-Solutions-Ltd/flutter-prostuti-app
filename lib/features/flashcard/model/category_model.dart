class Category {
  final String? sId;
  final String? type;
  final String? division;
  final String? subject;
  final String? chapter;
  final String? createdAt;
  final String? updatedAt;

  Category({
    this.sId,
    this.type,
    this.division,
    this.subject,
    this.chapter,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      sId: json['_id'],
      type: json['type'],
      division: json['division'],
      subject: json['subject'],
      chapter: json['chapter'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class CategoryResponse {
  final bool? success;
  final String? message;
  final CategoryMeta? meta;
  final List<Category>? data;

  CategoryResponse({
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      success: json['success'],
      message: json['message'],
      meta: json['meta'] != null ? CategoryMeta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<Category>.from(json['data'].map((x) => Category.fromJson(x)))
          : null,
    );
  }
}

class CategoryMeta {
  final int? page;
  final int? limit;
  final int? count;

  CategoryMeta({
    this.page,
    this.limit,
    this.count,
  });

  factory CategoryMeta.fromJson(Map<String, dynamic> json) {
    return CategoryMeta(
      page: json['page'],
      limit: json['limit'],
      count: json['count'],
    );
  }
}
