// Model for broadcast requests based on the API documentation
class BroadcastResponse {
  final bool? success;
  final String? message;
  final List<BroadcastRequest>? data;

  BroadcastResponse({
    this.success,
    this.message,
    this.data,
  });

  factory BroadcastResponse.fromJson(Map<String, dynamic> json) {
    return BroadcastResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? json['data'] is List
              ? List<BroadcastRequest>.from(
                  json['data'].map((x) => BroadcastRequest.fromJson(x)))
              : [
                  BroadcastRequest.fromJson(json['data'])
                ] // Wrap single object in a list
          : null,
    );
  }
}

class BroadcastRequest {
  final String? id;
  final String? studentId;
  final String? message;
  final String? subject;
  final String? status;
  final String? acceptedBy;
  final String? conversationId;
  final String? expiryTime;
  final String? createdAt;
  final String? updatedAt;
  final StudentInfo? student;

  BroadcastRequest({
    this.id,
    this.studentId,
    this.message,
    this.subject,
    this.status,
    this.acceptedBy,
    this.conversationId,
    this.expiryTime,
    this.createdAt,
    this.updatedAt,
    this.student,
  });

  factory BroadcastRequest.fromJson(Map<String, dynamic> json) {
    return BroadcastRequest(
      id: json['_id'],
      studentId: json['student_id'] is Map
          ? json['student_id']['_id']
          : json['student_id'],
      message: json['message'],
      subject: json['subject'],
      status: json['status'],
      acceptedBy: json['accepted_by'],
      conversationId: json['conversation_id'],
      expiryTime: json['expiry_time'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      student: json['student'] != null
          ? StudentInfo.fromJson(json['student'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'student_id': studentId,
      'message': message,
      'subject': subject,
      'status': status,
      'accepted_by': acceptedBy,
      'conversation_id': conversationId,
      'expiry_time': expiryTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class StudentInfo {
  final String? name;
  final String? categoryType;
  final String? registeredId;

  StudentInfo({
    this.name,
    this.categoryType,
    this.registeredId,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      name: json['name'],
      categoryType: json['categoryType'],
      registeredId: json['registeredId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'categoryType': categoryType,
      'registeredId': registeredId,
    };
  }
}
