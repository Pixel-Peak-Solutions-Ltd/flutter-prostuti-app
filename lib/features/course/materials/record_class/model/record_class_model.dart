class RecordedClass {
  bool? success;
  String? message;
  List<RecordedClassData>? data;

  RecordedClass({this.success, this.message, this.data});

  RecordedClass.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RecordedClassData>[];
      json['data'].forEach((v) {
        data!.add(RecordedClassData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecordedClassData {
  String? sId;
  LessonId? lessonId;
  String? recodeClassName;
  String? classDate;
  List<String>? classVideoURL;

  RecordedClassData(
      {this.sId,
      this.lessonId,
      this.recodeClassName,
      this.classDate,
      this.classVideoURL});

  RecordedClassData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    lessonId =
        json['lesson_id'] != null ? LessonId.fromJson(json['lesson_id']) : null;
    recodeClassName = json['recodeClassName'];
    classDate = json['classDate'];
    classVideoURL = json['classVideoURL'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (lessonId != null) {
      data['lesson_id'] = lessonId!.toJson();
    }
    data['recodeClassName'] = recodeClassName;
    data['classDate'] = classDate;
    data['classVideoURL'] = classVideoURL;
    return data;
  }
}

class LessonId {
  String? sId;
  String? number;
  String? name;

  LessonId({this.sId, this.number, this.name});

  LessonId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    number = json['number'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['number'] = number;
    data['name'] = name;
    return data;
  }
}
