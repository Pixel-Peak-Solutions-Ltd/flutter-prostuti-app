// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_selector_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subjectViewmodelHash() => r'3db6f47f43fda53307f864f8dcbe2b107342adb2';

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

abstract class _$SubjectViewmodel
    extends BuildlessAutoDisposeAsyncNotifier<List<String>> {
  late final String selectedStandard;

  FutureOr<List<String>> build(
    String selectedStandard,
  );
}

/// See also [SubjectViewmodel].
@ProviderFor(SubjectViewmodel)
const subjectViewmodelProvider = SubjectViewmodelFamily();

/// See also [SubjectViewmodel].
class SubjectViewmodelFamily extends Family<AsyncValue<List<String>>> {
  /// See also [SubjectViewmodel].
  const SubjectViewmodelFamily();

  /// See also [SubjectViewmodel].
  SubjectViewmodelProvider call(
    String selectedStandard,
  ) {
    return SubjectViewmodelProvider(
      selectedStandard,
    );
  }

  @override
  SubjectViewmodelProvider getProviderOverride(
    covariant SubjectViewmodelProvider provider,
  ) {
    return call(
      provider.selectedStandard,
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
  String? get name => r'subjectViewmodelProvider';
}

/// See also [SubjectViewmodel].
class SubjectViewmodelProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SubjectViewmodel, List<String>> {
  /// See also [SubjectViewmodel].
  SubjectViewmodelProvider(
    String selectedStandard,
  ) : this._internal(
          () => SubjectViewmodel()..selectedStandard = selectedStandard,
          from: subjectViewmodelProvider,
          name: r'subjectViewmodelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$subjectViewmodelHash,
          dependencies: SubjectViewmodelFamily._dependencies,
          allTransitiveDependencies:
              SubjectViewmodelFamily._allTransitiveDependencies,
          selectedStandard: selectedStandard,
        );

  SubjectViewmodelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.selectedStandard,
  }) : super.internal();

  final String selectedStandard;

  @override
  FutureOr<List<String>> runNotifierBuild(
    covariant SubjectViewmodel notifier,
  ) {
    return notifier.build(
      selectedStandard,
    );
  }

  @override
  Override overrideWith(SubjectViewmodel Function() create) {
    return ProviderOverride(
      origin: this,
      override: SubjectViewmodelProvider._internal(
        () => create()..selectedStandard = selectedStandard,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        selectedStandard: selectedStandard,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SubjectViewmodel, List<String>>
      createElement() {
    return _SubjectViewmodelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubjectViewmodelProvider &&
        other.selectedStandard == selectedStandard;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, selectedStandard.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SubjectViewmodelRef on AutoDisposeAsyncNotifierProviderRef<List<String>> {
  /// The parameter `selectedStandard` of this provider.
  String get selectedStandard;
}

class _SubjectViewmodelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SubjectViewmodel,
        List<String>> with SubjectViewmodelRef {
  _SubjectViewmodelProviderElement(super.provider);

  @override
  String get selectedStandard =>
      (origin as SubjectViewmodelProvider).selectedStandard;
}

String _$chapterViewmodelHash() => r'8310ec604085c849bca45dea9ef76cdb70d66115';

abstract class _$ChapterViewmodel
    extends BuildlessAutoDisposeAsyncNotifier<List<String>> {
  late final String subject;

  FutureOr<List<String>> build(
    String subject,
  );
}

/// See also [ChapterViewmodel].
@ProviderFor(ChapterViewmodel)
const chapterViewmodelProvider = ChapterViewmodelFamily();

/// See also [ChapterViewmodel].
class ChapterViewmodelFamily extends Family<AsyncValue<List<String>>> {
  /// See also [ChapterViewmodel].
  const ChapterViewmodelFamily();

  /// See also [ChapterViewmodel].
  ChapterViewmodelProvider call(
    String subject,
  ) {
    return ChapterViewmodelProvider(
      subject,
    );
  }

  @override
  ChapterViewmodelProvider getProviderOverride(
    covariant ChapterViewmodelProvider provider,
  ) {
    return call(
      provider.subject,
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
  String? get name => r'chapterViewmodelProvider';
}

/// See also [ChapterViewmodel].
class ChapterViewmodelProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ChapterViewmodel, List<String>> {
  /// See also [ChapterViewmodel].
  ChapterViewmodelProvider(
    String subject,
  ) : this._internal(
          () => ChapterViewmodel()..subject = subject,
          from: chapterViewmodelProvider,
          name: r'chapterViewmodelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterViewmodelHash,
          dependencies: ChapterViewmodelFamily._dependencies,
          allTransitiveDependencies:
              ChapterViewmodelFamily._allTransitiveDependencies,
          subject: subject,
        );

  ChapterViewmodelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subject,
  }) : super.internal();

  final String subject;

  @override
  FutureOr<List<String>> runNotifierBuild(
    covariant ChapterViewmodel notifier,
  ) {
    return notifier.build(
      subject,
    );
  }

  @override
  Override overrideWith(ChapterViewmodel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChapterViewmodelProvider._internal(
        () => create()..subject = subject,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subject: subject,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChapterViewmodel, List<String>>
      createElement() {
    return _ChapterViewmodelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterViewmodelProvider && other.subject == subject;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subject.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChapterViewmodelRef on AutoDisposeAsyncNotifierProviderRef<List<String>> {
  /// The parameter `subject` of this provider.
  String get subject;
}

class _ChapterViewmodelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChapterViewmodel,
        List<String>> with ChapterViewmodelRef {
  _ChapterViewmodelProviderElement(super.provider);

  @override
  String get subject => (origin as ChapterViewmodelProvider).subject;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
