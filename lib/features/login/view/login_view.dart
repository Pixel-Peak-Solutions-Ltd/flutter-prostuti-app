import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/features/forget_password/view/forget_password_view.dart';
import 'package:prostuti/features/login/repository/login_repo.dart';
import 'package:prostuti/features/login/viewmodel/login_viewmodel.dart';
import 'package:prostuti/features/signup/widgets/label.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/services/debouncer.dart';
import '../../../core/services/error_handler.dart';
import '../../signup/view/phone_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends ConsumerState<LoginView> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 120);
  final _loadingProvider = StateProvider<bool>((ref) => false);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'পাসওয়ার্ড প্রয়োজন';
    }
    // Password must contain at least one uppercase, one special character, and be at least 8 characters long
    final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[!@#\$&*~]).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return 'পাসওয়ার্ডে কমপক্ষে একটি বড় হাতের অক্ষর, একটি বিশেষ চিহ্ন এবং ৮ অক্ষর থাকতে হবে';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool rememberMe = ref.watch(rememberMeProvider);
    final isLoading = ref.watch(_loadingProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(80),
              Image.asset(
                "assets/images/prostuti_logo.png",
                width: 154,
                height: 101,
              ),
              const Gap(60),
              Text(
                'আপনার অ্যাকাউন্টে লগ ইন করুন',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(8),
              Text(
                'ফিরে আসার জন্য স্বাগতম! আপনার বিস্তারিত লিখুন.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Gap(32),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Label(
                      text: 'ফোন নম্বর',
                    ),
                    const Gap(6),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ফোন নম্বর প্রয়োজন';
                        }
                        if (value.length != 11) {
                          return 'ফোন নম্বর অবশ্যই ১১ সংখ্যার হতে হবে';
                        }
                        return null; // Returns null if validation is successful
                      },
                      keyboardType: TextInputType.number,
                      controller: _phoneController,
                      decoration: const InputDecoration(
                          hintText: "আপনার ফোন নম্বর লিখুন"),
                    ),
                    const Gap(20),
                    const Label(
                      text: 'পাসওয়ার্ড',
                    ),
                    const Gap(6),
                    TextFormField(
                      validator: _validatePassword,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          hintText: "আপনার পাসওয়ার্ড লিখুন"),
                    ),
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  ref
                                      .watch(rememberMeProvider.notifier)
                                      .toggleCheckBox(value);
                                },
                              ),
                            ),
                            const Gap(8),
                            Text(
                              '30 দিনের জন্য মনে রাখবেন',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgetPasswordView(),
                            ));
                          },
                          child: Text(
                            'পাসওয়ার্ড ভুলে গেছেন',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.textActionTertiaryLight,
                                      fontWeight: FontWeight.w900,
                                    ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(24),
              Skeletonizer(
                enabled: isLoading,
                child: LongButton(
                    text: 'লগ ইন',
                    onPressed: () {
                      if (_phoneController.text.isEmpty &&
                          _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Phone number and password must not be empty"),
                        ));
                        return;
                      }

                      if (_formKey.currentState!.validate()) {
                        _debouncer.run(
                            action: () async {
                              final payload = rememberMe
                                  ? {
                                      "phone": "+88${_phoneController.text}",
                                      "password": _passwordController.text,
                                      "rememberMe": "30d"
                                    }
                                  : {
                                      "phone": "+88${_phoneController.text}",
                                      "password": _passwordController.text,
                                    };

                              final response = await ref
                                  .read(loginRepoProvider)
                                  .loginUser(payload: payload, rememberMe: rememberMe,ref: ref);

                              if (response.success!) {
                                // navigate
                              } else {
                                if(context.mounted) {
                                  ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      Text(ErrorHandler().getErrorMessage()),
                                ));
                                }
                                _debouncer.cancel();
                                ErrorHandler().clearErrorMessage();
                              }
                            },
                            loadingController:
                                ref.read(_loadingProvider.notifier));
                      }
                    }),
              ),
              const Gap(24),
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PhoneView(),
                )),
                child: RichText(
                  text: TextSpan(
                    text: 'অ্যাকাউন্ট নেই? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                          text: 'সাইন আপ',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppColors.textActionSecondaryLight,
                                    fontWeight: FontWeight.w900,
                                  )),
                    ],
                  ),
                ),
              ),
              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }
}
