// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_list_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$voucherListNotifierHash() =>
    r'a6667ea4ef22f90c67b6e06b8e1117495838dd5e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$VoucherListNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<VoucherModel>> {
  late final String? courseId;

  FutureOr<List<VoucherModel>> build({
    String? courseId,
  });
}

/// See also [VoucherListNotifier].
@ProviderFor(VoucherListNotifier)
const voucherListNotifierProvider = VoucherListNotifierFamily();

/// See also [VoucherListNotifier].
class VoucherListNotifierFamily extends Family<AsyncValue<List<VoucherModel>>> {
  /// See also [VoucherListNotifier].
  const VoucherListNotifierFamily();

  /// See also [VoucherListNotifier].
  VoucherListNotifierProvider call({
    String? courseId,
  }) {
    return VoucherListNotifierProvider(
      courseId: courseId,
    );
  }

  @override
  VoucherListNotifierProvider getProviderOverride(
    covariant VoucherListNotifierProvider provider,
  ) {
    return call(
      courseId: provider.courseId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'voucherListNotifierProvider';
}

/// See also [VoucherListNotifier].
class VoucherListNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    VoucherListNotifier, List<VoucherModel>> {
  /// See also [VoucherListNotifier].
  VoucherListNotifierProvider({
    String? courseId,
  }) : this._internal(
          () => VoucherListNotifier()..courseId = courseId,
          from: voucherListNotifierProvider,
          name: r'voucherListNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$voucherListNotifierHash,
          dependencies: VoucherListNotifierFamily._dependencies,
          allTransitiveDependencies:
              VoucherListNotifierFamily._allTransitiveDependencies,
          courseId: courseId,
        );

  VoucherListNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
  }) : super.internal();

  final String? courseId;

  @override
  FutureOr<List<VoucherModel>> runNotifierBuild(
    covariant VoucherListNotifier notifier,
  ) {
    return notifier.build(
      courseId: courseId,
    );
  }

  @override
  Override overrideWith(VoucherListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: VoucherListNotifierProvider._internal(
        () => create()..courseId = courseId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VoucherListNotifier,
      List<VoucherModel>> createElement() {
    return _VoucherListNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VoucherListNotifierProvider && other.courseId == courseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VoucherListNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<VoucherModel>> {
  /// The parameter `courseId` of this provider.
  String? get courseId;
}

class _VoucherListNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VoucherListNotifier,
        List<VoucherModel>> with VoucherListNotifierRef {
  _VoucherListNotifierProviderElement(super.provider);

  @override
  String? get courseId => (origin as VoucherListNotifierProvider).courseId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
