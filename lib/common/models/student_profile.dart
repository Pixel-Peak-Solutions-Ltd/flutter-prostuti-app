class StudentProfile {
  bool? success;
  String? message;
  Data? data;

  StudentProfile({this.success, this.message, this.data});

  StudentProfile.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? studentId;
  String? name;
  String? categoryType;
  String? phone;
  String? email;
  List<String>? enrolledCourses;
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.sId,
      this.userId,
      this.studentId,
      this.name,
      this.categoryType,
      this.phone,
      this.email,
      this.enrolledCourses,
      this.subscriptionStartDate,
      this.subscriptionEndDate,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    studentId = json['studentId'];
    name = json['name'];
    categoryType = json['categoryType'];
    phone = json['phone'];
    email = json['email'];
    enrolledCourses = json['enrolledCourses'].cast<String>();
    subscriptionStartDate = json['subscriptionStartDate'];
    subscriptionEndDate = json['subscriptionEndDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['studentId'] = studentId;
    data['name'] = name;
    data['categoryType'] = categoryType;
    data['phone'] = phone;
    data['email'] = email;
    data['enrolledCourses'] = enrolledCourses;
    data['subscriptionStartDate'] = subscriptionStartDate;
    data['subscriptionEndDate'] = subscriptionEndDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
