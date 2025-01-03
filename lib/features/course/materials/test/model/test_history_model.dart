class TestHistory {
  bool? success;
  String? message;
  Data? data;

  TestHistory({this.success, this.message, this.data});

  TestHistory.fromJson(Map<String, dynamic> json) {
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
  num? score;
  int? totalScore;
  int? wrongScore;
  int? rightScore;
  List<Answers>? answers;
  bool? isPassed;
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
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isCompleted;

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
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.isCompleted});

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
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isCompleted = json['isCompleted'];
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
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['isCompleted'] = this.isCompleted;
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
        ? new QuestionId.fromJson(json['question_id'])
        : null;
    selectedOption = json['selectedOption'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  List<String>? options;
  String? correctOption;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  QuestionId(
      {this.sId,
        this.type,
        this.categoryId,
        this.title,
        this.description,
        this.options,
        this.correctOption,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.iV});

  QuestionId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    categoryId = json['category_id'];
    title = json['title'];
    description = json['description'];
    options = json['options'].cast<String>();
    correctOption = json['correctOption'];
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
    data['options'] = this.options;
    data['correctOption'] = this.correctOption;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
