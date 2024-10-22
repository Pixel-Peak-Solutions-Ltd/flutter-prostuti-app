import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/features/forget_password/repository/forget_password_repo.dart';
import 'package:prostuti/features/login/view/login_view.dart';
import 'package:prostuti/features/signup/viewmodel/otp_viewmodel.dart';
import 'package:prostuti/features/signup/viewmodel/phone_number_viewmodel.dart';

import '../../../common/widgets/long_button.dart';

class NewPasswordView extends ConsumerStatefulWidget {
  const NewPasswordView({super.key});

  @override
  NewPasswordViewState createState() => NewPasswordViewState();
}

class NewPasswordViewState extends ConsumerState<NewPasswordView> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
                    'পাসওয়ার্ড',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(6),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        hintText: "আপনার পাসওয়ার্ড লিখুন"),
                  ),
                  Text(
                    'কনফার্ম পাসওয়ার্ড',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(6),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                        hintText: "আপনার পাসওয়ার্ড কনফার্ম করুন"),
                  ),
                ],
              ),
              const Gap(32),
              LongButton(
                text: 'এগিয়ে যাই',
                onPressed: () async {
                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Your Password Doesn't match")),
                    );
                    return;
                  }

                  final payload = {
                    "otpCode": ref.read(otpProvider),
                    "phone": ref.read(phoneNumberProvider),
                    "newPassword": _passwordController.text,
                    "confirmNewPassword": _confirmPasswordController.text,
                  };

                  try {
                    final response = await ref
                        .read(forgetPasswordRepoProvider)
                        .resetPassword(payload: payload);

                    if (response && context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const LoginView()),
                      );
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Changing Password failed')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('An error occurred')),
                      );
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
