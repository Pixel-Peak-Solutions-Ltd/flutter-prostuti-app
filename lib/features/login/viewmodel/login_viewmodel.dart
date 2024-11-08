import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_viewmodel.g.dart';

@riverpod
class RememberMe extends _$RememberMe {
  @override
  bool build() {
    return false;
  }

  void toggleCheckBox(bool? onChanged) {
    state = onChanged!;
  }
}
