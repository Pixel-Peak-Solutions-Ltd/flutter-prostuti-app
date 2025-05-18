import 'package:prostuti/features/course/materials/test/model/test_history_model.dart';

class MCQQuizResultModel {
  bool? success;
  String? message;
  Data? data;

  MCQQuizResultModel({this.success, this.message, this.data});

  MCQQuizResultModel.fromJson(Map<String, dynamic> json) {
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
  List<Questions>? questions;
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
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
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
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
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
  Category? category;
  ImageDetails? imageDetails;
  bool? isSubscribed;

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
        this.category,
        this.imageDetails,
        this.isSubscribed});

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
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    imageDetails = json['image'] != null ? new ImageDetails.fromJson(json['image']) : null;
    isSubscribed = json['isSubscribed'];
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
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.imageDetails != null) {
      data['image'] = this.imageDetails!.toJson();
    }
    data['isSubscribed'] = this.isSubscribed;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mainCategory'] = this.mainCategory;
    return data;
  }
}

class ImageDetails {
  String? diskType;
  String? path;
  String? originalName;
  String? modifiedName;
  String? fileId;

  ImageDetails(
      {this.diskType,
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

class CategoryId {
  String? lesson;
  String? sId;
  String? type;
  String? division;
  String? subject;
  String? chapter;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? universityType;
  String? universityName;

  CategoryId(
      {this.lesson,
        this.sId,
        this.type,
        this.division,
        this.subject,
        this.chapter,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.universityType,
        this.universityName});

  CategoryId.fromJson(Map<String, dynamic> json) {
    lesson = json['lesson'];
    sId = json['_id'];
    type = json['type'];
    division = json['division'];
    subject = json['subject'];
    chapter = json['chapter'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    universityType = json['universityType'];
    universityName = json['universityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lesson'] = this.lesson;
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['division'] = this.division;
    data['subject'] = this.subject;
    data['chapter'] = this.chapter;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['universityType'] = this.universityType;
    data['universityName'] = this.universityName;
    return data;
  }
}
class Questions {
  bool? hasImage;
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

  Questions(
      {this.hasImage,
        this.sId,
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

  Questions.fromJson(Map<String, dynamic> json) {
    hasImage = json['hasImage'];
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
    data['hasImage'] = this.hasImage;
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
