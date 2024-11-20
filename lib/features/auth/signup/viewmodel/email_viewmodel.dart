import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class EmailViewmodel extends _$EmailViewmodel {
  @override
  String build() {
    return "";
  }

  void setEmail(String email) {
    state = email;
  }
}
