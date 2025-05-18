import '../../course/materials/test/model/mcq_test_details_model.dart';

class MockQuizResponse {
  bool? success;
  String? message;
  MockQuizData? data;

  MockQuizResponse({this.success, this.message, this.data});

  factory MockQuizResponse.fromJson(Map<String, dynamic> json) {
    return MockQuizResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? MockQuizData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class MockQuizData {
  String? id;
  Student? student;
  List<Category>? categories;
  String? type;
  int? time;
  int? questionCount;
  bool? isNegativeMarking;
  String? questionType;
  List<QuestionList>? questions;

  MockQuizData({
    this.id,
    this.student,
    this.categories,
    this.type,
    this.time,
    this.questionCount,
    this.isNegativeMarking,
    this.questionType,
    this.questions,
  });

  factory MockQuizData.fromJson(Map<String, dynamic> json) {
    return MockQuizData(
      id: json['_id'],
      student: json['student_id'] != null ? Student.fromJson(json['student_id']) : null,
      categories: (json['category_id'] as List?)?.map((e) => Category.fromJson(e)).toList(),
      type: json['type'],
      time: json['time'],
      questionCount: json['questionCount'],
      isNegativeMarking: json['isNegativeMarking'],
      questionType: json['questionType'],
      questions: (json['questions'] as List?)?.map((e) => QuestionList.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'student_id': student?.toJson(),
      'category_id': categories?.map((e) => e.toJson()).toList(),
      'type': type,
      'time': time,
      'questionCount': questionCount,
      'isNegativeMarking': isNegativeMarking,
      'questionType': questionType,
      'questions': questions?.map((e) => e.toJson()).toList(),
    };
  }
}

class Student {
  String? id;
  String? userId;
  String? studentId;
  String? name;
  String? categoryType;
  String? phone;
  String? email;

  Student({
    this.id,
    this.userId,
    this.studentId,
    this.name,
    this.categoryType,
    this.phone,
    this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      userId: json['user_id'],
      studentId: json['studentId'],
      name: json['name'],
      categoryType: json['categoryType'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'studentId': studentId,
      'name': name,
      'categoryType': categoryType,
      'phone': phone,
      'email': email,
    };
  }
}

class Category {
  String? id;
  String? type;
  String? division;
  String? subject;
  String? chapter;

  Category({
    this.id,
    this.type,
    this.division,
    this.subject,
    this.chapter,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      type: json['type'],
      division: json['division'],
      subject: json['subject'],
      chapter: json['chapter'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'division': division,
      'subject': subject,
      'chapter': chapter,
    };
  }
}

class Question {
  String? id;
  String? type;
  String? categoryId;
  String? title;
  String? description;
  List<String>? options;
  String? correctOption;

  Question({
    this.id,
    this.type,
    this.categoryId,
    this.title,
    this.description,
    this.options,
    this.correctOption,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'],
      type: json['type'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'],
      options: List<String>.from(json['options'] ?? []),
      correctOption: json['correctOption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'options': options,
      'correctOption': correctOption,
    };
  }
}
