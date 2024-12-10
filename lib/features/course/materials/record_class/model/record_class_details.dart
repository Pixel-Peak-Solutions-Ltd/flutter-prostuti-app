class RecordClassDetails {
  bool? success;
  String? message;
  Data? data;

  RecordClassDetails({this.success, this.message, this.data});

  RecordClassDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
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
  String? recodeClassName;
  String? classDate;
  String? classDetails;
  List<String>? classVideoURL;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.sId,
      this.courseId,
      this.lessonId,
      this.recodeClassName,
      this.classDate,
      this.classDetails,
      this.classVideoURL,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseId = json['course_id'];
    lessonId = json['lesson_id'];
    recodeClassName = json['recodeClassName'];
    classDate = json['classDate'];
    classDetails = json['classDetails'];
    classVideoURL = json['classVideoURL'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['course_id'] = courseId;
    data['lesson_id'] = lessonId;
    data['recodeClassName'] = recodeClassName;
    data['classDate'] = classDate;
    data['classDetails'] = classDetails;
    data['classVideoURL'] = classVideoURL;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
