import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/core/services/debouncer.dart';
import 'package:prostuti/features/auth/category/view/category_view.dart';
import 'package:prostuti/features/auth/signup/viewmodel/name_viewmodel.dart';
import 'package:prostuti/features/auth/signup/viewmodel/password_viewmodel.dart';
import 'package:prostuti/features/auth/signup/widgets/label.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../viewmodel/email_viewmodel.dart';
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
  final _debouncer = Debouncer(milliseconds: 20);
  final _loadingProvider = StateProvider<bool>((ref) => false);
  final _formKey = GlobalKey<FormState>();

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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'ইমেইল প্রয়োজন';
    }
    // Basic email regex pattern
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'সঠিক ইমেইল লিখুন';
    }
    return null;
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
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  isDarkMode
                      ? "assets/images/prostuti_logo_dark.svg"
                      : "assets/images/prostuti_logo_light.svg",
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
                      onChanged: (value) => ref
                          .read(nameViewmodelProvider.notifier)
                          .setName(value),
                      decoration:
                          const InputDecoration(hintText: "আপনার নাম লিখুন"),
                    ),
                    const Gap(20),
                    const Label(text: 'ইমেইল'),
                    const Gap(6),
                    TextFormField(
                      validator: _validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      onChanged: (value) => ref
                          .read(emailViewmodelProvider.notifier)
                          .setEmail(value),
                      decoration:
                          const InputDecoration(hintText: "আপনার ইমেইল লিখুন"),
                    ),
                    const Gap(20),
                    const Label(text: 'পাসওয়ার্ড'),
                    const Gap(6),
                    TextFormField(
                      validator: _validatePassword,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => ref
                          .read(passwordViewmodelProvider.notifier)
                          .setPassword(value),
                      obscureText: true,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          hintText: "আপনার পাসওয়ার্ড লিখুন"),
                    ),
                    const Gap(16),
                  ],
                ),
                const Gap(24),
                Skeletonizer(
                  enabled: isLoading,
                  child: LongButton(
                    text: 'এগিয়ে যাই',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _debouncer.run(
                            action: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CategoryView()));
                            },
                            loadingController:
                                ref.read(_loadingProvider.notifier));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
