class AssignmentList {
  bool? success;
  String? message;
  List<AssignmentListData>? data;

  AssignmentList({this.success, this.message, this.data});

  AssignmentList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AssignmentListData>[];
      json['data'].forEach((v) {
        data!.add(AssignmentListData.fromJson(v));
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

class AssignmentListData {
  String? sId;
  LessonId? lessonId;
  String? assignmentNo;
  String? unlockDate;
  List<UploadFileResources>? uploadFileResources;

  AssignmentListData(
      {this.sId,
      this.lessonId,
      this.assignmentNo,
      this.unlockDate,
      this.uploadFileResources});

  AssignmentListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    lessonId =
        json['lesson_id'] != null ? LessonId.fromJson(json['lesson_id']) : null;
    assignmentNo = json['assignmentNo'];
    unlockDate = json['unlockDate'];
    if (json['uploadFileResources'] != null) {
      uploadFileResources = <UploadFileResources>[];
      json['uploadFileResources'].forEach((v) {
        uploadFileResources!.add(UploadFileResources.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (lessonId != null) {
      data['lesson_id'] = lessonId!.toJson();
    }
    data['assignmentNo'] = assignmentNo;
    data['unlockDate'] = unlockDate;
    if (uploadFileResources != null) {
      data['uploadFileResources'] =
          uploadFileResources!.map((v) => v.toJson()).toList();
    }
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
