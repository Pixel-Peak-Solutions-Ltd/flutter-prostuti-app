class WrittenTestList {
  bool? success;
  String? message;
  Data? data;

  WrittenTestList({this.success, this.message, this.data});

  WrittenTestList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Meta? meta;
  List<WrittenTestDataList>? data;

  Data({this.meta, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <WrittenTestDataList>[];
      json['data'].forEach((v) {
        data!.add(new WrittenTestDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? page;
  int? limit;
  int? count;

  Meta({this.page, this.limit, this.count});

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['count'] = this.count;
    return data;
  }
}

class WrittenTestDataList {
  String? sId;
  CourseId? courseId;
  LessonId? lessonId;
  String? name;
  String? type;
  int? time;
  String? publishDate;
  List<QuestionList>? questionList;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  WrittenTestDataList(
      {this.sId,
        this.courseId,
        this.lessonId,
        this.name,
        this.type,
        this.time,
        this.publishDate,
        this.questionList,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.iV});

  WrittenTestDataList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseId = json['course_id'] != null
        ? new CourseId.fromJson(json['course_id'])
        : null;
    lessonId = json['lesson_id'] != null
        ? new LessonId.fromJson(json['lesson_id'])
        : null;
    name = json['name'];
    type = json['type'];
    time = json['time'];
    publishDate = json['publishDate'];
    if (json['questionList'] != null) {
      questionList = <QuestionList>[];
      json['questionList'].forEach((v) {
        questionList!.add(new QuestionList.fromJson(v));
      });
    }
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.courseId != null) {
      data['course_id'] = this.courseId!.toJson();
    }
    if (this.lessonId != null) {
      data['lesson_id'] = this.lessonId!.toJson();
    }
    data['name'] = this.name;
    data['type'] = this.type;
    data['time'] = this.time;
    data['publishDate'] = this.publishDate;
    if (this.questionList != null) {
      data['questionList'] = this.questionList!.map((v) => v.toJson()).toList();
    }
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class CourseId {
  String? sId;
  String? teacherId;
  String? name;
  String? categoryId;
  QuizImage? image;
  String? details;
  bool? isPending;
  bool? isPublished;
  String? createdAt;
  String? updatedAt;

  CourseId(
      {this.sId,
        this.teacherId,
        this.name,
        this.categoryId,
        this.image,
        this.details,
        this.isPending,
        this.isPublished,
        this.createdAt,
        this.updatedAt});

  CourseId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    teacherId = json['teacher_id'];
    name = json['name'];
    categoryId = json['category_id'];
    image = json['image'] != null ? new QuizImage.fromJson(json['image']) : null;
    details = json['details'];
    isPending = json['isPending'];
    isPublished = json['isPublished'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['teacher_id'] = this.teacherId;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    data['details'] = this.details;
    data['isPending'] = this.isPending;
    data['isPublished'] = this.isPublished;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class QuizImage {
  String? diskType;
  String? path;
  String? originalName;
  String? modifiedName;
  String? fileId;

  QuizImage(
      {this.diskType,
        this.path,
        this.originalName,
        this.modifiedName,
        this.fileId});

  QuizImage.fromJson(Map<String, dynamic> json) {
    diskType = json['diskType'];
    path = json['path'];
    originalName = json['originalName'];
    modifiedName = json['modifiedName'];
    fileId = json['fileId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diskType'] = this.diskType;
    data['path'] = this.path;
    data['originalName'] = this.originalName;
    data['modifiedName'] = this.modifiedName;
    data['fileId'] = this.fileId;
    return data;
  }
}

class LessonId {
  String? sId;
  String? number;
  String? name;
  String? courseId;
  String? createdAt;
  String? updatedAt;

  LessonId(
      {this.sId,
        this.number,
        this.name,
        this.courseId,
        this.createdAt,
        this.updatedAt});

  LessonId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    number = json['number'];
    name = json['name'];
    courseId = json['course_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['number'] = this.number;
    data['name'] = this.name;
    data['course_id'] = this.courseId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class QuestionList {
  String? sId;
  String? type;
  String? categoryId;
  String? title;
  String? description;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  QuestionList(
      {this.sId,
        this.type,
        this.categoryId,
        this.title,
        this.description,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.iV});

  QuestionList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    categoryId = json['category_id'];
    title = json['title'];
    description = json['description'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
