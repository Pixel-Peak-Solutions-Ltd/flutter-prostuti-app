// __brick__/repository/login_repo.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';
import 'package:prostuti/core/services/api_response.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:prostuti/features/auth/login/model/login_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_repo.g.dart';

@riverpod
LoginRepo loginRepo(LoginRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return LoginRepo(dioService);
}

class LoginRepo {
  final DioService _dioService;

  LoginRepo(this._dioService);

  Future<ApiResponse> loginUser({
    required Map<String, String> payload,
    required WidgetRef ref,
    required bool rememberMe,
  }) async {
    final dioService = ref.read(dioServiceProvider);
    final response = await dioService.postRequest("/auth/login", payload);

    if (response.statusCode == 200) {
      final loginResponse = Login.fromJson(response.data);
      final accessToken = loginResponse.data!.accessToken!;
      final accessTokenExpiresIn = loginResponse.data!.accessTokenExpiresIn!;
      final refreshToken = loginResponse.data!.refreshToken;
      final refreshTokenExpiresIn = loginResponse.data!.refreshTokenExpiresIn;

      // Calculate expiry times
      final accessExpiryTime = DateTime.now()
          .add(Duration(seconds: accessTokenExpiresIn))
          .millisecondsSinceEpoch;
      final refreshExpiryTime =
          refreshToken != null && refreshTokenExpiresIn != null
              ? DateTime.now()
                  .add(Duration(seconds: refreshTokenExpiresIn))
                  .millisecondsSinceEpoch
              : null;

      // Store tokens using AuthNotifier
      await ref.read(authNotifierProvider.notifier).setTokens(
            accessToken: accessToken,
            accessExpiryTime: accessExpiryTime,
            refreshToken: refreshToken,
            refreshExpiryTime: refreshExpiryTime,
          );

      return ApiResponse.success(loginResponse);
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return ApiResponse.error(errorResponse);
    }
  }
}
