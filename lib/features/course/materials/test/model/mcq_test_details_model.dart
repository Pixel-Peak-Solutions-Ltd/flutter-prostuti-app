class MCQTestDetails {
  bool? success;
  String? message;
  Data? data;

  MCQTestDetails({this.success, this.message, this.data});

  MCQTestDetails.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? courseId;
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseId = json['course_id'];
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
    data['course_id'] = this.courseId;
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
  bool? hasImage;
  List<String>? options;
  String? correctOption;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;
  ImageDetails? image;

  QuestionList(
      {this.sId,
        this.type,
        this.categoryId,
        this.title,
        this.description,
        this.hasImage,
        this.options,
        this.correctOption,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.image});

  QuestionList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    categoryId = json['category_id'];
    title = json['title'];
    description = json['description'];
    hasImage = json['hasImage'];
    options = json['options'].cast<String>();
    correctOption = json['correctOption'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    image = json['image'] != null ? new ImageDetails.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['hasImage'] = this.hasImage;
    data['options'] = this.options;
    data['correctOption'] = this.correctOption;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class ImageDetails {
  String? diskType;
  String? path;
  String? originalName;
  String? modifiedName;
  String? fileId;

  ImageDetails({this.diskType,
    this.path,
    this.originalName,
    this.modifiedName,
    this.fileId});

  ImageDetails.fromJson(Map<String, dynamic> json) {
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
