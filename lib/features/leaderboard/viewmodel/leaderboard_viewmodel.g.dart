// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$globalLeaderboardHash() => r'a91c28946a69ebe69101331a30e5aeb363131446';

/// See also [GlobalLeaderboard].
@ProviderFor(GlobalLeaderboard)
final globalLeaderboardProvider = AutoDisposeAsyncNotifierProvider<
    GlobalLeaderboard, List<LeaderboardData>>.internal(
  GlobalLeaderboard.new,
  name: r'globalLeaderboardProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalLeaderboardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GlobalLeaderboard = AutoDisposeAsyncNotifier<List<LeaderboardData>>;
String _$courseLeaderboardHash() => r'5436e0c13da11822b093bb57a7928e2f060eaca1';

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

abstract class _$CourseLeaderboard
    extends BuildlessAutoDisposeAsyncNotifier<List<LeaderboardData>> {
  late final String courseId;

  FutureOr<List<LeaderboardData>> build(
    String courseId,
  );
}

/// See also [CourseLeaderboard].
@ProviderFor(CourseLeaderboard)
const courseLeaderboardProvider = CourseLeaderboardFamily();

/// See also [CourseLeaderboard].
class CourseLeaderboardFamily
    extends Family<AsyncValue<List<LeaderboardData>>> {
  /// See also [CourseLeaderboard].
  const CourseLeaderboardFamily();

  /// See also [CourseLeaderboard].
  CourseLeaderboardProvider call(
    String courseId,
  ) {
    return CourseLeaderboardProvider(
      courseId,
    );
  }

  @override
  CourseLeaderboardProvider getProviderOverride(
    covariant CourseLeaderboardProvider provider,
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
  String? get name => r'courseLeaderboardProvider';
}

/// See also [CourseLeaderboard].
class CourseLeaderboardProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CourseLeaderboard, List<LeaderboardData>> {
  /// See also [CourseLeaderboard].
  CourseLeaderboardProvider(
    String courseId,
  ) : this._internal(
          () => CourseLeaderboard()..courseId = courseId,
          from: courseLeaderboardProvider,
          name: r'courseLeaderboardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$courseLeaderboardHash,
          dependencies: CourseLeaderboardFamily._dependencies,
          allTransitiveDependencies:
              CourseLeaderboardFamily._allTransitiveDependencies,
          courseId: courseId,
        );

  CourseLeaderboardProvider._internal(
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
  FutureOr<List<LeaderboardData>> runNotifierBuild(
    covariant CourseLeaderboard notifier,
  ) {
    return notifier.build(
      courseId,
    );
  }

  @override
  Override overrideWith(CourseLeaderboard Function() create) {
    return ProviderOverride(
      origin: this,
      override: CourseLeaderboardProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<CourseLeaderboard,
      List<LeaderboardData>> createElement() {
    return _CourseLeaderboardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseLeaderboardProvider && other.courseId == courseId;
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
mixin CourseLeaderboardRef
    on AutoDisposeAsyncNotifierProviderRef<List<LeaderboardData>> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CourseLeaderboardProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CourseLeaderboard,
        List<LeaderboardData>> with CourseLeaderboardRef {
  _CourseLeaderboardProviderElement(super.provider);

  @override
  String get courseId => (origin as CourseLeaderboardProvider).courseId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
