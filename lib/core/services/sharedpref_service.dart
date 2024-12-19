import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Fetch the access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Save the access token
  Future<void> saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
  }

  // Remove the access token (e.g., for logout)
  Future<void> removeAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }
}
