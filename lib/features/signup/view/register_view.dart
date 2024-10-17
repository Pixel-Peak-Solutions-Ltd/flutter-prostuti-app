import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../common/widgets/long_button.dart';
import '../viewmodel/phone_number_viewmodel.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

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
                  Text(
                    'ফোন নম্বর',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(6),
                  TextFormField(
                    enabled: false,
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        hintText: "আপনার ফোন নম্বর লিখুন"),
                  ),
                  const Gap(20),
                  Text(
                    'নাম',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(6),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _nameController,
                    decoration:
                        const InputDecoration(hintText: "আপনার নাম লিখুন"),
                  ),
                  const Gap(20),
                  Text(
                    'ইমেইল',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(6),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration:
                        const InputDecoration(hintText: "আপনার ইমেইল লিখুন"),
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
                ],
              ),
              const Gap(24),
              LongButton(
                text: 'এগিয়ে যাই',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
