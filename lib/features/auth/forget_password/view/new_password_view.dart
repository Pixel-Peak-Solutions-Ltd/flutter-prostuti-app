import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/core/services/debouncer.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/features/auth/forget_password/repository/forget_password_repo.dart';
import 'package:prostuti/features/auth/login/view/login_view.dart';
import 'package:prostuti/features/auth/signup/viewmodel/otp_viewmodel.dart';
import 'package:prostuti/features/auth/signup/viewmodel/phone_number_viewmodel.dart';

import 'package:skeletonizer/skeletonizer.dart';

class NewPasswordView extends ConsumerStatefulWidget {
  const NewPasswordView({super.key});

  @override
  NewPasswordViewState createState() => NewPasswordViewState();
}

class NewPasswordViewState extends ConsumerState<NewPasswordView> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 120);
  final _loadingProvider = StateProvider<bool>((ref) => false);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'পাসওয়ার্ড প্রয়োজন';
    }
    // Password must contain at least one uppercase, one special character, and be at least 8 characters long
    final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[!@#\$&*~]).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return 'পাসওয়ার্ডে ৮ অক্ষর, বড় হাতের অক্ষর ও বিশেষ চিহ্ন দরকার।';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(_loadingProvider);
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
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'পাসওয়ার্ড',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Gap(6),
                    TextFormField(
                      validator: _validatePassword,
                      keyboardType: TextInputType.text,
                      obscureText: true,
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
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                          hintText: "আপনার পাসওয়ার্ড কনফার্ম করুন"),
                    ),
                  ],
                ),
              ),
              const Gap(32),
              Skeletonizer(
                enabled: isLoading,
                child: LongButton(
                  text: 'এগিয়ে যাই',
                  onPressed: () {
                    _debouncer.run(
                        action: () async {
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
                            "confirmNewPassword":
                                _confirmPasswordController.text,
                          };
                          if (_formKey.currentState!.validate()) {
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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      Text(ErrorHandler().getErrorMessage()),
                                ));
                                _debouncer.cancel();
                                ErrorHandler().clearErrorMessage();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('An error occurred')),
                                );
                              }
                            }
                          }
                        },
                        loadingController: ref.read(_loadingProvider.notifier));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
