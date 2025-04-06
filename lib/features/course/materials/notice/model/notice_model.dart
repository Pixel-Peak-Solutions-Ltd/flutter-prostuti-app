class Notice {
  bool? success;
  String? message;
  List<NoticeData>? data;

  Notice({this.success, this.message, this.data});

  Notice.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NoticeData>[];
      json['data'].forEach((v) {
        data!.add(NoticeData.fromJson(v));
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

class NoticeData {
  String? sId;
  String? courseId;
  String? notice;
  String? createdAt;
  String? updatedAt;

  NoticeData({
    this.sId,
    this.courseId,
    this.notice,
    this.createdAt,
    this.updatedAt,
  });

  NoticeData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseId = json['course_id'];
    notice = json['notice'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['course_id'] = courseId;
    data['notice'] = notice;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
