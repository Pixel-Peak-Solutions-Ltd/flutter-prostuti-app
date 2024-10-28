import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/features/signup/repository/signup_repo.dart';
import 'package:prostuti/features/signup/viewmodel/phone_number_viewmodel.dart';
import 'package:prostuti/features/signup/widgets/label.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../common/widgets/long_button.dart';
import '../../../core/services/debouncer.dart';
import '../../../core/services/error_handler.dart';
import 'otp_view.dart';

class PhoneView extends ConsumerStatefulWidget {
  const PhoneView({super.key});

  @override
  PhoneViewState createState() => PhoneViewState();
}

class PhoneViewState extends ConsumerState<PhoneView> {
  final _phoneController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 120);
  final _loadingProvider = StateProvider<bool>((ref) => false);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
                'আপনার ফোন নম্বর লিখুন',
                style: Theme.of(context).textTheme.titleLarge,
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
                  ],
                ),
              ),
              const Gap(32),
              Skeletonizer(
                enabled: isLoading,
                child: LongButton(
                  text: 'এগিয়ে যাই',
                  onPressed: isLoading
                      ? () {}
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _debouncer.run(
                                action: () async {
                                  final response = await ref
                                      .read(signupRepoProvider)
                                      .sendVerificationCode(
                                          phoneNo:
                                              _phoneController.text.toString());

                                  ref
                                      .watch(phoneNumberProvider.notifier)
                                      .setPhoneNumber(_phoneController.text);

                                  if (response && context.mounted) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => const OtpView(
                                        fromPage: "Signup",
                                      ),
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          ErrorHandler().getErrorMessage()),
                                    ));
                                    ErrorHandler().clearErrorMessage();
                                  }
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
    );
  }
}
