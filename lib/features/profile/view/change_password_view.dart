import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/core/services/debouncer.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/profile/viewmodel/change_password_viewmodel.dart';
import 'package:prostuti/features/profile/viewmodel/profile_update_viewmodel.dart';
import 'package:prostuti/features/profile/viewmodel/profile_viewmodel.dart';
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
  final _nameController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 120);
  final _loadingProvider = StateProvider<bool>((ref) => false);
  final _showPasswordSection = StateProvider<bool>((ref) => false);
  final _tabController =
      StateProvider<int>((ref) => 0); // 0 for profile, 1 for password

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  final _imagePicker = ImagePicker();
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();

    // Initialize name from profile data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() async {
    // Get current profile data
    final profileData = await ref.read(userProfileProvider.future);
    if (profileData.data?.name != null) {
      _nameController.text = profileData.data!.name!;
      ref.read(profileNameProvider.notifier).setName(profileData.data!.name!);
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
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

  Future<void> _pickImage() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        debugPrint("Image selected: ${image.path}");

        setState(() {
          _selectedImage = image;
        });

        // Set the image in the provider AND verify it worked
        ref.read(profileImageProvider.notifier).setImage(image);

        // Force a rebuild to ensure state is updated
        setState(() {});

        // Show feedback to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selected: ${image.name}')),
        );
      }
    } catch (e) {
      debugPrint("Error picking image: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(_loadingProvider);
    final passwordState = ref.watch(changePasswordStateProvider);
    final profileUpdateState = ref.watch(profileUpdateStateProvider);
    final currentTabIndex = ref.watch(_tabController);
    final showPasswordSection = ref.watch(_showPasswordSection);

    final userProfileAsyncValue = ref.watch(userProfileProvider);

    // Check for successful profile update
    ref.listen(profileUpdateStateProvider, (previous, next) {
      if (!next.isLoading && !next.hasError) {
        next.value?.fold(
          (error) {
            // Error handled by the scaffold messenger below
          },
          (success) {
            if (success) {
              // Refresh profile data
              ref.invalidate(userProfileProvider);

              // Show success message
              Fluttertoast.showToast(
                  msg: context.l10n!.profileUpdatedSuccessfully);

              // Navigate back to refresh the profile screen
              Navigator.pop(context);
            }
          },
        );
      }
    });

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
            }
          },
        );
      }
    });

    return Scaffold(
      appBar: commonAppbar(context.l10n!.profileInformation),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab selector
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            ref.read(_tabController.notifier).state = 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: currentTabIndex == 0
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            context.l10n!.profile,
                            style: TextStyle(
                              color: currentTabIndex == 0
                                  ? Colors.white
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(_tabController.notifier).state = 1;
                          ref.read(_showPasswordSection.notifier).state = true;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: currentTabIndex == 1
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            context.l10n!.password,
                            style: TextStyle(
                              color: currentTabIndex == 1
                                  ? Colors.white
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: userProfileAsyncValue.when(
                    data: (profileData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Tab Content
                          if (currentTabIndex == 0) ...[
                            // Profile Image
                            Center(
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundImage: _selectedImage != null
                                          ? FileImage(
                                              File(_selectedImage!.path))
                                          : (profileData.data?.image?.path !=
                                                      null
                                                  ? NetworkImage(profileData
                                                      .data!.image!.path!)
                                                  : const AssetImage(
                                                      'assets/images/test_dp.jpg'))
                                              as ImageProvider,
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(24),

                            // Name Field
                            Text(
                              context.l10n!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const Gap(6),
                            TextFormField(
                              controller: _nameController,
                              onChanged: (value) {
                                ref
                                    .read(profileNameProvider.notifier)
                                    .setName(value);
                              },
                              decoration: InputDecoration(
                                hintText: context.l10n!.enterYourName,
                                border: const OutlineInputBorder(),
                              ),
                            ),

                            // Show option to change password
                            const Gap(24),
                            if (!showPasswordSection) ...[
                              TextButton.icon(
                                onPressed: () {
                                  ref
                                      .read(_showPasswordSection.notifier)
                                      .state = true;
                                  ref.read(_tabController.notifier).state = 1;
                                },
                                icon: const Icon(Icons.lock_outline),
                                label: Text(context.l10n!.changePassword),
                              ),
                            ],
                          ],

                          // Password Tab Content
                          if (currentTabIndex == 1 && showPasswordSection) ...[
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
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _oldPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _oldPasswordVisible =
                                          !_oldPasswordVisible;
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
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _newPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _newPasswordVisible =
                                          !_newPasswordVisible;
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
                                border: const OutlineInputBorder(),
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
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text("Error loading profile: $error"),
                    ),
                  ),
                ),
              ),

              // Update Button
              const Gap(16),
              Skeletonizer(
                enabled: isLoading,
                child: LongButton(
                  text: currentTabIndex == 0
                      ? context.l10n!.updateProfile
                      : context.l10n!.updatePassword,
                  onPressed: isLoading
                      ? () {}
                      : () {
                          _submitForm(context);
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    final currentTabIndex = ref.read(_tabController);

    if (currentTabIndex == 0) {
      // Profile update
      _handleProfileUpdate();
    } else {
      // Password update
      _handlePasswordUpdate();
    }
  }

  void _handleProfileUpdate() {
    final userProfileAsync = ref.read(userProfileProvider);

    userProfileAsync.whenData((profile) {
      final userProfileAsync = ref.read(userProfileProvider);

      userProfileAsync.whenData((profile) {
        final studentId = profile.data?.studentId;
        if (studentId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n!.errorUpdatingProfile)),
          );
          return;
        }

        final name = _nameController.text.trim();

        // IMPORTANT CHANGE: Use _selectedImage directly
        final hasSelectedNewImage = _selectedImage != null;

        // Debug print to check values
        debugPrint("Current name: '${profile.data?.name}'");
        debugPrint("New name: '$name'");
        debugPrint("Selected image: ${_selectedImage?.path}");

        // IMPROVED CHANGE DETECTION
        final currentName = (profile.data?.name ?? "").trim();
        bool hasNameChanged = name.isNotEmpty && name != currentName;

        // Use the _selectedImage variable directly for detection
        bool hasImageChanged = hasSelectedNewImage;

        debugPrint("Name changed: $hasNameChanged");
        debugPrint("Image changed: $hasImageChanged");

        if (!hasNameChanged && !hasImageChanged) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n!.noChangesDetected)),
          );
          return;
        }

        _debouncer.run(
          action: () async {
            await ref.read(profileUpdateStateProvider.notifier).updateProfile(
                  name: hasNameChanged ? name : null,
                  // IMPORTANT CHANGE: Pass _selectedImage directly
                  image: hasImageChanged ? _selectedImage : null,
                  studentId: studentId,
                );

            // Show error if any
            if (context.mounted) {
              final state = ref.read(profileUpdateStateProvider);
              state.value?.fold(
                (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ErrorHandler().getErrorMessage())),
                  );
                  ErrorHandler().clearErrorMessage();
                },
                (success) {
                  // Success handled by listener
                  if (success) {
                    // We'll navigate back in the listener to ensure data refreshes
                    debugPrint("Profile update successful!");
                  } else {
                    debugPrint(
                        "Profile update returned false - no changes applied on server side");
                  }
                },
              );
            }
          },
          loadingController: ref.read(_loadingProvider.notifier),
        );
      });
    });
  }

  void _handlePasswordUpdate() {
    if (_formKey.currentState!.validate()) {
      _debouncer.run(
        action: () async {
          await ref.read(changePasswordStateProvider.notifier).changePassword(
                oldPassword: _oldPasswordController.text,
                newPassword: _newPasswordController.text,
                confirmPassword: _confirmPasswordController.text,
              );

          // Show error if any
          if (context.mounted) {
            final state = ref.read(changePasswordStateProvider);
            state.value?.fold(
              (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ErrorHandler().getErrorMessage())),
                );
                ErrorHandler().clearErrorMessage();
              },
              (success) {
                // Success handled by listener
                if (success) {
                  // Clear password fields
                  _oldPasswordController.clear();
                  _newPasswordController.clear();
                  _confirmPasswordController.clear();

                  // Navigate back if successful
                  Navigator.pop(context);
                }
              },
            );
          }
        },
        loadingController: ref.read(_loadingProvider.notifier),
      );
    }
  }
}
