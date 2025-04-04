// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$courseNoticesHash() => r'c8931fac1d54a5773f2c4d8c134b18cf58b74ebe';

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

abstract class _$CourseNotices
    extends BuildlessAutoDisposeAsyncNotifier<List<NoticeData>> {
  late final String courseId;

  FutureOr<List<NoticeData>> build(
    String courseId,
  );
}

/// See also [CourseNotices].
@ProviderFor(CourseNotices)
const courseNoticesProvider = CourseNoticesFamily();

/// See also [CourseNotices].
class CourseNoticesFamily extends Family<AsyncValue<List<NoticeData>>> {
  /// See also [CourseNotices].
  const CourseNoticesFamily();

  /// See also [CourseNotices].
  CourseNoticesProvider call(
    String courseId,
  ) {
    return CourseNoticesProvider(
      courseId,
    );
  }

  @override
  CourseNoticesProvider getProviderOverride(
    covariant CourseNoticesProvider provider,
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
  String? get name => r'courseNoticesProvider';
}

/// See also [CourseNotices].
class CourseNoticesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CourseNotices, List<NoticeData>> {
  /// See also [CourseNotices].
  CourseNoticesProvider(
    String courseId,
  ) : this._internal(
          () => CourseNotices()..courseId = courseId,
          from: courseNoticesProvider,
          name: r'courseNoticesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$courseNoticesHash,
          dependencies: CourseNoticesFamily._dependencies,
          allTransitiveDependencies:
              CourseNoticesFamily._allTransitiveDependencies,
          courseId: courseId,
        );

  CourseNoticesProvider._internal(
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
  FutureOr<List<NoticeData>> runNotifierBuild(
    covariant CourseNotices notifier,
  ) {
    return notifier.build(
      courseId,
    );
  }

  @override
  Override overrideWith(CourseNotices Function() create) {
    return ProviderOverride(
      origin: this,
      override: CourseNoticesProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<CourseNotices, List<NoticeData>>
      createElement() {
    return _CourseNoticesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseNoticesProvider && other.courseId == courseId;
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
mixin CourseNoticesRef
    on AutoDisposeAsyncNotifierProviderRef<List<NoticeData>> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CourseNoticesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CourseNotices,
        List<NoticeData>> with CourseNoticesRef {
  _CourseNoticesProviderElement(super.provider);

  @override
  String get courseId => (origin as CourseNoticesProvider).courseId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
