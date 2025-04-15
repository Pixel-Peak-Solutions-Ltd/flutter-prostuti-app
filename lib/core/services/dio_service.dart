import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:prostuti/features/auth/login/view/login_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/view_model/auth_notifier.dart';
import '../../flutter_config.dart';
import 'nav.dart';
import 'no_internet_view.dart';

part 'dio_service.g.dart';

// Connectivity provider
@riverpod
Connectivity connectivity(ConnectivityRef ref) {
  return Connectivity();
}

// Provider for NetworkInfo implementation
@riverpod
NetworkInfo networkInfo(NetworkInfoRef ref) {
  final connectivity = ref.watch(connectivityProvider);
  return NetworkInfoImpl(connectivity);
}

// Network info interface
abstract class NetworkInfo {
  Future<bool> get isConnected;

  Stream<ConnectivityResult> get onConnectivityChanged;
}

// Network info implementation
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}

@riverpod
Dio dio(DioRef ref) {
  final authNotifier = ref.read(authNotifierProvider.notifier);
  final networkInfo = ref.watch(networkInfoProvider);

  // Use the base URL from FlavorConfig instead of hard-coded BASE_URL
  final baseUrl = FlavorConfig.instance.baseUrl;

  return Dio(BaseOptions(
    baseUrl: baseUrl, // Use flavor-specific URL
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 60),
  ))
    ..interceptors.add(
      PrettyDioLogger(
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Check connectivity before proceeding with the request
          final isConnected = await networkInfo.isConnected;
          if (!isConnected) {
            // Navigate to the No Internet screen
            // Using pushAndRemoveUntil allows users to go back if they want to
            // Also makes sure we don't stack multiple NoInternetView instances
            Nav().push(const NoInternetView());

            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No internet connection',
                type: DioExceptionType.connectionError,
              ),
            );
          }

          final prefs = await SharedPreferences.getInstance();
          final accessToken = prefs.getString('accessToken');
          final accessExpiryTime = prefs.getInt('accessExpiryTime');

          if (accessToken != null && accessExpiryTime != null) {
            final now = DateTime.now().millisecondsSinceEpoch;
            if (accessExpiryTime > now) {
              options.headers['Authorization'] = 'Bearer $accessToken';
            } else {
              // Token has expired, attempt to refresh
              final newAccessToken = await authNotifier.refreshToken();
              debugPrint("from onRequest: $newAccessToken");
              if (newAccessToken != null) {
                options.headers['Authorization'] = 'Bearer $newAccessToken';
              } else {
                // If refresh fails, clear tokens and redirect to login
                await authNotifier.clearTokens();
                Nav().pushAndRemoveUntil(const LoginView());
                return handler.reject(DioException(
                  requestOptions: options,
                  error: 'Token refresh failed',
                ));
              }
            }
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.type == DioExceptionType.connectionError ||
              error.error.toString().contains('No internet connection')) {
            // Navigate to the No Internet screen
            Nav().pushAndRemoveUntil(const NoInternetView());

            // Handle no connectivity error
            return handler.reject(DioException(
              requestOptions: error.requestOptions,
              error: 'No internet connection',
              type: DioExceptionType.connectionError,
            ));
          }

          if (error.response?.statusCode == 401) {
            // Attempt to refresh the token
            final newAccessToken = await authNotifier.refreshToken();
            debugPrint("from onError: $newAccessToken");
            if (newAccessToken != null) {
              // Retry the original request with the new token
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              final response = await Dio().fetch(error.requestOptions);
              return handler.resolve(response);
            } else {
              // If refresh fails, clear tokens and redirect to login
              await authNotifier.clearTokens();
              Nav().pushAndRemoveUntil(const LoginView());
              return handler.reject(error);
            }
          }
          handler.next(error);
        },
      ),
    );
}

@riverpod
DioService dioService(DioServiceRef ref) {
  final dio = ref.watch(dioProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return DioService(dio, networkInfo);
}

class DioService {
  final Dio _dio;
  final NetworkInfo _networkInfo;

  DioService(this._dio, this._networkInfo);

  // Add a getter to access the current baseUrl
  String get baseUrl => _dio.options.baseUrl;

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

  Future<Response> patchRequest(String endpoint,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
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

  Future<Response> postMultipartRequest(String path, FormData formData) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Response _handleError(DioException error) {
    String message = error.message ?? 'Something went wrong';
    int statusCode = error.response?.statusCode ?? 500;

    if (error.type == DioExceptionType.connectionError ||
        error.error.toString().contains('No internet connection')) {
      message = 'No internet connection';
      statusCode = 503; // Service Unavailable
    } else if (error.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout';
      statusCode = 408; // Request Timeout
    }

    return Response(
      requestOptions: error.requestOptions,
      statusMessage: message,
      statusCode: statusCode,
      data: error.response?.data ??
          {
            'success': false,
            'message': message,
          },
    );
  }

  // Utility method to check connectivity status
  Future<bool> get isConnected => _networkInfo.isConnected;

  // Stream to listen for connectivity changes
  Stream<ConnectivityResult> get connectivityStream =>
      _networkInfo.onConnectivityChanged;
}
