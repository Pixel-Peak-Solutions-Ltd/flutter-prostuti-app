import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/view_model/auth_notifier.dart';

part 'dio_service.g.dart';

/*
****** CALL LIKE THiS @ABIJIT ******

final dioService = ref.watch(dioServiceProvider(accessToken: accessToken));

 */

@riverpod
Dio dio(DioRef ref, {required String accessToken}) {
  final accessToken = ref.watch(authNotifierProvider);
  return Dio(BaseOptions(
    baseUrl: 'https://example.com', // Replace with your base URL
    connectTimeout: const Duration(milliseconds: 5000),
    receiveTimeout: const Duration(milliseconds: 3000),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    },
  ));
}

@riverpod
DioService dioService(
  DioServiceRef ref, {
  required String accessToken,
}) {
  final dio = ref.watch(dioProvider(accessToken: accessToken));
  return DioService(dio);
}

class DioService {
  final Dio _dio;

  DioService(this._dio);

  // Generic GET request
  Future<Response> getRequest(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response =
          await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Generic POST request
  Future<Response> postRequest(String endpoint, dynamic data,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await _dio.post(endpoint,
          data: data, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Generic PUT request
  Future<Response> putRequest(String endpoint, dynamic data,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await _dio.put(endpoint,
          data: data, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Generic DELETE request
  Future<Response> deleteRequest(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response =
          await _dio.delete(endpoint, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Error handler
  Response _handleError(DioException error) {
    if (error.response != null) {
      return error.response!;
    } else {
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusMessage: 'Error: ${error.message}',
        statusCode:
            error.type == DioExceptionType.connectionTimeout ? 408 : 500,
      );
    }
  }
}
