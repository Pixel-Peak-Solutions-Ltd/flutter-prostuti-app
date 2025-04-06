import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:prostuti/common/helpers/theme_provider.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/auth/signup/view/register_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../common/widgets/long_button.dart';
import '../../../../core/configs/app_colors.dart';
import '../../../../core/services/debouncer.dart';
import '../../../../core/services/error_handler.dart';
import '../../forget_password/view/new_password_view.dart';
import '../repository/signup_repo.dart';
import '../viewmodel/otp_viewmodel.dart';
import '../viewmodel/phone_number_viewmodel.dart';

class OtpView extends ConsumerStatefulWidget {
  final String fromPage;

  const OtpView({super.key, required this.fromPage});

  @override
  OtpViewState createState() => OtpViewState();
}

class OtpViewState extends ConsumerState<OtpView> {
  final _otpController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 120);
  final _loadingProvider = StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(_loadingProvider);
    final isDarkMode = ref.watch(
        themeNotifierProvider.select((value) => value == ThemeMode.dark));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Center(
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
                const Gap(76),
                Text(
                  context.l10n!.verifyOtp,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Gap(8),
                Text(
                  context.l10n!.enterOtpCode,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                const Gap(32),
                Pinput(
                  controller: _otpController,
                  showCursor: true,
                  onCompleted: (pin) =>
                      ref.read(otpProvider.notifier).setOtp(pin),
                ),
                const Gap(32),
                TextButton(
                  onPressed: () async {
                    await ref.watch(signupRepoProvider).sendVerificationCode(
                        phoneNo: ref.read(phoneNumberProvider),
                        type: widget.fromPage == "Signup"
                            ? "ACCOUNT_CREATION"
                            : "PASSWORD_RESET");
                  },
                  child: Text(
                    context.l10n!.resendCode,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.textActionTertiaryLight,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                const Gap(32),
                Skeletonizer(
                  enabled: isLoading,
                  child: LongButton(
                    text: context.l10n!.continueText,
                    onPressed: () async {
                      _debouncer.run(
                          action: () async {
                            final response = await ref
                                .read(signupRepoProvider)
                                .verifyPhoneNumber(
                                    phoneNo:
                                        "+88${ref.read(phoneNumberProvider)}",
                                    code: _otpController.text.toString(),
                                    type: widget.fromPage == "Signup"
                                        ? "ACCOUNT_CREATION"
                                        : "PASSWORD_RESET");

                            if (response.data != null && context.mounted) {
                              widget.fromPage == "Signup"
                                  ? Navigator.of(context)
                                      .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterView(),
                                    ))
                                  : Navigator.of(context)
                                      .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const NewPasswordView(),
                                    ));
                            } else if (response.error != null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(ErrorHandler().getErrorMessage()),
                              ));
                              _debouncer.cancel();
                              ErrorHandler().clearErrorMessage();
                            }
                          },
                          loadingController:
                              ref.read(_loadingProvider.notifier));
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
