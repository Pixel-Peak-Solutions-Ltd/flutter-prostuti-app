class AllTestHistoryModel {
  bool? success;
  String? message;
  AllTestHistoryData? data;

  AllTestHistoryModel({this.success, this.message, this.data});

  AllTestHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? AllTestHistoryData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AllTestHistoryData {
  Meta? meta;
  List<Data>? data;

  AllTestHistoryData({this.meta, this.data});

  AllTestHistoryData.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['count'] = this.count;
    return data;
  }
}

class Data {
  String? sId;
  CourseId? courseId;
  LessonId? lessonId;
  TestId? testId;
  StudentId? studentId;
  int? score;
  int? totalScore;
  int? wrongScore;
  int? rightScore;
  List<Answers>? answers;
  bool? isPassed;
  bool? isChecked;
  int? timeTaken;
  String? attemptedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.courseId,
      this.lessonId,
      this.testId,
      this.studentId,
      this.score,
      this.totalScore,
      this.wrongScore,
      this.rightScore,
      this.answers,
      this.isPassed,
      this.isChecked,
      this.timeTaken,
      this.attemptedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseId =
        json['course_id'] != null ? CourseId.fromJson(json['course_id']) : null;
    lessonId =
        json['lesson_id'] != null ? LessonId.fromJson(json['lesson_id']) : null;
    testId = json['test_id'] != null ? TestId.fromJson(json['test_id']) : null;
    studentId = json['student_id'] != null
        ? StudentId.fromJson(json['student_id'])
        : null;
    score = json['score'];
    totalScore = json['totalScore'];
    wrongScore = json['wrongScore'];
    rightScore = json['rightScore'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
    isPassed = json['isPassed'];
    isChecked = json['isChecked'];
    timeTaken = json['timeTaken'];
    attemptedAt = json['attemptedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    if (this.courseId != null) {
      data['course_id'] = this.courseId!.toJson();
    }
    if (this.lessonId != null) {
      data['lesson_id'] = this.lessonId!.toJson();
    }
    if (this.testId != null) {
      data['test_id'] = this.testId!.toJson();
    }
    if (this.studentId != null) {
      data['student_id'] = this.studentId!.toJson();
    }
    data['score'] = this.score;
    data['totalScore'] = this.totalScore;
    data['wrongScore'] = this.wrongScore;
    data['rightScore'] = this.rightScore;
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    data['isPassed'] = this.isPassed;
    data['isChecked'] = this.isChecked;
    data['timeTaken'] = this.timeTaken;
    data['attemptedAt'] = this.attemptedAt;
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
  Image? image;
  String? details;
  bool? isPending;
  bool? isPublished;
  String? createdAt;
  String? updatedAt;
  int? price;
  String? priceType;
  String? approvedBy;

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
      this.updatedAt,
      this.price,
      this.priceType,
      this.approvedBy});

  CourseId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    teacherId = json['teacher_id'];
    name = json['name'];
    categoryId = json['category_id'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    details = json['details'];
    isPending = json['isPending'];
    isPublished = json['isPublished'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    price = json['price'];
    priceType = json['priceType'];
    approvedBy = json['approvedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['price'] = this.price;
    data['priceType'] = this.priceType;
    data['approvedBy'] = this.approvedBy;
    return data;
  }
}

class Image {
  String? diskType;
  String? path;
  String? originalName;
  String? modifiedName;
  String? fileId;

  Image(
      {this.diskType,
      this.path,
      this.originalName,
      this.modifiedName,
      this.fileId});

  Image.fromJson(Map<String, dynamic> json) {
    diskType = json['diskType'];
    path = json['path'];
    originalName = json['originalName'];
    modifiedName = json['modifiedName'];
    fileId = json['fileId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['number'] = this.number;
    data['name'] = this.name;
    data['course_id'] = this.courseId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class TestId {
  String? sId;
  String? courseId;
  String? lessonId;
  String? name;
  String? type;
  int? time;
  String? publishDate;
  List<String>? questionList;
  String? createdBy;
  bool? isCompleted;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  TestId(
      {this.sId,
      this.courseId,
      this.lessonId,
      this.name,
      this.type,
      this.time,
      this.publishDate,
      this.questionList,
      this.createdBy,
      this.isCompleted,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.iV});

  TestId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseId = json['course_id'];
    lessonId = json['lesson_id'];
    name = json['name'];
    type = json['type'];
    time = json['time'];
    publishDate = json['publishDate'];
    questionList = json['questionList']?.cast<String>();
    createdBy = json['createdBy'];
    isCompleted = json['isCompleted'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['course_id'] = this.courseId;
    data['lesson_id'] = this.lessonId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['time'] = this.time;
    data['publishDate'] = this.publishDate;
    data['questionList'] = this.questionList;
    data['createdBy'] = this.createdBy;
    data['isCompleted'] = this.isCompleted;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class StudentId {
  String? sId;
  String? userId;
  String? studentId;
  String? name;
  String? categoryType;
  String? phone;
  String? email;
  List<String>? enrolledCourses;
  dynamic subscriptionStartDate;
  dynamic subscriptionEndDate;
  String? createdAt;
  String? updatedAt;
  Category? category;

  StudentId(
      {this.sId,
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
      this.category});

  StudentId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    studentId = json['studentId'];
    name = json['name'];
    categoryType = json['categoryType'];
    phone = json['phone'];
    email = json['email'];
    enrolledCourses = json['enrolledCourses']?.cast<String>();
    subscriptionStartDate = json['subscriptionStartDate'];
    subscriptionEndDate = json['subscriptionEndDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['studentId'] = this.studentId;
    data['name'] = this.name;
    data['categoryType'] = this.categoryType;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['enrolledCourses'] = this.enrolledCourses;
    data['subscriptionStartDate'] = this.subscriptionStartDate;
    data['subscriptionEndDate'] = this.subscriptionEndDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Category {
  String? mainCategory;

  Category({this.mainCategory});

  Category.fromJson(Map<String, dynamic> json) {
    mainCategory = json['mainCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mainCategory'] = this.mainCategory;
    return data;
  }
}

class Answers {
  QuestionId? questionId;
  String? selectedOption;
  String? sId;

  Answers({this.questionId, this.selectedOption, this.sId});

  Answers.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'] != null
        ? QuestionId.fromJson(json['question_id'])
        : null;
    selectedOption = json['selectedOption'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.questionId != null) {
      data['question_id'] = this.questionId!.toJson();
    }
    data['selectedOption'] = this.selectedOption;
    data['_id'] = this.sId;
    return data;
  }
}

class QuestionId {
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
  Image? image;

  QuestionId(
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

  QuestionId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    categoryId = json['category_id'];
    title = json['title'];
    description = json['description'];
    hasImage = json['hasImage'];
    options = json['options']?.cast<String>();
    correctOption = json['correctOption'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
