// __brick__/repository/login_repo.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/error_handler.dart';
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

  Future<Login> loginUser(
      {required Map<String, String> payload, required WidgetRef ref}) async {
    final response = await _dioService.postRequest("/auth/login", payload);

    print(response.statusMessage);
    if (response.statusCode == 200) {
      final loginResponse = Login.fromJson(response.data);
      print("${response.data["data"]}, ${Login.fromJson(response.data).data}");
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

      await ref.read(authNotifierProvider.notifier).setAccessToken(
          accessToken, accessExpiryTime, refreshToken, refreshExpiryTime);

      return loginResponse;
    } else {
      ErrorHandler().setErrorMessage(response.statusMessage);
      if (kDebugMode) {
        print("error login");
      }
      return Login.fromJson(response.data);
    }
  }
}
