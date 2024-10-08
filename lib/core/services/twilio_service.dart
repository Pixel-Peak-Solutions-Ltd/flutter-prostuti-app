import 'package:twilio_flutter/twilio_flutter.dart';

class TwilioService {
  late TwilioFlutter twilioFlutter;

  TwilioService() {
    twilioFlutter = TwilioFlutter(
      accountSid: 'YOUR_ACCOUNT_SID',
      authToken: 'YOUR_AUTH_TOKEN',
      twilioNumber: 'YOUR_TWILIO_PHONE_NUMBER',
    );
  }

  Future<TwilioResponse> sendVerificationCode(
      String phoneNumber, String code) async {
    final response = await twilioFlutter.sendSMS(
      toNumber: phoneNumber,
      messageBody: 'Your verification code is $code',
    );

    return response;
  }
}
