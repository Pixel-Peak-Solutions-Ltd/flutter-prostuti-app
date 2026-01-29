// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_written_quiz_result_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mockWrittenQuizResultViewmodelHash() =>
    r'5b4f8c150a893e70907747e857326a6688191a59';

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

abstract class _$MockWrittenQuizResultViewmodel
    extends BuildlessAutoDisposeAsyncNotifier<WrittenQuizResultModel?> {
  late final String quizId;

  FutureOr<WrittenQuizResultModel?> build(
    String quizId,
  );
}

/// See also [MockWrittenQuizResultViewmodel].
@ProviderFor(MockWrittenQuizResultViewmodel)
const mockWrittenQuizResultViewmodelProvider =
    MockWrittenQuizResultViewmodelFamily();

/// See also [MockWrittenQuizResultViewmodel].
class MockWrittenQuizResultViewmodelFamily
    extends Family<AsyncValue<WrittenQuizResultModel?>> {
  /// See also [MockWrittenQuizResultViewmodel].
  const MockWrittenQuizResultViewmodelFamily();

  /// See also [MockWrittenQuizResultViewmodel].
  MockWrittenQuizResultViewmodelProvider call(
    String quizId,
  ) {
    return MockWrittenQuizResultViewmodelProvider(
      quizId,
    );
  }

  @override
  MockWrittenQuizResultViewmodelProvider getProviderOverride(
    covariant MockWrittenQuizResultViewmodelProvider provider,
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
  String? get name => r'mockWrittenQuizResultViewmodelProvider';
}

/// See also [MockWrittenQuizResultViewmodel].
class MockWrittenQuizResultViewmodelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MockWrittenQuizResultViewmodel,
        WrittenQuizResultModel?> {
  /// See also [MockWrittenQuizResultViewmodel].
  MockWrittenQuizResultViewmodelProvider(
    String quizId,
  ) : this._internal(
          () => MockWrittenQuizResultViewmodel()..quizId = quizId,
          from: mockWrittenQuizResultViewmodelProvider,
          name: r'mockWrittenQuizResultViewmodelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mockWrittenQuizResultViewmodelHash,
          dependencies: MockWrittenQuizResultViewmodelFamily._dependencies,
          allTransitiveDependencies:
              MockWrittenQuizResultViewmodelFamily._allTransitiveDependencies,
          quizId: quizId,
        );

  MockWrittenQuizResultViewmodelProvider._internal(
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
  FutureOr<WrittenQuizResultModel?> runNotifierBuild(
    covariant MockWrittenQuizResultViewmodel notifier,
  ) {
    return notifier.build(
      quizId,
    );
  }

  @override
  Override overrideWith(MockWrittenQuizResultViewmodel Function() create) {
    return ProviderOverride(
      origin: this,
      override: MockWrittenQuizResultViewmodelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<MockWrittenQuizResultViewmodel,
      WrittenQuizResultModel?> createElement() {
    return _MockWrittenQuizResultViewmodelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MockWrittenQuizResultViewmodelProvider &&
        other.quizId == quizId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quizId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MockWrittenQuizResultViewmodelRef
    on AutoDisposeAsyncNotifierProviderRef<WrittenQuizResultModel?> {
  /// The parameter `quizId` of this provider.
  String get quizId;
}

class _MockWrittenQuizResultViewmodelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        MockWrittenQuizResultViewmodel,
        WrittenQuizResultModel?> with MockWrittenQuizResultViewmodelRef {
  _MockWrittenQuizResultViewmodelProviderElement(super.provider);

  @override
  String get quizId =>
      (origin as MockWrittenQuizResultViewmodelProvider).quizId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
