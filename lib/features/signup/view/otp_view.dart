import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:prostuti/features/signup/view/register_view.dart';
import 'package:prostuti/features/signup/viewmodel/otp_viewmodel.dart';

import '../../../common/widgets/long_button.dart';
import '../../../core/configs/app_colors.dart';

class OtpView extends ConsumerStatefulWidget {
  const OtpView({Key? key}) : super(key: key);

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
                  validator: (s) {
                    return s == '2222' ? null : 'Pin is incorrect';
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (pin) =>
                      ref.watch(otpProvider.notifier).setOtp(pin),
                ),
                const Gap(32),
                TextButton(
                  onPressed: () {},
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
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegisterView(),
                    ));
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
