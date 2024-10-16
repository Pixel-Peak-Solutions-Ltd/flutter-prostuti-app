import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  String? build() {
    return null; // Initially, the token is null
  }

  // Method to set the access token
  void setAccessToken(String token) {
    state = token;
  }

  // Method to clear the access token (e.g., on logout)
  void clearAccessToken() {
    state = null;
  }
}
