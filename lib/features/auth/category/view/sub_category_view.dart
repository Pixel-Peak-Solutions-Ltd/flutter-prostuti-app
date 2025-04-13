import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/debouncer.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/auth/category/repository/category_repo.dart';
import 'package:prostuti/features/auth/category/viewmodel/category_viewmodel.dart';
import 'package:prostuti/features/auth/signup/repository/signup_repo.dart';
import 'package:prostuti/features/auth/signup/viewmodel/name_viewmodel.dart';
import 'package:prostuti/features/auth/signup/viewmodel/otp_viewmodel.dart';
import 'package:prostuti/features/auth/signup/viewmodel/password_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/services/nav.dart';
import '../../login/view/login_view.dart';
import '../../signup/viewmodel/email_viewmodel.dart';
import '../../signup/viewmodel/phone_number_viewmodel.dart';
import '../widgets/buildCategoryList.dart';

class SubCategoryView extends ConsumerWidget with CommonWidgets {
  final String mainCategory;

  SubCategoryView({super.key, required this.mainCategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get subcategories for the selected main category
    // First try from the API provider
    final subcategoryAsyncValue =
        ref.watch(subcategoryListProvider(mainCategory));

    final _debouncer = Debouncer(milliseconds: 120);
    final _loadingProvider = StateProvider<bool>((ref) => false);
    final isLoading = ref.watch(_loadingProvider);

    return Scaffold(
      appBar:
          commonAppbar('${context.l10n!.select} ${context.l10n!.subcategory}'),
      body: subcategoryAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${context.l10n!.error}: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n!.goBack),
            )
          ],
        )),
        data: (subcategory) {
          final subcategories = subcategory.data ?? [];

          // If no subcategories (should never happen for Academic/Admission), show error
          if (subcategories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.l10n!.noSubcategoriesFound),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.l10n!.goBack),
                  )
                ],
              ),
            );
          }

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.l10n!.select} ${mainCategory} ${context.l10n!.subcategory}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n!.pleaseSelectYourSubcategory,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: buildSubCategoryList(
                        context,
                        subcategories,
                        onTap: isLoading
                            ? null
                            : (index) {
                                final selectedSubcategory =
                                    subcategories[index];

                                // Set the selected subcategory
                                ref
                                    .read(selectedSubCategoryProvider.notifier)
                                    .setSubCategory(selectedSubcategory);

                                // Register or update the category
                                _registerOrUpdateCategory(
                                    context,
                                    ref,
                                    mainCategory,
                                    selectedSubcategory,
                                    _debouncer,
                                    _loadingProvider);
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _registerOrUpdateCategory(
    BuildContext context,
    WidgetRef ref,
    String mainCategory,
    String subCategory,
    Debouncer debouncer,
    StateProvider<bool> loadingProvider,
  ) {
    // Check if we're in the registration flow
    final hasStudentId = ref.read(studentIdProvider) != null;

    if (hasStudentId) {
      // We're updating an existing student's category
      _updateStudentCategory(
          context, ref, mainCategory, subCategory, debouncer, loadingProvider);
    } else {
      // We're in the registration flow
      _registerStudent(
          context, ref, mainCategory, subCategory, debouncer, loadingProvider);
    }
  }

  void _registerStudent(
    BuildContext context,
    WidgetRef ref,
    String mainCategory,
    String subCategory,
    Debouncer debouncer,
    StateProvider<bool> loadingProvider,
  ) {
    debouncer.run(
        action: () async {
          // First register the student
          final registrationResponse =
              await ref.read(signupRepoProvider).registerStudent(
            {
              "otpCode": ref.read(otpProvider),
              "name": ref.read(nameViewmodelProvider),
              "email": ref.read(emailViewmodelProvider),
              "phone": "+88${ref.read(phoneNumberProvider)}",
              "password": ref.read(passwordViewmodelProvider),
              "confirmPassword": ref.read(passwordViewmodelProvider),
            },
          );

          if (registrationResponse.data != null) {
            // Registration successful, now update category
            String studentId = '';

            // Extract student ID from response if available
            if (registrationResponse.data is Map &&
                registrationResponse.data['data'] is Map &&
                registrationResponse.data['data']['studentId'] != null) {
              studentId = registrationResponse.data['data']['studentId'];
              ref.read(studentIdProvider.notifier).setStudentId(studentId);
            } else {
              // If studentId not available, use a default logic to try to get it
              studentId = "SID${DateTime.now().millisecondsSinceEpoch}";
            }

            // Now update the student's category
            final categoryResponse = await ref
                .read(categoryRepoProvider)
                .updateStudentCategory(studentId, mainCategory, subCategory);

            if (categoryResponse.data != null && context.mounted) {
              Fluttertoast.showToast(msg: context.l10n!.signupSuccessful);
              Nav().pushAndRemoveUntil(const LoginView());
            } else if (categoryResponse.error != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(ErrorHandler().getErrorMessage()),
              ));
              debouncer.cancel();
              ErrorHandler().clearErrorMessage();
            }
          } else if (registrationResponse.error != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(ErrorHandler().getErrorMessage()),
            ));
            debouncer.cancel();
            ErrorHandler().clearErrorMessage();
          }
        },
        loadingController: ref.read(loadingProvider.notifier));
  }

  void _updateStudentCategory(
    BuildContext context,
    WidgetRef ref,
    String mainCategory,
    String subCategory,
    Debouncer debouncer,
    StateProvider<bool> loadingProvider,
  ) {
    final studentId = ref.read(studentIdProvider);
    if (studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.l10n!.studentIdNotFound),
      ));
      return;
    }

    debouncer.run(
        action: () async {
          final response = await ref
              .read(categoryRepoProvider)
              .updateStudentCategory(studentId, mainCategory, subCategory);

          if (response.data != null && context.mounted) {
            Fluttertoast.showToast(
                msg: context.l10n!.categoryUpdatedSuccessfully);
            Nav().pushAndRemoveUntil(const LoginView());
          } else if (response.error != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(ErrorHandler().getErrorMessage()),
            ));
            debouncer.cancel();
            ErrorHandler().clearErrorMessage();
          }
        },
        loadingController: ref.read(loadingProvider.notifier));
  }
}
