// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_mcq_test_history.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMCQTestHistoryHash() => r'59e957c5683fbef05078f44d2ba94dc1fed0d587';

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

abstract class _$GetMCQTestHistory
    extends BuildlessAutoDisposeAsyncNotifier<TestHistory> {
  late final String id;

  FutureOr<TestHistory> build(
    String id,
  );
}

/// See also [GetMCQTestHistory].
@ProviderFor(GetMCQTestHistory)
const getMCQTestHistoryProvider = GetMCQTestHistoryFamily();

/// See also [GetMCQTestHistory].
class GetMCQTestHistoryFamily extends Family<AsyncValue<TestHistory>> {
  /// See also [GetMCQTestHistory].
  const GetMCQTestHistoryFamily();

  /// See also [GetMCQTestHistory].
  GetMCQTestHistoryProvider call(
    String id,
  ) {
    return GetMCQTestHistoryProvider(
      id,
    );
  }

  @override
  GetMCQTestHistoryProvider getProviderOverride(
    covariant GetMCQTestHistoryProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'getMCQTestHistoryProvider';
}

/// See also [GetMCQTestHistory].
class GetMCQTestHistoryProvider extends AutoDisposeAsyncNotifierProviderImpl<
    GetMCQTestHistory, TestHistory> {
  /// See also [GetMCQTestHistory].
  GetMCQTestHistoryProvider(
    String id,
  ) : this._internal(
          () => GetMCQTestHistory()..id = id,
          from: getMCQTestHistoryProvider,
          name: r'getMCQTestHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMCQTestHistoryHash,
          dependencies: GetMCQTestHistoryFamily._dependencies,
          allTransitiveDependencies:
              GetMCQTestHistoryFamily._allTransitiveDependencies,
          id: id,
        );

  GetMCQTestHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  FutureOr<TestHistory> runNotifierBuild(
    covariant GetMCQTestHistory notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(GetMCQTestHistory Function() create) {
    return ProviderOverride(
      origin: this,
      override: GetMCQTestHistoryProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GetMCQTestHistory, TestHistory>
      createElement() {
    return _GetMCQTestHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMCQTestHistoryProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetMCQTestHistoryRef on AutoDisposeAsyncNotifierProviderRef<TestHistory> {
  /// The parameter `id` of this provider.
  String get id;
}

class _GetMCQTestHistoryProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GetMCQTestHistory,
        TestHistory> with GetMCQTestHistoryRef {
  _GetMCQTestHistoryProviderElement(super.provider);

  @override
  String get id => (origin as GetMCQTestHistoryProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
