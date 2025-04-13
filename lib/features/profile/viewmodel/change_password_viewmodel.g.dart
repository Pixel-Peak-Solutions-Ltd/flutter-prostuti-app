// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$changePasswordStateHash() =>
    r'4857f7b98e8a6a1d7eeff3daab384f8e3c29feda';

/// See also [ChangePasswordState].
@ProviderFor(ChangePasswordState)
final changePasswordStateProvider = AutoDisposeNotifierProvider<
    ChangePasswordState, AsyncValue<Either<ErrorResponse, bool>>>.internal(
  ChangePasswordState.new,
  name: r'changePasswordStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$changePasswordStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChangePasswordState
    = AutoDisposeNotifier<AsyncValue<Either<ErrorResponse, bool>>>;
String _$oldPasswordHash() => r'5e6a4cde5ebe7b71d9064d5e17206879ced36258';

/// See also [OldPassword].
@ProviderFor(OldPassword)
final oldPasswordProvider =
    AutoDisposeNotifierProvider<OldPassword, String>.internal(
  OldPassword.new,
  name: r'oldPasswordProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$oldPasswordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OldPassword = AutoDisposeNotifier<String>;
String _$newPasswordHash() => r'4fdcffa2ea3def1335bd36b027ef5ab21ca40da9';

/// See also [NewPassword].
@ProviderFor(NewPassword)
final newPasswordProvider =
    AutoDisposeNotifierProvider<NewPassword, String>.internal(
  NewPassword.new,
  name: r'newPasswordProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$newPasswordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NewPassword = AutoDisposeNotifier<String>;
String _$confirmPasswordHash() => r'03fa77a0dfeaeb95ecf62ba81c4a8a92c360c668';

/// See also [ConfirmPassword].
@ProviderFor(ConfirmPassword)
final confirmPasswordProvider =
    AutoDisposeNotifierProvider<ConfirmPassword, String>.internal(
  ConfirmPassword.new,
  name: r'confirmPasswordProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$confirmPasswordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConfirmPassword = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
