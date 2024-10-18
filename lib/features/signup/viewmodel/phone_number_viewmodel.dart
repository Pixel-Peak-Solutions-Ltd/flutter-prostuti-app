import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'phone_number_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class PhoneNumber extends _$PhoneNumber {
  @override
  String build() {
    return '';
  }

  void setPhoneNumber(String phoneNumber) {
    state = phoneNumber;
  }
}
