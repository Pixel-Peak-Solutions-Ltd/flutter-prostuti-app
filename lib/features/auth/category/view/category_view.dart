import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/core/services/debouncer.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/auth/category/model/category_constant.dart';
import 'package:prostuti/features/auth/login/view/login_view.dart';
import 'package:prostuti/features/auth/signup/repository/signup_repo.dart';
import 'package:prostuti/features/auth/signup/viewmodel/email_viewmodel.dart';
import 'package:prostuti/features/auth/signup/viewmodel/name_viewmodel.dart';
import 'package:prostuti/features/auth/signup/viewmodel/otp_viewmodel.dart';
import 'package:prostuti/features/auth/signup/viewmodel/password_viewmodel.dart';
import 'package:prostuti/features/auth/signup/viewmodel/phone_number_viewmodel.dart';
import 'package:prostuti/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryView extends ConsumerStatefulWidget {
  final bool isRegistration;
  final String? studentId;

  const CategoryView({super.key, this.isRegistration = true, this.studentId});

  @override
  CategoryViewState createState() => CategoryViewState();
}

class CategoryViewState extends ConsumerState<CategoryView> with CommonWidgets {
  final _loadingProvider = StateProvider<bool>((ref) => false);
  final _debouncer = Debouncer(milliseconds: 120);
  bool _showSubcategories = false;

  // Selected category values
  String? _selectedMainCategory;
  String? _selectedSubCategory;

  @override
  void initState() {
    super.initState();

    // If updating from profile, load the current category
    if (!widget.isRegistration) {
      _loadCurrentCategory();
    }
  }

