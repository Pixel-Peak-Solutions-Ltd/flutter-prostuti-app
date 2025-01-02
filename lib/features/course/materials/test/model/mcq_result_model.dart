class MCQResult {
  bool? success;
  String? message;
  Data? data;

  MCQResult({this.success, this.message, this.data});

  MCQResult.fromJson(Map<String, dynamic> json) {
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
  String? courseId;
  String? lessonId;
  String? testId;
  String? studentId;
  double? score;
  int? totalScore;
  int? wrongScore;
  int? rightScore;
  List<Answers>? answers;
  bool? isPassed;
  int? timeTaken;
  String? sId;
  String? attemptedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.courseId,
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
        this.sId,
        this.attemptedAt,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    courseId = json['course_id'];
    lessonId = json['lesson_id'];
    testId = json['test_id'];
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
    sId = json['_id'];
    attemptedAt = json['attemptedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_id'] = this.courseId;
    data['lesson_id'] = this.lessonId;
    data['test_id'] = this.testId;
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
    data['_id'] = this.sId;
    data['attemptedAt'] = this.attemptedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Answers {
  String? questionId;
  String? selectedOption;
  String? sId;

  Answers({this.questionId, this.selectedOption, this.sId});

  Answers.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    selectedOption = json['selectedOption'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['selectedOption'] = this.selectedOption;
    data['_id'] = this.sId;
    return data;
  }
}
