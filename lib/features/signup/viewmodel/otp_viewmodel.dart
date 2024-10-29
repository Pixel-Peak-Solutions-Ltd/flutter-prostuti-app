import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'otp_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class Otp extends _$Otp {
  @override
  String build() {
    return '';
  }

  void setOtp(String otp) {
    state = otp;
  }
}
