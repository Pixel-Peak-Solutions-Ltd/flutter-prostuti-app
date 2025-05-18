class QuizSubmitModel {
  bool? success;
  String? message;
  Data? data;

  QuizSubmitModel({this.success, this.message, this.data});

  QuizSubmitModel.fromJson(Map<String, dynamic> json) {
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
  StudentId? studentId;
  List<CategoryId>? categoryId;
  String? type;
  int? time;
  int? questionCount;
  bool? isNegativeMarking;
  String? questionType;
  List<String>? questions;
  List<Answers>? answers;
  int? totalScore;
  int? score;
  int? rightScore;
  int? wrongScore;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? completedAt;

  Data(
      {this.sId,
        this.studentId,
        this.categoryId,
        this.type,
        this.time,
        this.questionCount,
        this.isNegativeMarking,
        this.questionType,
        this.questions,
        this.answers,
        this.totalScore,
        this.score,
        this.rightScore,
        this.wrongScore,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.completedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    studentId = json['student_id'] != null
        ? new StudentId.fromJson(json['student_id'])
        : null;
    if (json['category_id'] != null) {
      categoryId = <CategoryId>[];
      json['category_id'].forEach((v) {
        categoryId!.add(new CategoryId.fromJson(v));
      });
    }
    type = json['type'];
    time = json['time'];
    questionCount = json['questionCount'];
    isNegativeMarking = json['isNegativeMarking'];
    questionType = json['questionType'];
    questions = json['questions'].cast<String>();
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(new Answers.fromJson(v));
      });
    }
    totalScore = json['totalScore'];
    score = json['score'];
    rightScore = json['rightScore'];
    wrongScore = json['wrongScore'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    completedAt = json['completedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.studentId != null) {
      data['student_id'] = this.studentId!.toJson();
    }
    if (this.categoryId != null) {
      data['category_id'] = this.categoryId!.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    data['time'] = this.time;
    data['questionCount'] = this.questionCount;
    data['isNegativeMarking'] = this.isNegativeMarking;
    data['questionType'] = this.questionType;
    data['questions'] = this.questions;
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    data['totalScore'] = this.totalScore;
    data['score'] = this.score;
    data['rightScore'] = this.rightScore;
    data['wrongScore'] = this.wrongScore;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['completedAt'] = this.completedAt;
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
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  String? createdAt;
  String? updatedAt;

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
        this.updatedAt});

  StudentId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    studentId = json['studentId'];
    name = json['name'];
    categoryType = json['categoryType'];
    phone = json['phone'];
    email = json['email'];
    enrolledCourses = json['enrolledCourses'].cast<String>();
    subscriptionStartDate = json['subscriptionStartDate'];
    subscriptionEndDate = json['subscriptionEndDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    return data;
  }
}

class CategoryId {
  String? sId;
  String? type;
  String? division;
  String? subject;
  String? chapter;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CategoryId(
      {this.sId,
        this.type,
        this.division,
        this.subject,
        this.chapter,
        this.createdAt,
        this.updatedAt,
        this.iV});

  CategoryId.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['division'] = this.division;
    data['subject'] = this.subject;
    data['chapter'] = this.chapter;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Answers {
  String? questionId;
  String? selectedOption;
  int? mark;
  String? sId;

  Answers({this.questionId, this.selectedOption, this.mark, this.sId});

  Answers.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    selectedOption = json['selectedOption'];
    mark = json['mark'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['selectedOption'] = this.selectedOption;
    data['mark'] = this.mark;
    data['_id'] = this.sId;
    return data;
  }
}
