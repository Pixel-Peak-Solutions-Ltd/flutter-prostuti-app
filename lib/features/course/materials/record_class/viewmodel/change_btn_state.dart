import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_btn_state.g.dart';

@riverpod
class ChangeBtnState extends _$ChangeBtnState {
  @override
  bool build() {
    return false;
  }

  void setBtnState() {
    state = true;
  }
}
