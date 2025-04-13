import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/core/services/debouncer.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/profile/viewmodel/change_password_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});

  @override
  ChangePasswordViewState createState() => ChangePasswordViewState();
}

class ChangePasswordViewState extends ConsumerState<ChangePasswordView>
    with CommonWidgets {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 120);
  final _loadingProvider = StateProvider<bool>((ref) => false);

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n!.passwordRequired;
    }
    // Password must contain at least one uppercase, one special character, and be at least 8 characters long
    final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[!@#\$&*~]).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return context.l10n!.passwordValidationMessage;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n!.confirmPasswordRequired;
    }
    if (value != _newPasswordController.text) {
      return context.l10n!.passwordsDoNotMatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(_loadingProvider);
    final passwordState = ref.watch(changePasswordStateProvider);

    // Check for successful password change
    ref.listen(changePasswordStateProvider, (previous, next) {
      if (!next.isLoading && !next.hasError) {
        next.value?.fold(
          (error) {
            // Error handled by the scaffold messenger below
          },
          (success) {
            if (success) {
              Fluttertoast.showToast(
                  msg: context.l10n!.passwordChangedSuccessfully);
              Navigator.pop(context);
            }
          },
        );
      }
    });

    return Scaffold(
      appBar: commonAppbar(context.l10n!.changePassword),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n!.currentPassword,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const Gap(6),
                      TextFormField(
                        controller: _oldPasswordController,
                        obscureText: !_oldPasswordVisible,
                        validator: _validatePassword,
                        onChanged: (value) {
                          ref
                              .read(oldPasswordProvider.notifier)
                              .setPassword(value);
                        },
                        decoration: InputDecoration(
                          hintText: context.l10n!.enterCurrentPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _oldPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _oldPasswordVisible = !_oldPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const Gap(20),
                      Text(
                        context.l10n!.newPassword,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const Gap(6),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: !_newPasswordVisible,
                        validator: _validatePassword,
                        onChanged: (value) {
                          ref
                              .read(newPasswordProvider.notifier)
                              .setPassword(value);
                        },
                        decoration: InputDecoration(
                          hintText: context.l10n!.enterNewPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _newPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _newPasswordVisible = !_newPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const Gap(20),
                      Text(
                        context.l10n!.confirmNewPassword,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const Gap(6),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_confirmPasswordVisible,
                        validator: _validateConfirmPassword,
                        onChanged: (value) {
                          ref
                              .read(confirmPasswordProvider.notifier)
                              .setPassword(value);
                        },
                        decoration: InputDecoration(
                          hintText: context.l10n!.confirmYourNewPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Button at the bottom
              Skeletonizer(
                enabled: isLoading,
                child: LongButton(
                  text: context.l10n!.updatePassword,
                  onPressed: isLoading
                      ? () {}
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _debouncer.run(
                              action: () async {
                                await ref
                                    .read(changePasswordStateProvider.notifier)
                                    .changePassword(
                                      oldPassword: _oldPasswordController.text,
                                      newPassword: _newPasswordController.text,
                                      confirmPassword:
                                          _confirmPasswordController.text,
                                    );

                                // Show error if any
                                if (context.mounted) {
                                  final state =
                                      ref.read(changePasswordStateProvider);
                                  state.value?.fold(
                                    (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              ErrorHandler().getErrorMessage()),
                                        ),
                                      );
                                      ErrorHandler().clearErrorMessage();
                                    },
                                    (success) {
                                      // Success handled by listener
                                    },
                                  );
                                }
                              },
                              loadingController:
                                  ref.read(_loadingProvider.notifier),
                            );
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
