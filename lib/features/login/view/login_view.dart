import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/core/configs/app_colors.dart';

import '../../signup/view/phone_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends ConsumerState<LoginView> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

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
                  const Gap(20),
                  Text(
                    'পাসওয়ার্ড',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(6),
                  TextFormField(
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
                              value: false,
                              onChanged: (value) {},
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
                        onPressed: () {},
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
              const Gap(24),
              LongButton(
                text: 'লগ ইন',
                onPressed: () {},
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
