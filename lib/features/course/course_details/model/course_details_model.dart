class CourseDetails {
  bool? success;
  String? message;
  Data? data;

  CourseDetails({this.success, this.message, this.data});

  CourseDetails.fromJson(Map<String, dynamic> json) {
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
  String? name;
  Image? image;
  String? details;
  List<Lessons>? lessons;
  int? totalLessons;
  int? totalRecodedClasses;
  int? totalResources;
  int? totalAssignments;
  int? totalTests;

  Data(
      {this.sId,
      this.name,
      this.image,
      this.details,
      this.lessons,
      this.totalLessons,
      this.totalRecodedClasses,
      this.totalResources,
      this.totalAssignments,
      this.totalTests});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    details = json['details'];
    if (json['lessons'] != null) {
      lessons = <Lessons>[];
      json['lessons'].forEach((v) {
        lessons!.add(Lessons.fromJson(v));
      });
    }
    totalLessons = json['totalLessons'];
    totalRecodedClasses = json['totalRecodedClasses'];
    totalResources = json['totalResources'];
    totalAssignments = json['totalAssignments'];
    totalTests = json['totalTests'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['details'] = details;
    if (lessons != null) {
      data['lessons'] = lessons!.map((v) => v.toJson()).toList();
    }
    data['totalLessons'] = totalLessons;
    data['totalRecodedClasses'] = totalRecodedClasses;
    data['totalResources'] = totalResources;
    data['totalAssignments'] = totalAssignments;
    data['totalTests'] = totalTests;
    return data;
  }
}

class Image {
  String? diskType;
  String? path;
  String? originalName;
  String? modifiedName;
  String? fileId;

  Image(
      {this.diskType,
      this.path,
      this.originalName,
      this.modifiedName,
      this.fileId});

  Image.fromJson(Map<String, dynamic> json) {
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

class Lessons {
  String? sId;
  String? number;
  String? name;
  List<RecodedClasses>? recodedClasses;
  List<Resources>? resources;
  List<Assignments>? assignments;
  List<Tests>? tests;
  int? recodedClassesCount;
  int? resourcesCount;
  int? assignmentsCount;
  int? testsCount;

  Lessons(
      {this.sId,
      this.number,
      this.name,
      this.recodedClasses,
      this.resources,
      this.assignments,
      this.tests,
      this.recodedClassesCount,
      this.resourcesCount,
      this.assignmentsCount,
      this.testsCount});

  Lessons.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    number = json['number'];
    name = json['name'];
    if (json['recodedClasses'] != null) {
      recodedClasses = <RecodedClasses>[];
      json['recodedClasses'].forEach((v) {
        recodedClasses!.add(RecodedClasses.fromJson(v));
      });
    }
    if (json['resources'] != null) {
      resources = <Resources>[];
      json['resources'].forEach((v) {
        resources!.add(Resources.fromJson(v));
      });
    }
    if (json['assignments'] != null) {
      assignments = <Assignments>[];
      json['assignments'].forEach((v) {
        assignments!.add(Assignments.fromJson(v));
      });
    }
    if (json['tests'] != null) {
      tests = <Tests>[];
      json['tests'].forEach((v) {
        tests!.add(Tests.fromJson(v));
      });
    }
    recodedClassesCount = json['recodedClassesCount'];
    resourcesCount = json['resourcesCount'];
    assignmentsCount = json['assignmentsCount'];
    testsCount = json['testsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['number'] = number;
    data['name'] = name;
    if (recodedClasses != null) {
      data['recodedClasses'] = recodedClasses!.map((v) => v.toJson()).toList();
    }
    if (resources != null) {
      data['resources'] = resources!.map((v) => v.toJson()).toList();
    }
    if (assignments != null) {
      data['assignments'] = assignments!.map((v) => v.toJson()).toList();
    }
    if (tests != null) {
      data['tests'] = tests!.map((v) => v.toJson()).toList();
    }
    data['recodedClassesCount'] = recodedClassesCount;
    data['resourcesCount'] = resourcesCount;
    data['assignmentsCount'] = assignmentsCount;
    data['testsCount'] = testsCount;
    return data;
  }
}

class RecodedClasses {
  String? sId;
  String? recodeClassName;
  String? classDate;
  String? classDetails;
  List<String>? classVideoURL;

  RecodedClasses(
      {this.sId,
      this.recodeClassName,
      this.classDate,
      this.classDetails,
      this.classVideoURL});

  RecodedClasses.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    recodeClassName = json['recodeClassName'];
    classDate = json['classDate'];
    classDetails = json['classDetails'];
    classVideoURL = json['classVideoURL'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['recodeClassName'] = recodeClassName;
    data['classDate'] = classDate;
    data['classDetails'] = classDetails;
    data['classVideoURL'] = classVideoURL;
    return data;
  }
}

class Resources {
  String? sId;
  String? name;
  String? resourceDate;
  List<UploadFileResources>? uploadFileResources;

  Resources({this.sId, this.name, this.resourceDate, this.uploadFileResources});

  Resources.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    resourceDate = json['resourceDate'];
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
    data['name'] = name;
    data['resourceDate'] = resourceDate;
    if (uploadFileResources != null) {
      data['uploadFileResources'] =
          uploadFileResources!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Assignments {
  String? sId;
  String? assignmentNo;
  int? marks;
  String? unlockDate;
  String? details;
  List<UploadFileResources>? uploadFileResources;

  Assignments(
      {this.sId,
      this.assignmentNo,
      this.marks,
      this.unlockDate,
      this.details,
      this.uploadFileResources});

  Assignments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['assignmentNo'] = assignmentNo;
    data['marks'] = marks;
    data['unlockDate'] = unlockDate;
    data['details'] = details;
    if (uploadFileResources != null) {
      data['uploadFileResources'] =
          uploadFileResources!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tests {
  String? sId;
  String? name;
  String? type;
  int? time;
  String? publishDate;

  Tests({this.sId, this.name, this.type, this.time, this.publishDate});

  Tests.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    type = json['type'];
    time = json['time'];
    publishDate = json['publishDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['type'] = type;
    data['time'] = time;
    data['publishDate'] = publishDate;
    return data;
  }
}
