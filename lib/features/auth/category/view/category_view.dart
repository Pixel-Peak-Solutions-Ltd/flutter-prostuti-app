import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/core/services/debouncer.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/auth/category/repository/category_repo.dart';
import 'package:prostuti/features/auth/signup/viewmodel/name_viewmodel.dart';
import 'package:prostuti/features/auth/signup/viewmodel/otp_viewmodel.dart';
import 'package:prostuti/features/auth/signup/viewmodel/password_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/services/nav.dart';
import '../../login/view/login_view.dart';
import '../../signup/repository/signup_repo.dart';
import '../../signup/viewmodel/email_viewmodel.dart';
import '../../signup/viewmodel/phone_number_viewmodel.dart';
import '../widgets/buildCategoryList.dart';

class CategoryView extends ConsumerWidget with CommonWidgets {
  CategoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsyncValue = ref.watch(categoryListProvider);
    final icons = [
      "assets/images/backpack_03.png",
      "assets/images/mortarboard_01.png",
      "assets/images/briefcase_01.png"
    ];

    final _debouncer = Debouncer(milliseconds: 120);
    final _loadingProvider = StateProvider<bool>((ref) => false);
    final isLoading = ref.watch(_loadingProvider);

    return Scaffold(
      appBar: commonAppbar(context.l10n!.category),
      body: categoryAsyncValue.when(
        loading: () => Skeletonizer(
          enableSwitchAnimation: true,
          child: buildCategoryList(
              context, icons, List.filled(3, 'Item with Text'),
              isSkeleton: true),
        ),
        error: (error, stack) =>
            Center(child: Text('${context.l10n!.error}: $error')),
        data: (category) {
          final categories = category.data ?? [];
          return Skeletonizer(
            enabled: isLoading,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16)),
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                            color: AppColors.borderNormalLight, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          icons[index % icons.length], // Cycle through icons
                          height: 40,
                          width: 40,
                        ),
                        title: Text(categories[index]),
                        onTap: isLoading
                            ? () {}
                            : () {
                                _debouncer.run(
                                    action: () async {
                                      final response = await ref
                                          .read(signupRepoProvider)
                                          .registerStudent(
                                        {
                                          "otpCode": ref.read(otpProvider),
                                          "name":
                                              ref.read(nameViewmodelProvider),
                                          "email":
                                              ref.read(emailViewmodelProvider),
                                          "phone":
                                              "+88${ref.read(phoneNumberProvider)}",
                                          "password": ref
                                              .read(passwordViewmodelProvider),
                                          "confirmPassword": ref
                                              .read(passwordViewmodelProvider),
                                          "categoryType":
                                              categories[index].toString()
                                        },
                                      );

                                      if (response.data != null &&
                                          context.mounted) {
                                        Fluttertoast.showToast(
                                            msg:
                                                context.l10n!.signupSuccessful);
                                        Nav().pushAndRemoveUntil(
                                            const LoginView());
                                      } else if (response.error != null) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(ErrorHandler()
                                                .getErrorMessage()),
                                          ));
                                          _debouncer.cancel();
                                          ErrorHandler().clearErrorMessage();
                                        }
                                      }
                                    },
                                    loadingController:
                                        ref.read(_loadingProvider.notifier));
                              },
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
