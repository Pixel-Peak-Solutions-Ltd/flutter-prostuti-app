// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_review_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$courseReviewViewModelHash() =>
    r'b66757242f460226679d2636993dc2e89bd24a83';

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

abstract class _$CourseReviewViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<CourseReview>> {
  late final String courseId;

  FutureOr<List<CourseReview>> build(
    String courseId,
  );
}

/// See also [CourseReviewViewModel].
@ProviderFor(CourseReviewViewModel)
const courseReviewViewModelProvider = CourseReviewViewModelFamily();

/// See also [CourseReviewViewModel].
class CourseReviewViewModelFamily
    extends Family<AsyncValue<List<CourseReview>>> {
  /// See also [CourseReviewViewModel].
  const CourseReviewViewModelFamily();

  /// See also [CourseReviewViewModel].
  CourseReviewViewModelProvider call(
    String courseId,
  ) {
    return CourseReviewViewModelProvider(
      courseId,
    );
  }

  @override
  CourseReviewViewModelProvider getProviderOverride(
    covariant CourseReviewViewModelProvider provider,
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
  String? get name => r'courseReviewViewModelProvider';
}

/// See also [CourseReviewViewModel].
class CourseReviewViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<CourseReviewViewModel,
        List<CourseReview>> {
  /// See also [CourseReviewViewModel].
  CourseReviewViewModelProvider(
    String courseId,
  ) : this._internal(
          () => CourseReviewViewModel()..courseId = courseId,
          from: courseReviewViewModelProvider,
          name: r'courseReviewViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$courseReviewViewModelHash,
          dependencies: CourseReviewViewModelFamily._dependencies,
          allTransitiveDependencies:
              CourseReviewViewModelFamily._allTransitiveDependencies,
          courseId: courseId,
        );

  CourseReviewViewModelProvider._internal(
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
  FutureOr<List<CourseReview>> runNotifierBuild(
    covariant CourseReviewViewModel notifier,
  ) {
    return notifier.build(
      courseId,
    );
  }

  @override
  Override overrideWith(CourseReviewViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: CourseReviewViewModelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<CourseReviewViewModel,
      List<CourseReview>> createElement() {
    return _CourseReviewViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseReviewViewModelProvider && other.courseId == courseId;
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
mixin CourseReviewViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<List<CourseReview>> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CourseReviewViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CourseReviewViewModel,
        List<CourseReview>> with CourseReviewViewModelRef {
  _CourseReviewViewModelProviderElement(super.provider);

  @override
  String get courseId => (origin as CourseReviewViewModelProvider).courseId;
}

String _$reviewStatsHash() => r'f9de7b764b888bfabc0723c39c6dc87b86ac283c';

abstract class _$ReviewStats
    extends BuildlessAutoDisposeNotifier<Map<String, dynamic>> {
  late final List<CourseReview> reviews;

  Map<String, dynamic> build(
    List<CourseReview> reviews,
  );
}

/// See also [ReviewStats].
@ProviderFor(ReviewStats)
const reviewStatsProvider = ReviewStatsFamily();

/// See also [ReviewStats].
class ReviewStatsFamily extends Family<Map<String, dynamic>> {
  /// See also [ReviewStats].
  const ReviewStatsFamily();

  /// See also [ReviewStats].
  ReviewStatsProvider call(
    List<CourseReview> reviews,
  ) {
    return ReviewStatsProvider(
      reviews,
    );
  }

  @override
  ReviewStatsProvider getProviderOverride(
    covariant ReviewStatsProvider provider,
  ) {
    return call(
      provider.reviews,
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
  String? get name => r'reviewStatsProvider';
}

/// See also [ReviewStats].
class ReviewStatsProvider
    extends AutoDisposeNotifierProviderImpl<ReviewStats, Map<String, dynamic>> {
  /// See also [ReviewStats].
  ReviewStatsProvider(
    List<CourseReview> reviews,
  ) : this._internal(
          () => ReviewStats()..reviews = reviews,
          from: reviewStatsProvider,
          name: r'reviewStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reviewStatsHash,
          dependencies: ReviewStatsFamily._dependencies,
          allTransitiveDependencies:
              ReviewStatsFamily._allTransitiveDependencies,
          reviews: reviews,
        );

  ReviewStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.reviews,
  }) : super.internal();

  final List<CourseReview> reviews;

  @override
  Map<String, dynamic> runNotifierBuild(
    covariant ReviewStats notifier,
  ) {
    return notifier.build(
      reviews,
    );
  }

  @override
  Override overrideWith(ReviewStats Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReviewStatsProvider._internal(
        () => create()..reviews = reviews,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        reviews: reviews,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ReviewStats, Map<String, dynamic>>
      createElement() {
    return _ReviewStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewStatsProvider && other.reviews == reviews;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, reviews.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReviewStatsRef on AutoDisposeNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `reviews` of this provider.
  List<CourseReview> get reviews;
}

class _ReviewStatsProviderElement extends AutoDisposeNotifierProviderElement<
    ReviewStats, Map<String, dynamic>> with ReviewStatsRef {
  _ReviewStatsProviderElement(super.provider);

  @override
  List<CourseReview> get reviews => (origin as ReviewStatsProvider).reviews;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
