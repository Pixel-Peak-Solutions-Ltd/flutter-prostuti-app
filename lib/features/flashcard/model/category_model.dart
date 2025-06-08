class Category {
  final String? sId;
  final String? type;
  final String? subject;
  final String? chapter;
  final String? lesson;

  // Academic specific
  final String? division;

  // Job specific
  final String? jobType;
  final String? jobName;

  // Admission specific
  final String? universityType;
  final String? universityName;
  final String? unit;

  final String? createdAt;
  final String? updatedAt;

  Category({
    this.sId,
    this.type,
    this.subject,
    this.chapter,
    this.lesson,
    this.division,
    this.jobType,
    this.jobName,
    this.universityType,
    this.universityName,
    this.unit,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      sId: json['_id'],
      type: json['type'],
      subject: json['subject'],
      chapter: json['chapter'],
      lesson: json['lesson'],
      division: json['division'],
      jobType: json['jobType'],
      jobName: json['jobName'],
      universityType: json['universityType'],
      universityName: json['universityName'],
      unit: json['unit'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'type': type,
      'subject': subject,
      'chapter': chapter,
      'lesson': lesson,
      'division': division,
      'jobType': jobType,
      'jobName': jobName,
      'universityType': universityType,
      'universityName': universityName,
      'unit': unit,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'meta': meta?.toJson(),
      'data': data?.map((x) => x.toJson()).toList(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'count': count,
    };
  }
}
