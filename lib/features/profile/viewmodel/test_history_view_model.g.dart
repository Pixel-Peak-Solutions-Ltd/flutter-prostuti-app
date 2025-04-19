// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_history_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$testHistoryViewModelHash() =>
    r'ce499ced24eaf5c4050d765b7b1dc070541ed42e';

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

abstract class _$TestHistoryViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<Data>> {
  late final String studentId;

  FutureOr<List<Data>> build({
    required String studentId,
  });
}

/// See also [TestHistoryViewModel].
@ProviderFor(TestHistoryViewModel)
const testHistoryViewModelProvider = TestHistoryViewModelFamily();

/// See also [TestHistoryViewModel].
class TestHistoryViewModelFamily extends Family<AsyncValue<List<Data>>> {
  /// See also [TestHistoryViewModel].
  const TestHistoryViewModelFamily();

  /// See also [TestHistoryViewModel].
  TestHistoryViewModelProvider call({
    required String studentId,
  }) {
    return TestHistoryViewModelProvider(
      studentId: studentId,
    );
  }

  @override
  TestHistoryViewModelProvider getProviderOverride(
    covariant TestHistoryViewModelProvider provider,
  ) {
    return call(
      studentId: provider.studentId,
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
  String? get name => r'testHistoryViewModelProvider';
}

/// See also [TestHistoryViewModel].
class TestHistoryViewModelProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TestHistoryViewModel, List<Data>> {
  /// See also [TestHistoryViewModel].
  TestHistoryViewModelProvider({
    required String studentId,
  }) : this._internal(
          () => TestHistoryViewModel()..studentId = studentId,
          from: testHistoryViewModelProvider,
          name: r'testHistoryViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$testHistoryViewModelHash,
          dependencies: TestHistoryViewModelFamily._dependencies,
          allTransitiveDependencies:
              TestHistoryViewModelFamily._allTransitiveDependencies,
          studentId: studentId,
        );

  TestHistoryViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.studentId,
  }) : super.internal();

  final String studentId;

  @override
  FutureOr<List<Data>> runNotifierBuild(
    covariant TestHistoryViewModel notifier,
  ) {
    return notifier.build(
      studentId: studentId,
    );
  }

  @override
  Override overrideWith(TestHistoryViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: TestHistoryViewModelProvider._internal(
        () => create()..studentId = studentId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        studentId: studentId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TestHistoryViewModel, List<Data>>
      createElement() {
    return _TestHistoryViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TestHistoryViewModelProvider &&
        other.studentId == studentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, studentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TestHistoryViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<List<Data>> {
  /// The parameter `studentId` of this provider.
  String get studentId;
}

class _TestHistoryViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TestHistoryViewModel,
        List<Data>> with TestHistoryViewModelRef {
  _TestHistoryViewModelProviderElement(super.provider);

  @override
  String get studentId => (origin as TestHistoryViewModelProvider).studentId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
