class PublishedCourse {
  bool? success;
  String? message;
  List<PublishedCourseData>? data;

  PublishedCourse({this.success, this.message, this.data});

  PublishedCourse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PublishedCourseData>[];
      json['data'].forEach((v) {
        data!.add(PublishedCourseData.fromJson(v));
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

class PublishedCourseData {
  String? sId;
  String? teacherId;
  String? name;
  Image? image;
  String? details;
  int? price;
  String? priceType;
  Category? category;

  PublishedCourseData(
      {this.sId,
      this.teacherId,
      this.name,
      this.image,
      this.details,
      this.price,
      this.priceType,
      this.category});

  PublishedCourseData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    teacherId = json['teacher_id'];
    name = json['name'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    details = json['details'];
    price = json['price'];
    priceType = json['priceType'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['teacher_id'] = teacherId;
    data['name'] = name;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['details'] = details;
    data['price'] = price;
    data['priceType'] = priceType;
    if (category != null) {
      data['category'] = category!.toJson();
    }
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

class Category {
  String? sId;
  String? type;
  String? division;
  String? subject;
  String? chapter;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Category(
      {this.sId,
      this.type,
      this.division,
      this.subject,
      this.chapter,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    division = json['division'];
    subject = json['subject'];
    chapter = json['chapter'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['type'] = type;
    data['division'] = division;
    data['subject'] = subject;
    data['chapter'] = chapter;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
