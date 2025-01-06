import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prostuti/features/auth/login/view/login_view.dart';
import 'package:prostuti/secrets/secrets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/view_model/auth_notifier.dart';
import 'nav.dart';

part 'dio_service.g.dart';

@riverpod
Dio dio(DioRef ref) {
  // Obtain authNotifier outside the async closure
  final authNotifier = ref.read(authNotifierProvider.notifier);

  return Dio(BaseOptions(
    baseUrl: BASE_URL,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 60),
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get the accessToken and accessExpiryTime from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString('accessToken');
        final accessExpiryTime = prefs.getInt('accessExpiryTime');

        if (accessToken != null && accessExpiryTime != null) {
          final now = DateTime.now().millisecondsSinceEpoch;
          if (accessExpiryTime > now) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          } else {
            // Token has expired, attempt to refresh
            final newAccessToken = await authNotifier.createAccessToken();
            if (newAccessToken != null) {
              options.headers['Authorization'] = 'Bearer $newAccessToken';
            } else {
              // Handle refresh failure, e.g., logout the user
              await authNotifier.clearAccessToken();
            }
          }
        }
        handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          // Refresh the access token using the notifier obtained earlier
          final newAccessToken = await authNotifier.createAccessToken();

          print(newAccessToken);

          if (newAccessToken == null || newAccessToken.isEmpty) {
            // Handle refresh failure, e.g., logout the user
            Fluttertoast.showToast(msg: "Authentication failed");
            Nav().pushAndRemoveUntil(const LoginView());
            return handler.reject(error);
          }

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
