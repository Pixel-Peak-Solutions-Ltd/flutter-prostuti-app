import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/helpers/theme_provider.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/auth/signup/repository/signup_repo.dart';
import 'package:prostuti/features/auth/signup/viewmodel/phone_number_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/services/debouncer.dart';
import '../widgets/label.dart';
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
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
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
              const Gap(118),
              Text(
                context.l10n!.enterYourPhoneNumber,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(32),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Label(
                      text: context.l10n!.phoneNumber,
                    ),
                    const Gap(6),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n!.phoneRequired;
                        }
                        if (value.length != 11) {
                          return context.l10n!.phoneMustBe11Digits;
                        }
                        return null; // Returns null if validation is successful
                      },
                      keyboardType: TextInputType.number,
                      controller: _phoneController,
                      decoration: InputDecoration(
                          hintText: context.l10n!.enterYourPhoneNumber),
                    ),
                  ],
                ),
              ),
              const Gap(32),
              Skeletonizer(
                enabled: isLoading,
                child: LongButton(
                  text: context.l10n!.continueText,
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

                                  if (response.data != null &&
                                      context.mounted) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => const OtpView(
                                        fromPage: "Signup",
                                      ),
                                    ));
                                  } else if (response.error != null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          ErrorHandler().getErrorMessage()),
                                    ));
                                    _debouncer.cancel();
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
