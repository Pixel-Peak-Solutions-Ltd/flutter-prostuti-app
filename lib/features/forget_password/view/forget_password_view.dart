import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/features/forget_password/repository/forget_password_repo.dart';

import '../../../common/widgets/long_button.dart';
import '../../signup/view/otp_view.dart';
import '../../signup/viewmodel/phone_number_viewmodel.dart';

class ForgetPasswordView extends ConsumerStatefulWidget {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  ForgetPasswordViewState createState() => ForgetPasswordViewState();
}

class ForgetPasswordViewState extends ConsumerState<ForgetPasswordView> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/prostuti_logo.png",
                width: 154,
                height: 101,
              ),
              const Gap(118),
              Text(
                'পাসওয়ার্ড ভুলে গেছেন',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'ফোন নম্বর',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(6),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        hintText: "আপনার ফোন নম্বর লিখুন"),
                  ),
                ],
              ),
              const Gap(32),
              LongButton(
                text: 'এগিয়ে যাই',
                onPressed: () async {
                  final response = await ref
                      .read(forgetPasswordRepoProvider)
                      .sendVerificationCodeForPasswordReset(
                          phoneNo: _phoneController.text.toString());

                  ref
                      .watch(phoneNumberProvider.notifier)
                      .setPhoneNumber(_phoneController.text);

                  if (response && context.mounted) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OtpView(
                        fromPage: "resetPassword",
                      ),
                    ));
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please Register your Account first'),
                      ));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
