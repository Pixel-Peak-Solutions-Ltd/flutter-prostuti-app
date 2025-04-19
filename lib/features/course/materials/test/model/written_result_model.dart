class WrittenResultModel {
  bool? success;
  String? message;
  Data? data;

  WrittenResultModel({this.success, this.message, this.data});

  WrittenResultModel.fromJson(Map<String, dynamic> json) {
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
  String? lessonId;
  TestId? testId;
  String? studentId;
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
    courseId = json['course_id'];
    lessonId = json['lesson_id'];
    testId =
    json['test_id'] != null ? new TestId.fromJson(json['test_id']) : null;
    studentId = json['student_id'];
    score = json['score'];
    totalScore = json['totalScore'];
    wrongScore = json['wrongScore'];
    rightScore = json['rightScore'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(new Answers.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['course_id'] = this.courseId;
    data['lesson_id'] = this.lessonId;
    if (this.testId != null) {
      data['test_id'] = this.testId!.toJson();
    }
    data['student_id'] = this.studentId;
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
    questionList = json['questionList'].cast<String>();
    createdBy = json['createdBy'];
    isCompleted = json['isCompleted'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class Answers {
  QuestionId? questionId;
  String? selectedOption;
  int? mark;
  String? sId;

  Answers({this.questionId, this.selectedOption, this.mark, this.sId});

  Answers.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'] != null
        ? new QuestionId.fromJson(json['question_id'])
        : null;
    selectedOption = json['selectedOption'];
    mark = json['mark'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questionId != null) {
      data['question_id'] = this.questionId!.toJson();
    }
    data['selectedOption'] = this.selectedOption;
    data['mark'] = this.mark;
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
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;
  QuizImage? image;

  QuestionId(
      {this.sId,
        this.type,
        this.categoryId,
        this.title,
        this.description,
        this.hasImage,
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
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    image = json['image'] != null ? new QuizImage.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['hasImage'] = this.hasImage;
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
