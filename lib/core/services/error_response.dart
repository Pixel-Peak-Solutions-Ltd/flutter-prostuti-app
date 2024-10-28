class ErrorResponse {
  final bool success;
  final String message;

  ErrorResponse({required this.success, required this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'An error occurred',
    );
  }
}
