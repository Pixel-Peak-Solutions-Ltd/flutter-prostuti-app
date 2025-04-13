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

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['_id'] ?? json['sId'],
      title: json['title'],
      voucherType: json['voucherType'],
      discountType: json['discountType'],
      discountValue: json['discountValue']?.toDouble() ?? 0.0,
      isActive: json['isActive'] ?? false,
      isExpired: json['isExpired'] ?? false,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      studentId: json['student_id'],
      courseId: json['course_id'],
      createdBy: json['createdBy'],
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
