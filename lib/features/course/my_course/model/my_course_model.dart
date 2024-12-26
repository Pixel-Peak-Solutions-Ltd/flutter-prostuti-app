class EnrolledCourseList {
  bool? success;
  String? message;
  Data? data;

  EnrolledCourseList({this.success, this.message, this.data});

  EnrolledCourseList.fromJson(Map<String, dynamic> json) {
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
  Meta? meta;
  List<EnrolledCourseListData>? data;

  Data({this.meta, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <EnrolledCourseListData>[];
      json['data'].forEach((v) {
        data!.add(EnrolledCourseListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? page;
  int? limit;
  int? count;

  Meta({this.page, this.limit, this.count});

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['count'] = count;
    return data;
  }
}

class EnrolledCourseListData {
  String? sId;
  String? studentId;
  CourseId? courseId;
  String? enrollmentType;
  String? enrolledAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? paymentId;

  EnrolledCourseListData(
      {this.sId,
      this.studentId,
      this.courseId,
      this.enrollmentType,
      this.enrolledAt,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.paymentId});

  EnrolledCourseListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    studentId = json['student_id'];
    courseId =
        json['course_id'] != null ? CourseId.fromJson(json['course_id']) : null;
    enrollmentType = json['enrollmentType'];
    enrolledAt = json['enrolledAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    paymentId = json['payment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['student_id'] = studentId;
    if (courseId != null) {
      data['course_id'] = courseId!.toJson();
    }
    data['enrollmentType'] = enrollmentType;
    data['enrolledAt'] = enrolledAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['payment_id'] = paymentId;
    return data;
  }
}

class CourseId {
  String? sId;
  String? teacherId;
  String? name;
  String? categoryId;
  Image? image;
  String? details;
  bool? isPending;
  bool? isPublished;
  String? createdAt;
  String? updatedAt;
  String? approvedBy;
  int? price;
  String? priceType;

  CourseId(
      {this.sId,
      this.teacherId,
      this.name,
      this.categoryId,
      this.image,
      this.details,
      this.isPending,
      this.isPublished,
      this.createdAt,
      this.updatedAt,
      this.approvedBy,
      this.price,
      this.priceType});

  CourseId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    teacherId = json['teacher_id'];
    name = json['name'];
    categoryId = json['category_id'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    details = json['details'];
    isPending = json['isPending'];
    isPublished = json['isPublished'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    approvedBy = json['approvedBy'];
    price = json['price'];
    priceType = json['priceType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['teacher_id'] = teacherId;
    data['name'] = name;
    data['category_id'] = categoryId;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['details'] = details;
    data['isPending'] = isPending;
    data['isPublished'] = isPublished;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['approvedBy'] = approvedBy;
    data['price'] = price;
    data['priceType'] = priceType;
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
