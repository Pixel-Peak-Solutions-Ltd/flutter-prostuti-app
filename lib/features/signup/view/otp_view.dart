import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:prostuti/features/forget_password/view/new_password_view.dart';
import 'package:prostuti/features/signup/view/register_view.dart';
import 'package:prostuti/features/signup/viewmodel/otp_viewmodel.dart';
import 'package:prostuti/features/signup/viewmodel/phone_number_viewmodel.dart';

import '../../../common/widgets/long_button.dart';
import '../../../core/configs/app_colors.dart';
import '../repository/signup_repo.dart';

class OtpView extends ConsumerStatefulWidget {
  final String fromPage;

  const OtpView({super.key, required this.fromPage});

  @override
  OtpViewState createState() => OtpViewState();
}

class OtpViewState extends ConsumerState<OtpView> {
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/prostuti_logo.png",
                  width: 154,
                  height: 101,
                ),
                const Gap(76),
                Text(
                  'অটিপি যাচাই করুন',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Gap(8),
                Text(
                  'আপনার নাম্বরে পাঠানো ৪ সংখ্যার কোডটি লিখুন',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                const Gap(32),
                Pinput(
                  controller: _otpController,
                  showCursor: true,
                  onCompleted: (pin) =>
                      ref.watch(otpProvider.notifier).setOtp(pin),
                ),
                const Gap(32),
                TextButton(
                  onPressed: () async {
                    await ref.watch(signupRepoProvider).sendVerificationCode(
                        phoneNo: ref.read(phoneNumberProvider));
                  },
                  child: Text(
                    'আবার কোড পাঠান',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.textActionTertiaryLight,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                const Gap(32),
                LongButton(
                  text: 'এগিয়ে যাই',
                  onPressed: () async {
                    final response = await ref
                        .read(signupRepoProvider)
                        .verifyPhoneNumber(
                            phoneNo: "+88${ref.read(phoneNumberProvider)}",
                            code: _otpController.text.toString(),
                            type: widget.fromPage == "Signup"
                                ? "ACCOUNT_CREATION"
                                : "PASSWORD_RESET");

                    if (response.data!.verified != null && context.mounted) {
                      widget.fromPage == "Signup"
                          ? Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterView(),
                            ))
                          : Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const NewPasswordView(),
                            ));
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Wrong OTP'),
                        ));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
