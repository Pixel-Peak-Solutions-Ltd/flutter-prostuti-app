import 'package:dio/dio.dart';
import 'package:prostuti/features/auth/login/model/login_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../flutter_config.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final baseUrl = FlavorConfig.instance.baseUrl;
  @override
  Future<String?> build() async {
    return await _loadAccessToken();
  }

  Future<void> setTokens({
    required String accessToken,
    required int accessExpiryTime,
    String? refreshToken,
    int? refreshExpiryTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setInt('accessExpiryTime', accessExpiryTime);
    if (refreshToken != null && refreshExpiryTime != null) {
      await prefs.setString('refreshToken', refreshToken);
      await prefs.setInt('refreshExpiryTime', refreshExpiryTime);
    }
    state = AsyncValue.data(accessToken);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = const AsyncValue.data(null);
  }

  Future<String?> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');
    final refreshExpiryTime = prefs.getInt('refreshExpiryTime');

    if (refreshToken != null && refreshExpiryTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (refreshExpiryTime > now) {
        try {
          final response = await Dio().post(
            '$baseUrl/auth/student/refresh-token',
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200) {
            final loginResponse = Login.fromJson(response.data);
            final accessToken = loginResponse.data!.accessToken!;
            final accessExpiryTime = DateTime.now()
                .add(Duration(
                    seconds: loginResponse.data!.accessTokenExpiresIn!))
                .millisecondsSinceEpoch;

            await setTokens(
              accessToken: accessToken,
              accessExpiryTime: accessExpiryTime,
              refreshToken: loginResponse.data!.refreshToken,
              refreshExpiryTime: loginResponse.data!.refreshTokenExpiresIn !=
                      null
                  ? DateTime.now()
                      .add(Duration(
                          seconds: loginResponse.data!.refreshTokenExpiresIn!))
                      .millisecondsSinceEpoch
                  : null,
            );

            return accessToken;
          }
        } catch (e) {
          await clearTokens();
        }
      } else {
        await clearTokens();
      }
    }
    return null;
  }

  Future<String?> _loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
