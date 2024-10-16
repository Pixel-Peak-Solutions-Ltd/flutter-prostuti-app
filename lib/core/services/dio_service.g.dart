// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioHash() => r'ff1805b5c32a23784a3faa6cff0b6657815e0279';

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

/// See also [dio].
@ProviderFor(dio)
const dioProvider = DioFamily();

/// See also [dio].
class DioFamily extends Family<Dio> {
  /// See also [dio].
  const DioFamily();

  /// See also [dio].
  DioProvider call({
    required String accessToken,
  }) {
    return DioProvider(
      accessToken: accessToken,
    );
  }

  @override
  DioProvider getProviderOverride(
    covariant DioProvider provider,
  ) {
    return call(
      accessToken: provider.accessToken,
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
  String? get name => r'dioProvider';
}

/// See also [dio].
class DioProvider extends AutoDisposeProvider<Dio> {
  /// See also [dio].
  DioProvider({
    required String accessToken,
  }) : this._internal(
          (ref) => dio(
            ref as DioRef,
            accessToken: accessToken,
          ),
          from: dioProvider,
          name: r'dioProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$dioHash,
          dependencies: DioFamily._dependencies,
          allTransitiveDependencies: DioFamily._allTransitiveDependencies,
          accessToken: accessToken,
        );

  DioProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accessToken,
  }) : super.internal();

  final String accessToken;

  @override
  Override overrideWith(
    Dio Function(DioRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DioProvider._internal(
        (ref) => create(ref as DioRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accessToken: accessToken,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Dio> createElement() {
    return _DioProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DioProvider && other.accessToken == accessToken;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accessToken.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DioRef on AutoDisposeProviderRef<Dio> {
  /// The parameter `accessToken` of this provider.
  String get accessToken;
}

class _DioProviderElement extends AutoDisposeProviderElement<Dio> with DioRef {
  _DioProviderElement(super.provider);

  @override
  String get accessToken => (origin as DioProvider).accessToken;
}

String _$dioServiceHash() => r'47ce970e8a4b05df900761d9415d7f7c91f7ecf4';

/// See also [dioService].
@ProviderFor(dioService)
const dioServiceProvider = DioServiceFamily();

/// See also [dioService].
class DioServiceFamily extends Family<DioService> {
  /// See also [dioService].
  const DioServiceFamily();

  /// See also [dioService].
  DioServiceProvider call({
    required String accessToken,
  }) {
    return DioServiceProvider(
      accessToken: accessToken,
    );
  }

  @override
  DioServiceProvider getProviderOverride(
    covariant DioServiceProvider provider,
  ) {
    return call(
      accessToken: provider.accessToken,
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
  String? get name => r'dioServiceProvider';
}

/// See also [dioService].
class DioServiceProvider extends AutoDisposeProvider<DioService> {
  /// See also [dioService].
  DioServiceProvider({
    required String accessToken,
  }) : this._internal(
          (ref) => dioService(
            ref as DioServiceRef,
            accessToken: accessToken,
          ),
          from: dioServiceProvider,
          name: r'dioServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dioServiceHash,
          dependencies: DioServiceFamily._dependencies,
          allTransitiveDependencies:
              DioServiceFamily._allTransitiveDependencies,
          accessToken: accessToken,
        );

  DioServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accessToken,
  }) : super.internal();

  final String accessToken;

  @override
  Override overrideWith(
    DioService Function(DioServiceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DioServiceProvider._internal(
        (ref) => create(ref as DioServiceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accessToken: accessToken,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<DioService> createElement() {
    return _DioServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DioServiceProvider && other.accessToken == accessToken;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accessToken.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DioServiceRef on AutoDisposeProviderRef<DioService> {
  /// The parameter `accessToken` of this provider.
  String get accessToken;
}

class _DioServiceProviderElement extends AutoDisposeProviderElement<DioService>
    with DioServiceRef {
  _DioServiceProviderElement(super.provider);

  @override
  String get accessToken => (origin as DioServiceProvider).accessToken;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
