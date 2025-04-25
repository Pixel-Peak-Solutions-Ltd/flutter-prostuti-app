// course_review_model.dart
class CourseReviewResponse {
  final bool success;
  final String message;
  final List<CourseReview> data;

  CourseReviewResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CourseReviewResponse.fromJson(Map<String, dynamic> json) {
    return CourseReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((review) => CourseReview.fromJson(review))
              .toList() ??
          [],
    );
  }
}

class CourseReview {
  final String id;
  final String courseId;
  final StudentInfo studentInfo;
  final String review;
  final int rating;
  final bool isArrived;
  final String createdAt;
  final String updatedAt;

  CourseReview({
    required this.id,
    required this.courseId,
    required this.studentInfo,
    required this.review,
    required this.rating,
    required this.isArrived,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseReview.fromJson(Map<String, dynamic> json) {
    return CourseReview(
      id: json['_id'] ?? '',
      courseId: json['course_id'] ?? '',
      studentInfo: StudentInfo.fromJson(json['student_id'] ?? {}),
      review: json['review'] ?? '',
      rating: json['rating'] ?? 0,
      isArrived: json['isArrived'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class StudentImage {
  final String diskType;
  final String path;
  final String originalName;
  final String modifiedName;
  final String fileId;

  StudentImage({
    required this.diskType,
    required this.path,
    required this.originalName,
    required this.modifiedName,
    required this.fileId,
  });

  factory StudentImage.fromJson(Map<String, dynamic> json) {
    return StudentImage(
      diskType: json['diskType'] ?? '',
      path: json['path'] ?? '',
      originalName: json['originalName'] ?? '',
      modifiedName: json['modifiedName'] ?? '',
      fileId: json['fileId'] ?? '',
    );
  }
}

class StudentInfo {
  final String id;
  final String userId;
  final String studentId;
  final String name;
  final String email;
  final String? phone;
  final StudentImage? image;

  StudentInfo({
    required this.id,
    required this.userId,
    required this.studentId,
    required this.name,
    required this.email,
    this.phone,
    this.image,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      studentId: json['studentId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] as String?,
      image:
          json['image'] != null ? StudentImage.fromJson(json['image']) : null,
    );
  }
}
