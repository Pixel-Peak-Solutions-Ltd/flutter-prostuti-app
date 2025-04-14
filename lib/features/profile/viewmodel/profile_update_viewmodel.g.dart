// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_update_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileUpdateStateHash() =>
    r'4677f6e85f6fbdfbdc550b40ab9e4a2c04148e4e';

/// See also [ProfileUpdateState].
@ProviderFor(ProfileUpdateState)
final profileUpdateStateProvider = AutoDisposeNotifierProvider<
    ProfileUpdateState, AsyncValue<Either<ErrorResponse, bool>>>.internal(
  ProfileUpdateState.new,
  name: r'profileUpdateStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileUpdateStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileUpdateState
    = AutoDisposeNotifier<AsyncValue<Either<ErrorResponse, bool>>>;
String _$profileNameHash() => r'28374b32e089f73c9197151631cae4b1a146457d';

/// See also [ProfileName].
@ProviderFor(ProfileName)
final profileNameProvider =
    AutoDisposeNotifierProvider<ProfileName, String>.internal(
  ProfileName.new,
  name: r'profileNameProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$profileNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileName = AutoDisposeNotifier<String>;
String _$profileImageHash() => r'67e432465529158b2268ecccc5efdbf4438262d2';

/// See also [ProfileImage].
@ProviderFor(ProfileImage)
final profileImageProvider =
    AutoDisposeNotifierProvider<ProfileImage, XFile?>.internal(
  ProfileImage.new,
  name: r'profileImageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$profileImageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileImage = AutoDisposeNotifier<XFile?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
