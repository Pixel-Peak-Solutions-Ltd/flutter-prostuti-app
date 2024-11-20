import 'package:dio/dio.dart';
import 'package:prostuti/features/auth/login/model/login_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // final refreshExpiryTime = prefs.getInt('refreshExpiryTime');
    final rememberMe = prefs.getBool('rememberMe');

    if (refreshToken != null) {
      try {
        final response = await Dio().post(
          'https://prostuti-app-backend-production.up.railway.app/api/v1/auth/student/refresh-token',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200) {
          final newAccessTokenResponse =
              Login.fromJson(response.data['accessToken']);
          final accessToken = newAccessTokenResponse.data!.accessToken!;
          final accessTokenExpiresIn =
              newAccessTokenResponse.data!.accessTokenExpiresIn!;
          final refreshToken = newAccessTokenResponse.data!.refreshToken ?? "";
          final refreshTokenExpiresIn =
              newAccessTokenResponse.data!.refreshTokenExpiresIn ?? 0;
          final refreshExpiryTime = DateTime.now()
              .add(Duration(seconds: refreshTokenExpiresIn))
              .millisecondsSinceEpoch;

          final accessExpiryTime = DateTime.now()
              .add(Duration(seconds: accessTokenExpiresIn))
              .millisecondsSinceEpoch;

          await ref.read(authNotifierProvider.notifier).setAccessToken(
              accessToken,
              accessExpiryTime,
              refreshToken,
              refreshExpiryTime,
              rememberMe);

          return accessToken;
        }
      } catch (e) {
        await clearAccessToken(); // If refresh fails, logout the user
      }
    }
    return null;
  }

  // Auto-login logic (called on app start)
  /*Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final rememberMe = prefs.getBool('rememberMe');
    final refreshToken = prefs.getString('refreshToken');
    final refreshExpiryTime = DateTime.parse(prefs.getInt('refreshExpiryTime').toString());
    final accessExpiryTime = DateTime.parse(prefs.getInt('accessExpiryTime').toString());

    if (refreshExpiryTime.isBefore(DateTime.now())) {
      // logout
      // await setAccessToken(token);
    } else {
      if(accessExpiryTime.isBefore(DateTime.now())){
        // newAccessToken
      }else{
        // homepage
      }
      await clearAccessToken();
    }
  }*/

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
    await prefs.setString('accessExpiryTime', accessExpiryTime.toString());

    if (refreshToken != null && refreshExpiryTime! > 0) {
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
