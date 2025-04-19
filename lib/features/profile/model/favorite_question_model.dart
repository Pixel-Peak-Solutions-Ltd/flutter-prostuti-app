import 'package:prostuti/features/course/materials/test/model/written_test_model.dart';

class FavoriteQuestionModel {
  bool? success;
  String? message;
  List<Data>? data;

  FavoriteQuestionModel({this.success, this.message, this.data});

  FavoriteQuestionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? studentId;
  List<FavouriteQuestions>? favouriteQuestions;
  int? iV;

  Data({this.sId, this.studentId, this.favouriteQuestions, this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    studentId = json['student_id'];
    if (json['favourite_questions'] != null) {
      favouriteQuestions = <FavouriteQuestions>[];
      json['favourite_questions'].forEach((v) {
        favouriteQuestions!.add(new FavouriteQuestions.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['student_id'] = this.studentId;
    if (this.favouriteQuestions != null) {
      data['favourite_questions'] =
          this.favouriteQuestions!.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class FavouriteQuestions {
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
  List<dynamic>? options;
  String? correctOption;

  FavouriteQuestions(
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
        this.image,
        this.options,
        this.correctOption});

  FavouriteQuestions.fromJson(Map<String, dynamic> json) {
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
    options = json['options'];
    correctOption = json['correctOption'];
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
    data['options'] = this.options;
    data['correctOption'] = this.correctOption;
    return data;
  }
}
