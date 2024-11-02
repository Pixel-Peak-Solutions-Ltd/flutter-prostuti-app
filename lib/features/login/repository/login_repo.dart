// __brick__/repository/login_repo.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/api_response.dart';
import '../../../core/services/error_handler.dart';
import '../../../core/services/error_response.dart';
import '../model/login_model.dart';

part 'login_repo.g.dart';

@riverpod
LoginRepo loginRepo(LoginRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return LoginRepo(dioService);
}

class LoginRepo {
  final DioService _dioService;

  LoginRepo(this._dioService);

  Future<ApiResponse> loginUser(
      {required Map<String, String> payload,
      required WidgetRef ref,
      required bool rememberMe}) async {
    final response = await _dioService.postRequest("/auth/login", payload);

    print("login response : $response");
    if (response.statusCode == 200) {
      final loginResponse = Login.fromJson(response.data);
      final accessToken = loginResponse.data!.accessToken!;
      final accessTokenExpiresIn = loginResponse.data!.accessTokenExpiresIn!;
      final refreshToken = loginResponse.data!.refreshToken!;
      final refreshTokenExpiresIn = loginResponse.data!.refreshTokenExpiresIn!;

      final accessExpiryTime = DateTime.now()
          .add(Duration(seconds: accessTokenExpiresIn))
          .millisecondsSinceEpoch;
      final refreshExpiryTime = DateTime.now()
          .add(Duration(seconds: refreshTokenExpiresIn))
          .millisecondsSinceEpoch;

      // print("$accessToken $accessExpiryTime, $refreshToken, $refreshExpiryTime,$rememberMe}");
      await ref.read(authNotifierProvider.notifier).setAccessToken(accessToken,
          accessExpiryTime, refreshToken, refreshExpiryTime, rememberMe);

      return ApiResponse.success(loginResponse);
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return ApiResponse.error(errorResponse);
    }
  }
}
