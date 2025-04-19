// lib/features/payment/models/voucher_model.dart

class VoucherModel {
  final String? id;
  final String? title;
  final String voucherType;
  final String discountType;
  final double discountValue;
  final bool isActive;
  final bool isExpired;
  final DateTime startDate;
  final DateTime endDate;
  final String? studentId;
  final String? courseId;
  final String createdBy;

  VoucherModel({
    this.id,
    this.title,
    required this.voucherType,
    required this.discountType,
    required this.discountValue,
    required this.isActive,
    required this.isExpired,
    required this.startDate,
    required this.endDate,
    this.studentId,
    this.courseId,
    required this.createdBy,
  });

// Fixed VoucherModel.fromJson method to handle nested objects

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    // Handle potential nested objects for courseId and studentId
    String? courseId;
    String? studentId;

    // Extract courseId - could be a string or a nested object with _id
    if (json['course_id'] != null) {
      if (json['course_id'] is String) {
        courseId = json['course_id'];
      } else if (json['course_id'] is Map && json['course_id']['_id'] != null) {
        courseId = json['course_id']['_id'];
      }
    }

    // Extract studentId - could be a string or a nested object with _id
    if (json['student_id'] != null) {
      if (json['student_id'] is String) {
        studentId = json['student_id'];
      } else if (json['student_id'] is Map &&
          json['student_id']['_id'] != null) {
        studentId = json['student_id']['_id'];
      }
    }

    // Extract createdBy - could be a string or a nested object with _id
    String createdBy;
    if (json['createdBy'] is String) {
      createdBy = json['createdBy'];
    } else if (json['createdBy'] is Map && json['createdBy']['_id'] != null) {
      createdBy = json['createdBy']['_id'];
    } else {
      createdBy = 'unknown'; // Default value
    }

    return VoucherModel(
      id: json['_id'] ?? json['sId'],
      title: json['title'],
      voucherType: json['voucherType'] ?? 'All_Course',
      // Default to All_Course if not specified
      discountType: json['discountType'],
      discountValue: json['discountValue']?.toDouble() ?? 0.0,
      isActive: json['isActive'] ?? false,
      isExpired: json['isExpired'] ?? false,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      studentId: studentId,
      courseId: courseId,
      createdBy: createdBy,
    );
  }

  // Calculate the discount amount based on price
  double calculateDiscount(double price) {
    if (discountType == 'Amount') {
      return discountValue;
    } else if (discountType == 'Percentage') {
      return (price * discountValue) / 100;
    }
    return 0.0;
  }
}

class VoucherResponse {
  final bool success;
  final String message;
  final VoucherModel? data;

  VoucherResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory VoucherResponse.fromJson(Map<String, dynamic> json) {
    return VoucherResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? VoucherModel.fromJson(json['data']) : null,
    );
  }
}
