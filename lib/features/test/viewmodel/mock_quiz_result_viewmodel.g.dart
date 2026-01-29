// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_quiz_result_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mockQuizResultViewmodelHash() =>
    r'05744bbaa7900e474cd593253a976706dc3d648f';

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

abstract class _$MockQuizResultViewmodel
    extends BuildlessAutoDisposeAsyncNotifier<MCQQuizResultModel?> {
  late final String quizId;

  FutureOr<MCQQuizResultModel?> build(
    String quizId,
  );
}

/// See also [MockQuizResultViewmodel].
@ProviderFor(MockQuizResultViewmodel)
const mockQuizResultViewmodelProvider = MockQuizResultViewmodelFamily();

/// See also [MockQuizResultViewmodel].
class MockQuizResultViewmodelFamily
    extends Family<AsyncValue<MCQQuizResultModel?>> {
  /// See also [MockQuizResultViewmodel].
  const MockQuizResultViewmodelFamily();

  /// See also [MockQuizResultViewmodel].
  MockQuizResultViewmodelProvider call(
    String quizId,
  ) {
    return MockQuizResultViewmodelProvider(
      quizId,
    );
  }

  @override
  MockQuizResultViewmodelProvider getProviderOverride(
    covariant MockQuizResultViewmodelProvider provider,
  ) {
    return call(
      provider.quizId,
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
  String? get name => r'mockQuizResultViewmodelProvider';
}

/// See also [MockQuizResultViewmodel].
class MockQuizResultViewmodelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MockQuizResultViewmodel,
        MCQQuizResultModel?> {
  /// See also [MockQuizResultViewmodel].
  MockQuizResultViewmodelProvider(
    String quizId,
  ) : this._internal(
          () => MockQuizResultViewmodel()..quizId = quizId,
          from: mockQuizResultViewmodelProvider,
          name: r'mockQuizResultViewmodelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mockQuizResultViewmodelHash,
          dependencies: MockQuizResultViewmodelFamily._dependencies,
          allTransitiveDependencies:
              MockQuizResultViewmodelFamily._allTransitiveDependencies,
          quizId: quizId,
        );

  MockQuizResultViewmodelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.quizId,
  }) : super.internal();

  final String quizId;

  @override
  FutureOr<MCQQuizResultModel?> runNotifierBuild(
    covariant MockQuizResultViewmodel notifier,
  ) {
    return notifier.build(
      quizId,
    );
  }

  @override
  Override overrideWith(MockQuizResultViewmodel Function() create) {
    return ProviderOverride(
      origin: this,
      override: MockQuizResultViewmodelProvider._internal(
        () => create()..quizId = quizId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        quizId: quizId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MockQuizResultViewmodel,
      MCQQuizResultModel?> createElement() {
    return _MockQuizResultViewmodelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MockQuizResultViewmodelProvider && other.quizId == quizId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quizId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MockQuizResultViewmodelRef
    on AutoDisposeAsyncNotifierProviderRef<MCQQuizResultModel?> {
  /// The parameter `quizId` of this provider.
  String get quizId;
}

class _MockQuizResultViewmodelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MockQuizResultViewmodel,
        MCQQuizResultModel?> with MockQuizResultViewmodelRef {
  _MockQuizResultViewmodelProviderElement(super.provider);

  @override
  String get quizId => (origin as MockQuizResultViewmodelProvider).quizId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
