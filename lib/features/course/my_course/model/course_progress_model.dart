class CourseProgress {
  final String courseId;
  final double completed;

  CourseProgress({
    required this.courseId,
    required this.completed,
  });

  // Factory constructor to parse a JSON object into a CourseProgress instance
  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      courseId: json['course_id'],
      completed: json['completed'].toDouble(),
    );
  }
}

class CourseProgressResponse {
  final bool success;
  final String message;
  final List<CourseProgress> data;

  CourseProgressResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  // Factory constructor to parse a JSON object into a CourseProgressResponse instance
  factory CourseProgressResponse.fromJson(Map<String, dynamic> json) {
    return CourseProgressResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => CourseProgress.fromJson(item))
          .toList(),
    );
  }
}
