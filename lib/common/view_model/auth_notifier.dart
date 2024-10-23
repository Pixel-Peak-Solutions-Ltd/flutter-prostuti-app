import 'package:dio/dio.dart';
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
  Future<void> setAccessToken(String token) async {
    state = AsyncValue.data(token);
    await _saveAccessToken(token);
  }

  // Method to clear the access token (e.g., on logout)
  Future<void> clearAccessToken() async {
    state = const AsyncValue.data(null);
    await _removeAccessToken();
  }

  // Refresh token logic
  Future<String?> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();re
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      try {
        final response = await Dio().post(
          'https://prostuti-app-backend-production.up.railway.app/api/v1/auth/student/refresh-token',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200) {
          final newAccessToken = response.data['accessToken'];
          await setAccessToken(newAccessToken);
          return newAccessToken;
        }
      } catch (e) {
        await clearAccessToken(); // If refresh fails, logout the user
      }
    }
    return null;
  }

  // Auto-login logic (called on app start)
  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    if (rememberMe && token != null) {
      await setAccessToken(token);
    } else {
      await clearAccessToken();
    }
  }

  // Load the access token from SharedPreferences
  Future<String?> _loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Save the access token to SharedPreferences
  Future<void> _saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  // Remove the access token from SharedPreferences
  Future<void> _removeAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }
}
