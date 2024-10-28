import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'password_viewmodel.g.dart';

@riverpod
class PasswordViewmodel extends _$PasswordViewmodel {
  @override
  String build() {
    return "";
  }

  void setPassword(String password) {
    state = password;
  }
}
