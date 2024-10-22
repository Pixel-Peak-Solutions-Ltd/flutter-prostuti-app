// __brick__/repository/login_repo.dart
import 'package:flutter/foundation.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  Future<Login> loginUser({required Map<String, String> payload}) async {
    final response = await _dioService.postRequest("/auth/login", payload);

    if (response.statusCode == 200) {
      return Login.fromJson(response.data["data"]);
    } else {
      if (kDebugMode) {
        print("error login");
      }
      return Login.fromJson(response.data);
    }
  }
}
