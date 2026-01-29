// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_test_history_of_course.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$testHistoryViewModelOfCourseHash() =>
    r'0fd007ffc68a3f64541b669722afc13e22887796';

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

abstract class _$TestHistoryViewModelOfCourse
    extends BuildlessAutoDisposeAsyncNotifier<List<Data>> {
  late final String studentId;
  late final String courseId;

  FutureOr<List<Data>> build({
    required String studentId,
    required String courseId,
  });
}

/// See also [TestHistoryViewModelOfCourse].
@ProviderFor(TestHistoryViewModelOfCourse)
const testHistoryViewModelOfCourseProvider =
    TestHistoryViewModelOfCourseFamily();

/// See also [TestHistoryViewModelOfCourse].
class TestHistoryViewModelOfCourseFamily
    extends Family<AsyncValue<List<Data>>> {
  /// See also [TestHistoryViewModelOfCourse].
  const TestHistoryViewModelOfCourseFamily();

  /// See also [TestHistoryViewModelOfCourse].
  TestHistoryViewModelOfCourseProvider call({
    required String studentId,
    required String courseId,
  }) {
    return TestHistoryViewModelOfCourseProvider(
      studentId: studentId,
      courseId: courseId,
    );
  }

  @override
  TestHistoryViewModelOfCourseProvider getProviderOverride(
    covariant TestHistoryViewModelOfCourseProvider provider,
  ) {
    return call(
      studentId: provider.studentId,
      courseId: provider.courseId,
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
  String? get name => r'testHistoryViewModelOfCourseProvider';
}

/// See also [TestHistoryViewModelOfCourse].
class TestHistoryViewModelOfCourseProvider
    extends AutoDisposeAsyncNotifierProviderImpl<TestHistoryViewModelOfCourse,
        List<Data>> {
  /// See also [TestHistoryViewModelOfCourse].
  TestHistoryViewModelOfCourseProvider({
    required String studentId,
    required String courseId,
  }) : this._internal(
          () => TestHistoryViewModelOfCourse()
            ..studentId = studentId
            ..courseId = courseId,
          from: testHistoryViewModelOfCourseProvider,
          name: r'testHistoryViewModelOfCourseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$testHistoryViewModelOfCourseHash,
          dependencies: TestHistoryViewModelOfCourseFamily._dependencies,
          allTransitiveDependencies:
              TestHistoryViewModelOfCourseFamily._allTransitiveDependencies,
          studentId: studentId,
          courseId: courseId,
        );

  TestHistoryViewModelOfCourseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.studentId,
    required this.courseId,
  }) : super.internal();

  final String studentId;
  final String courseId;

  @override
  FutureOr<List<Data>> runNotifierBuild(
    covariant TestHistoryViewModelOfCourse notifier,
  ) {
    return notifier.build(
      studentId: studentId,
      courseId: courseId,
    );
  }

  @override
  Override overrideWith(TestHistoryViewModelOfCourse Function() create) {
    return ProviderOverride(
      origin: this,
      override: TestHistoryViewModelOfCourseProvider._internal(
        () => create()
          ..studentId = studentId
          ..courseId = courseId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        studentId: studentId,
        courseId: courseId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TestHistoryViewModelOfCourse,
      List<Data>> createElement() {
    return _TestHistoryViewModelOfCourseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TestHistoryViewModelOfCourseProvider &&
        other.studentId == studentId &&
        other.courseId == courseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, studentId.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TestHistoryViewModelOfCourseRef
    on AutoDisposeAsyncNotifierProviderRef<List<Data>> {
  /// The parameter `studentId` of this provider.
  String get studentId;

  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _TestHistoryViewModelOfCourseProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        TestHistoryViewModelOfCourse,
        List<Data>> with TestHistoryViewModelOfCourseRef {
  _TestHistoryViewModelOfCourseProviderElement(super.provider);

  @override
  String get studentId =>
      (origin as TestHistoryViewModelOfCourseProvider).studentId;
  @override
  String get courseId =>
      (origin as TestHistoryViewModelOfCourseProvider).courseId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
