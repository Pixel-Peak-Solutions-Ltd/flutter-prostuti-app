import 'package:shared_preferences/shared_preferences.dart';

class PersistUtil {
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
