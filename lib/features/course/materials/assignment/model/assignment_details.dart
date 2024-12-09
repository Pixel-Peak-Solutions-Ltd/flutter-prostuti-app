class AssignmentDetails {
  bool? success;
  String? message;
  Data? data;

  AssignmentDetails({this.success, this.message, this.data});

  AssignmentDetails.fromJson(Map<String, dynamic> json) {
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
  String? assignmentNo;
  int? marks;
  String? unlockDate;
  String? details;
  List<UploadFileResources>? uploadFileResources;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.sId,
      this.courseId,
      this.lessonId,
      this.assignmentNo,
      this.marks,
      this.unlockDate,
      this.details,
      this.uploadFileResources,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseId = json['course_id'];
    lessonId = json['lesson_id'];
    assignmentNo = json['assignmentNo'];
    marks = json['marks'];
    unlockDate = json['unlockDate'];
    details = json['details'];
    if (json['uploadFileResources'] != null) {
      uploadFileResources = <UploadFileResources>[];
      json['uploadFileResources'].forEach((v) {
        uploadFileResources!.add(UploadFileResources.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['course_id'] = courseId;
    data['lesson_id'] = lessonId;
    data['assignmentNo'] = assignmentNo;
    data['marks'] = marks;
    data['unlockDate'] = unlockDate;
    data['details'] = details;
    if (uploadFileResources != null) {
      data['uploadFileResources'] =
          uploadFileResources!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class UploadFileResources {
  String? diskType;
  String? path;
  String? originalName;
  String? modifiedName;
  String? fileId;

  UploadFileResources(
      {this.diskType,
      this.path,
      this.originalName,
      this.modifiedName,
      this.fileId});

  UploadFileResources.fromJson(Map<String, dynamic> json) {
    diskType = json['diskType'];
    path = json['path'];
    originalName = json['originalName'];
    modifiedName = json['modifiedName'];
    fileId = json['fileId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['diskType'] = diskType;
    data['path'] = path;
    data['originalName'] = originalName;
    data['modifiedName'] = modifiedName;
    data['fileId'] = fileId;
    return data;
  }
}
