import 'error_response.dart';

class ApiResponse<T> {
  final T? data;
  final ErrorResponse? error;

  ApiResponse.success(this.data) : error = null;

  ApiResponse.error(this.error) : data = null;
}
