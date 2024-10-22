import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/features/signup/repository/signup_repo.dart';
import 'package:prostuti/features/signup/viewmodel/otp_viewmodel.dart';
import 'package:prostuti/features/signup/widgets/label.dart';

import '../../../common/widgets/long_button.dart';
import '../../login/view/login_view.dart';
import '../viewmodel/phone_number_viewmodel.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends ConsumerState<RegisterView> {
  late final TextEditingController _phoneController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController =
        TextEditingController(text: ref.read(phoneNumberProvider));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, automaticallyImplyLeading: false),
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
              const Gap(60),
              Text(
                'আপনার অ্যাকাউন্ট রেজিস্টার করুন',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Label(text: "ফোন নম্বর"),
                  const Gap(6),
                  TextFormField(
                    enabled: false,
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        hintText: "আপনার ফোন নম্বর লিখুন"),
                  ),
                  const Gap(20),
                  const Label(text: 'নাম'),
                  const Gap(6),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _nameController,
                    decoration:
                        const InputDecoration(hintText: "আপনার নাম লিখুন"),
                  ),
                  const Gap(20),
                  const Label(text: 'ইমেইল'),
                  const Gap(6),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration:
                        const InputDecoration(hintText: "আপনার ইমেইল লিখুন"),
                  ),
                  const Gap(20),
                  const Label(text: 'পাসওয়ার্ড'),
                  const Gap(6),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        hintText: "আপনার পাসওয়ার্ড লিখুন"),
                  ),
                  const Gap(16),
                ],
              ),
              const Gap(24),
              LongButton(
                text: 'এগিয়ে যাই',
                onPressed: () async {
                  final response =
                      await ref.read(signupRepoProvider).registerStudent(
                    {
                      "otpCode": ref.read(otpProvider),
                      "name": _nameController.text,
                      "email": _emailController.text,
                      "phone": "+88${ref.read(phoneNumberProvider)}",
                      "password": _passwordController.text,
                      "confirmPassword": _passwordController.text
                    },
                  );

                  if (response && context.mounted) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginView()));
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Signup Failed'),
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
