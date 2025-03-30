class FlashcardResponse {
  bool? success;
  String? message;
  FlashcardData? data;

  FlashcardResponse({this.success, this.message, this.data});

  FlashcardResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? FlashcardData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class FlashcardData {
  MetaData? meta;
  List<Flashcard>? data;

  FlashcardData({this.meta, this.data});

  FlashcardData.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? MetaData.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <Flashcard>[];
      json['data'].forEach((v) {
        data!.add(Flashcard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MetaData {
  int? page;
  int? limit;
  int? count;

  MetaData({this.page, this.limit, this.count});

  MetaData.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['count'] = count;
    return data;
  }
}

class Flashcard {
  String? sId;
  String? title;
  String? visibility;
  Category? categoryId;
  Student? studentId;
  bool? isApproved;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Flashcard({
    this.sId,
    this.title,
    this.visibility,
    this.categoryId,
    this.studentId,
    this.isApproved,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Flashcard.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    visibility = json['visibility'];
    categoryId = json['categoryId'] != null
        ? Category.fromJson(json['categoryId'])
        : null;
    studentId =
        json['studentId'] != null ? Student.fromJson(json['studentId']) : null;
    isApproved = json['isApproved'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['visibility'] = visibility;
    if (categoryId != null) {
      data['categoryId'] = categoryId!.toJson();
    }
    if (studentId != null) {
      data['studentId'] = studentId!.toJson();
    }
    data['isApproved'] = isApproved;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Category {
  String? sId;
  String? type;
  String? division;
  String? subject;
  String? chapter;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Category({
    this.sId,
    this.type,
    this.subject,
    this.division,
    this.chapter,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    division = json['division'];
    subject = json['subject'];
    chapter = json['chapter'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['type'] = type;
    data['division'] = division;
    data['subject'] = subject;
    data['chapter'] = chapter;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Student {
  String? sId;
  String? userId;
  String? studentId;
  String? name;
  String? categoryType;
  String? phone;
  String? email;
  List<dynamic>? enrolledCourses;
  dynamic subscriptionStartDate;
  dynamic subscriptionEndDate;
  String? createdAt;
  String? updatedAt;

  Student({
    this.sId,
    this.userId,
    this.studentId,
    this.name,
    this.categoryType,
    this.phone,
    this.email,
    this.enrolledCourses,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.createdAt,
    this.updatedAt,
  });

  Student.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    studentId = json['studentId'];
    name = json['name'];
    categoryType = json['categoryType'];
    phone = json['phone'];
    email = json['email'];
    enrolledCourses = json['enrolledCourses'];
    subscriptionStartDate = json['subscriptionStartDate'];
    subscriptionEndDate = json['subscriptionEndDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['studentId'] = studentId;
    data['name'] = name;
    data['categoryType'] = categoryType;
    data['phone'] = phone;
    data['email'] = email;
    data['enrolledCourses'] = enrolledCourses;
    data['subscriptionStartDate'] = subscriptionStartDate;
    data['subscriptionEndDate'] = subscriptionEndDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
