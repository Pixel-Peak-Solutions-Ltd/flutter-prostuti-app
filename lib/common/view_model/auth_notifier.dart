import 'package:dio/dio.dart';
import 'package:prostuti/features/auth/login/model/login_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../secrets/secrets.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<String?> build() async {
    // Load the token from SharedPreferences asynchronously on initialization
    return await _loadAccessToken();
  }

  // Method to set the access token
  Future<void> setAccessToken(
      String accessToken,
      int accessTokenExpiresIn,
      String? refreshToken,
      int? refreshTokenExpiresIn,
      bool? rememberMe) async {
    state = AsyncValue.data(accessToken);
    await _saveAccessToken(accessToken, accessTokenExpiresIn, refreshToken,
        refreshTokenExpiresIn, rememberMe);
  }

  // Method to clear the access token (e.g., on logout)
  Future<void> clearAccessToken() async {
    state = const AsyncValue.data(null);
    await _removeAccessToken();
  }

  // Refresh token logic
  Future<String?> createAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');
    final refreshExpiryTime = prefs.getInt('refreshExpiryTime');
    final rememberMe = prefs.getBool('rememberMe');

    if (refreshToken != null && refreshExpiryTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (refreshExpiryTime > now) {
        try {
          final response = await Dio().post(
            '$BASE_URL/auth/student/refresh-token',
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessTokenResponse = Login.fromJson(response.data);
            final accessToken = newAccessTokenResponse.data!.accessToken!;
            final accessTokenExpiresIn =
                newAccessTokenResponse.data!.accessTokenExpiresIn!;
            final newRefreshToken = newAccessTokenResponse.data!.refreshToken;
            final refreshTokenExpiresIn =
                newAccessTokenResponse.data!.refreshTokenExpiresIn;

            final accessExpiryTime = DateTime.now()
                .add(Duration(seconds: accessTokenExpiresIn))
                .millisecondsSinceEpoch;
            final refreshExpiryTime =
                newRefreshToken != null && refreshTokenExpiresIn != null
                    ? DateTime.now()
                        .add(Duration(seconds: refreshTokenExpiresIn))
                        .millisecondsSinceEpoch
                    : null;

            await setAccessToken(accessToken, accessExpiryTime, newRefreshToken,
                refreshExpiryTime, rememberMe);

            return accessToken;
          }
        } catch (e) {
          await clearAccessToken(); // If refresh fails, logout the user
        }
      } else {
        // Refresh token has expired, logout the user
        await clearAccessToken();
      }
    }
    return null;
  }

  // Load the access token from SharedPreferences
  Future<String?> _loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Save the access token to SharedPreferences
  Future<void> _saveAccessToken(String accessToken, int accessExpiryTime,
      String? refreshToken, int? refreshExpiryTime, bool? rememberMe) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('accessToken', accessToken);
    await prefs.setInt('accessExpiryTime', accessExpiryTime); // Store as int

    if (refreshToken != null && refreshExpiryTime != null) {
      await prefs.setString('refreshToken', refreshToken);
      await prefs.setInt('refreshExpiryTime', refreshExpiryTime);
    }
  }

  // Remove the access token from SharedPreferences
  Future<void> _removeAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
