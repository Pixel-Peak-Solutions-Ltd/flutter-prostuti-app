// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_details_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$flashcardDetailNotifierHash() =>
    r'cc52072387e611007b145bff0b17e3751a9cbcf8';

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

abstract class _$FlashcardDetailNotifier
    extends BuildlessAsyncNotifier<FlashcardDetail> {
  late final String flashcardId;

  FutureOr<FlashcardDetail> build(
    String flashcardId,
  );
}

/// See also [FlashcardDetailNotifier].
@ProviderFor(FlashcardDetailNotifier)
const flashcardDetailNotifierProvider = FlashcardDetailNotifierFamily();

/// See also [FlashcardDetailNotifier].
class FlashcardDetailNotifierFamily
    extends Family<AsyncValue<FlashcardDetail>> {
  /// See also [FlashcardDetailNotifier].
  const FlashcardDetailNotifierFamily();

  /// See also [FlashcardDetailNotifier].
  FlashcardDetailNotifierProvider call(
    String flashcardId,
  ) {
    return FlashcardDetailNotifierProvider(
      flashcardId,
    );
  }

  @override
  FlashcardDetailNotifierProvider getProviderOverride(
    covariant FlashcardDetailNotifierProvider provider,
  ) {
    return call(
      provider.flashcardId,
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
  String? get name => r'flashcardDetailNotifierProvider';
}

/// See also [FlashcardDetailNotifier].
class FlashcardDetailNotifierProvider extends AsyncNotifierProviderImpl<
    FlashcardDetailNotifier, FlashcardDetail> {
  /// See also [FlashcardDetailNotifier].
  FlashcardDetailNotifierProvider(
    String flashcardId,
  ) : this._internal(
          () => FlashcardDetailNotifier()..flashcardId = flashcardId,
          from: flashcardDetailNotifierProvider,
          name: r'flashcardDetailNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$flashcardDetailNotifierHash,
          dependencies: FlashcardDetailNotifierFamily._dependencies,
          allTransitiveDependencies:
              FlashcardDetailNotifierFamily._allTransitiveDependencies,
          flashcardId: flashcardId,
        );

  FlashcardDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.flashcardId,
  }) : super.internal();

  final String flashcardId;

  @override
  FutureOr<FlashcardDetail> runNotifierBuild(
    covariant FlashcardDetailNotifier notifier,
  ) {
    return notifier.build(
      flashcardId,
    );
  }

  @override
  Override overrideWith(FlashcardDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: FlashcardDetailNotifierProvider._internal(
        () => create()..flashcardId = flashcardId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        flashcardId: flashcardId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<FlashcardDetailNotifier, FlashcardDetail>
      createElement() {
    return _FlashcardDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FlashcardDetailNotifierProvider &&
        other.flashcardId == flashcardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, flashcardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FlashcardDetailNotifierRef on AsyncNotifierProviderRef<FlashcardDetail> {
  /// The parameter `flashcardId` of this provider.
  String get flashcardId;
}

class _FlashcardDetailNotifierProviderElement
    extends AsyncNotifierProviderElement<FlashcardDetailNotifier,
        FlashcardDetail> with FlashcardDetailNotifierRef {
  _FlashcardDetailNotifierProviderElement(super.provider);

  @override
  String get flashcardId =>
      (origin as FlashcardDetailNotifierProvider).flashcardId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
