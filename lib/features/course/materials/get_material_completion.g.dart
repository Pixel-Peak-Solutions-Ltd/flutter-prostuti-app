// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_material_completion.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$completedIdHash() => r'0456bf666494d4dd80c2d4f8bd6503d375d190a7';

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

abstract class _$CompletedId extends BuildlessAutoDisposeAsyncNotifier<List> {
  late final String courseId;

  FutureOr<List> build(
    String courseId,
  );
}

/// See also [CompletedId].
@ProviderFor(CompletedId)
const completedIdProvider = CompletedIdFamily();

/// See also [CompletedId].
class CompletedIdFamily extends Family<AsyncValue<List>> {
  /// See also [CompletedId].
  const CompletedIdFamily();

  /// See also [CompletedId].
  CompletedIdProvider call(
    String courseId,
  ) {
    return CompletedIdProvider(
      courseId,
    );
  }

  @override
  CompletedIdProvider getProviderOverride(
    covariant CompletedIdProvider provider,
  ) {
    return call(
      provider.courseId,
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
  String? get name => r'completedIdProvider';
}

/// See also [CompletedId].
class CompletedIdProvider
    extends AutoDisposeAsyncNotifierProviderImpl<CompletedId, List> {
  /// See also [CompletedId].
  CompletedIdProvider(
    String courseId,
  ) : this._internal(
          () => CompletedId()..courseId = courseId,
          from: completedIdProvider,
          name: r'completedIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$completedIdHash,
          dependencies: CompletedIdFamily._dependencies,
          allTransitiveDependencies:
              CompletedIdFamily._allTransitiveDependencies,
          courseId: courseId,
        );

  CompletedIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
  }) : super.internal();

  final String courseId;

  @override
  FutureOr<List> runNotifierBuild(
    covariant CompletedId notifier,
  ) {
    return notifier.build(
      courseId,
    );
  }

  @override
  Override overrideWith(CompletedId Function() create) {
    return ProviderOverride(
      origin: this,
      override: CompletedIdProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<CompletedId, List> createElement() {
    return _CompletedIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompletedIdProvider && other.courseId == courseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CompletedIdRef on AutoDisposeAsyncNotifierProviderRef<List> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CompletedIdProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CompletedId, List>
    with CompletedIdRef {
  _CompletedIdProviderElement(super.provider);

  @override
  String get courseId => (origin as CompletedIdProvider).courseId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
