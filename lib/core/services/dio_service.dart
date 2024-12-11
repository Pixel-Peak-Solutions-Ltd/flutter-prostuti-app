import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/auth/login/view/login_view.dart';
import 'package:prostuti/secrets/secrets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/view_model/auth_notifier.dart';

part 'dio_service.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final authNotifier = ref.watch(authNotifierProvider);

  return Dio(BaseOptions(
    baseUrl: BASE_URL,
    connectTimeout: const Duration(milliseconds: 5000),
    receiveTimeout: const Duration(milliseconds: 3000),
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get the accessToken from the AuthNotifier's state
        if (authNotifier is AsyncData && authNotifier.value != null) {
          final accessToken = authNotifier.value;
          if (accessToken != "") {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
        }
        handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          // Refresh the access token
          final authNotifier = ref.read(authNotifierProvider.notifier);
          final newAccessToken = await authNotifier.createAccessToken();
          debugPrint("newAccessToken $newAccessToken");

          if (newAccessToken != null) {
            // Update the original request's headers with the new token
            error.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';

            try {
              // Retry the original request with the updated headers
              final response = await Dio().fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.reject(e as DioException);
            }
          } else {
            Nav().pushAndRemoveUntil(const LoginView());
          }
        }
        // Forward other errors
        handler.next(error);
      },
    ));
}

@riverpod
DioService dioService(DioServiceRef ref) {
  final dio = ref.watch(dioProvider);
  return DioService(dio);
}

class DioService {
  final Dio _dio;

  DioService(this._dio);

  Future<Response> getRequest(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameters);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> postRequest(String endpoint, dynamic data,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.post(endpoint,
          data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> putRequest(String endpoint, dynamic data,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.put(endpoint,
          data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> deleteRequest(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(endpoint, queryParameters: queryParameters);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Response _handleError(DioException error) {
    return Response(
      requestOptions: error.requestOptions,
      statusMessage: error.message,
      statusCode: error.response?.statusCode ??
          (error.type == DioExceptionType.connectionTimeout ? 408 : 500),
      data: error.response
          ?.data, // This will include the JSON body from the error response
    );
  }
}