  void _loadCurrentCategory() {
    Future.microtask(() async {
      ref.read(_loadingProvider.notifier).state = true;

      try {
        final userProfile = await ref.read(userProfileProvider.future);
        if (userProfile.data?.categoryType != null) {
          setState(() {
            _selectedMainCategory = userProfile.data!.categoryType!;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("Failed to load current category: ${e.toString()}")),
          );
        }
      } finally {
        if (mounted) {
          ref.read(_loadingProvider.notifier).state = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(_loadingProvider);

    if (_selectedMainCategory != null &&
        _showSubcategories &&
        (_selectedMainCategory == MainCategory.ACADEMIC ||
            _selectedMainCategory == MainCategory.ADMISSION)) {
      return _buildSubcategoryView(context);
    }

    return Scaffold(
      appBar: commonAppbar(context.l10n!.category),
      body: Skeletonizer(
        enabled: isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n!.selectCategory,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (_selectedMainCategory != null && !_showSubcategories)
                _buildCurrentSelection(context),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16)),
                  child: ListView.builder(
                    itemCount: MainCategory.values.length,
                    itemBuilder: (context, index) {
                      final category = MainCategory.values[index];
                      return _buildCategoryItem(
                          context, category, _getCategoryIcon(category),
                          onSelect: () =>
                              _handleMainCategorySelection(category),
                          isSelected: _selectedMainCategory == category);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentSelection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Current: $_selectedMainCategory${_selectedSubCategory != null ? ' - $_selectedSubCategory' : ''}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoryView(BuildContext context) {
    final subcategories =
        getSubcategoriesForMainCategory(_selectedMainCategory!);
    final isLoading = ref.watch(_loadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Subcategory'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _showSubcategories = false;
            });
          },
        ),
      ),
      body: Skeletonizer(
        enabled: isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Subcategories for $_selectedMainCategory",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16)),
                  child: ListView.builder(
                    itemCount: subcategories.length,
                    itemBuilder: (context, index) {
                      final subcategory = subcategories[index];
                      return _buildCategoryItem(context, subcategory,
                          _getSubcategoryIcon(subcategory),
                          onSelect: () =>
                              _handleSubCategorySelection(subcategory),
                          isSelected: _selectedSubCategory == subcategory);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title, String iconPath,
      {required VoidCallback onSelect, bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : AppColors.borderNormalLight,
            width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(title),
        onTap: onSelect,
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  void _handleMainCategorySelection(String category) {
    setState(() {
      _selectedMainCategory = category;
      _selectedSubCategory =
          null; // Reset subcategory when main category changes
    });

    // For Job category, complete the selection directly
    if (category == MainCategory.JOB) {
      _completeSelection();
    } else {
      // For Academic and Admission, show subcategories
      setState(() {
        _showSubcategories = true;
      });
    }
  }

  void _handleSubCategorySelection(String subcategory) {
    setState(() {
      _selectedSubCategory = subcategory;
    });
    _completeSelection();
  }

  void _completeSelection() {
    if (_selectedMainCategory == null) return;

    // Validate the selection
    if ((_selectedMainCategory == MainCategory.ACADEMIC ||
            _selectedMainCategory == MainCategory.ADMISSION) &&
        (_selectedSubCategory == null || _selectedSubCategory!.isEmpty)) {
      // Show error - subcategory required
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Please select a subcategory for $_selectedMainCategory")),
      );
      return;
    }

    if (widget.isRegistration) {
      _registerWithCategory();
    } else {
      _updateCategory();
    }
  }

  void _registerWithCategory() {
    _debouncer.run(
        action: () async {
          try {
            // Create registration payload
            final payload = {
              "otpCode": ref.read(otpProvider),
              "name": ref.read(nameViewmodelProvider),
              "email": ref.read(emailViewmodelProvider),
              "phone": "+88${ref.read(phoneNumberProvider)}",
              "password": ref.read(passwordViewmodelProvider),
              "confirmPassword": ref.read(passwordViewmodelProvider),
              "categoryType": _selectedMainCategory,
              if (_selectedSubCategory != null)
                "subCategory": _selectedSubCategory
            };

            // Register student
            final response =
                await ref.read(signupRepoProvider).registerStudent(payload);

            if (response.data != null && mounted) {
              Fluttertoast.showToast(msg: context.l10n!.signupSuccessful);
              Nav().pushAndRemoveUntil(const LoginView());
            } else if (response.error != null && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(ErrorHandler().getErrorMessage()),
              ));
              _debouncer.cancel();
              ErrorHandler().clearErrorMessage();
            }
          } catch (e) {
            print("Exception during registration: $e");
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Registration failed: $e"),
              ));
            }
            _debouncer.cancel();
          }
        },
        loadingController: ref.read(_loadingProvider.notifier));
  }

  void _updateCategory() {
    _debouncer.run(
      action: () async {
        try {
          String studentId;
          if (widget.studentId == null) {
            final userProfile = await ref.read(userProfileProvider.future);
            if (userProfile.data?.studentId == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Student ID is required to update category"),
              ));
              return;
            }
            studentId = userProfile.data!.studentId!;
          } else {
            studentId = widget.studentId!;
          }

          final dioService = ref.read(dioServiceProvider);

          // KEEP THIS FORMAT - it's working with your backend
          final payload = {
            "mainCategory": _selectedMainCategory,
            if (_selectedSubCategory != null &&
                _selectedSubCategory!.isNotEmpty)
              "subCategory": _selectedSubCategory,
          };

          print("Payload: $payload");

          // Ensure content-type header is set

          final response = await dioService.patchRequest(
            "/student/update-category",
            // Update this path to match your new endpoint
            data: payload,
          );

          if (response.statusCode == 200) {
            ref.refresh(userProfileProvider);
            Fluttertoast.showToast(msg: "Category updated successfully");
            Navigator.pop(context);
          } else {
            String errorMsg = "Failed to update category";
            if (response.data is Map && response.data['message'] != null) {
              errorMsg = response.data['message'];
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(errorMsg),
            ));
          }
        } catch (e) {
          print("Exception: $e");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Failed to update category: ${e.toString()}"),
            ));
          }
          _debouncer.cancel();
        }
      },
      loadingController: ref.read(_loadingProvider.notifier),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case MainCategory.ACADEMIC:
        return "assets/images/backpack_03.png";
      case MainCategory.ADMISSION:
        return "assets/images/mortarboard_01.png";
      case MainCategory.JOB:
        return "assets/images/briefcase_01.png";
      default:
        return "assets/images/backpack_03.png";
    }
  }

  String _getSubcategoryIcon(String subcategory) {
    // Different icons for different subcategories
    if (subcategory == AcademicSubCategory.SCIENCE) {
      return "assets/images/microscope_01.png";
    } else if (subcategory == AcademicSubCategory.COMMERCE) {
      return "assets/images/document_01.png";
    } else if (subcategory == AcademicSubCategory.ARTS) {
      return "assets/images/palette_01.png";
    } else if (subcategory == AdmissionSubCategory.ENGINEERING) {
      return "assets/images/building_02.png";
    } else if (subcategory == AdmissionSubCategory.MEDICAL) {
      return "assets/images/stethoscope_01.png";
    } else if (subcategory == AdmissionSubCategory.UNIVERSITY) {
      return "assets/images/graduation_hat_01.png";
    }
    return "assets/images/backpack_03.png"; // Default icon
  }
}

// Extension methods for localization
extension BuildContextExtensions on BuildContext {
  String get selectCategory => l10n!.selectCategory ?? 'Select Category';
}
