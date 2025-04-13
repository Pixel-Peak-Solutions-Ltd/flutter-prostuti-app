import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/debouncer.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/auth/category/model/category_model.dart';
import 'package:prostuti/features/auth/category/repository/category_repo.dart';
import 'package:prostuti/features/auth/category/viewmodel/category_viewmodel.dart';
import 'package:prostuti/features/auth/category/widgets/buildCategoryList.dart';
import 'package:prostuti/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryUpdateView extends ConsumerWidget with CommonWidgets {
  CategoryUpdateView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsyncValue = ref.watch(categoryListProvider);
    final userProfileAsyncValue = ref.watch(userProfileProvider);

    final icons = [
      "assets/images/backpack_03.png",
      "assets/images/mortarboard_01.png",
      "assets/images/briefcase_01.png"
    ];

    final _debouncer = Debouncer(milliseconds: 120);
    final _loadingProvider = StateProvider<bool>((ref) => false);
    final isLoading = ref.watch(_loadingProvider);

    return Scaffold(
      appBar: commonAppbar(context.l10n!.updateCategory),
      body: userProfileAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('${context.l10n!.error}: $error')),
        data: (userData) {
          // Extract current category from user profile
          final currentCategory = userData.data?.categoryType;
          // Set student ID for later use
          if (userData.data?.studentId != null) {
            ref
                .read(studentIdProvider.notifier)
                .setStudentId(userData.data!.studentId!);
          }

          return categoryAsyncValue.when(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n!.currentCategory +
                              ": ${currentCategory ?? 'Not set'}",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n!.selectNewCategory,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n!.pleaseSelectYourCategory,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: buildCategoryList(
                            context,
                            icons,
                            categories,
                            onTap: isLoading
                                ? null
                                : (index) {
                                    final selectedCategory = categories[index];

                                    // Set the selected main category
                                    ref
                                        .read(selectedMainCategoryProvider
                                            .notifier)
                                        .setMainCategory(selectedCategory);

                                    // For Job category, no subcategory is needed
                                    if (selectedCategory ==
                                        CategoryConstants.JOB) {
                                      _updateCategory(
                                          context,
                                          ref,
                                          selectedCategory,
                                          null,
                                          _debouncer,
                                          _loadingProvider);
                                    } else {
                                      // Navigate to subcategory selection
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            SubCategoryUpdateView(
                                          mainCategory: selectedCategory,
                                        ),
                                      ));
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _updateCategory(
    BuildContext context,
    WidgetRef ref,
    String mainCategory,
    String? subCategory,
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
            // Refresh user profile to reflect the changes
            ref.invalidate(userProfileProvider);

            Fluttertoast.showToast(
                msg: context.l10n!.categoryUpdatedSuccessfully);
            Navigator.pop(context);
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

class SubCategoryUpdateView extends ConsumerWidget with CommonWidgets {
  final String mainCategory;

  SubCategoryUpdateView({super.key, required this.mainCategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get subcategories for the selected main category
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

                                // Update the category
                                _updateCategory(
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

  void _updateCategory(
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
            // Refresh user profile to reflect the changes
            ref.invalidate(userProfileProvider);

            Fluttertoast.showToast(
                msg: context.l10n!.categoryUpdatedSuccessfully);
            Navigator.pop(context);
            Navigator.pop(context); // Pop twice to go back to profile
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
