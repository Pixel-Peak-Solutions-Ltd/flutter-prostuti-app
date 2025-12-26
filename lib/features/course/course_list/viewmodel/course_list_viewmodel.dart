import 'package:prostuti/features/course/course_list/model/course_list_model.dart';
import 'package:prostuti/features/course/course_list/repository/course_list_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_list_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class PublishedCourse extends _$PublishedCourse {
  List<PublishedCourseData> _courses = [];
  List<PublishedCourseData> _filteredCourses = [];

  List<PublishedCourseData> get filteredCourses => _filteredCourses;

  @override
  Future<List<PublishedCourseData>> build() async {
    _courses = await getAllPublishedCourseList();
    _filteredCourses = _courses;
    return _courses;
  }

  Future<List<PublishedCourseData>> getAllPublishedCourseList() async {
    final response =
        await ref.read(courseListRepoProvider).getAllPublishedCourseList();

    return response.fold(
      (l) {
        throw Exception(l.message);
      },
      (courseList) {
        return courseList.data ?? [];
      },
    );
  }

  void filterCourses(String query) {
    if (query.isEmpty) {
      _filteredCourses = _courses;
    } else {
      _filteredCourses = _courses
          .where((course) =>
              course.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    // Notify listeners of the updated state
    state = AsyncValue.data(_filteredCourses);
  }

  void filterByCategory(String? categoryType, {String? division}) {
    if (categoryType == null || categoryType.isEmpty) {
      _filteredCourses = _courses;
    } else {
      _filteredCourses = _courses.where((course) {
        if (course.category == null) return false;

        // Match by category type
        bool matchesType = course.category!.type?.toLowerCase() ==
            categoryType.toLowerCase();

        // If division is specified, also match by division
        if (division != null && division.isNotEmpty && matchesType) {
          return course.category!.division?.toLowerCase() ==
              division.toLowerCase();
        }

        return matchesType;
      }).toList();
    }
    // Notify listeners of the updated state
    state = AsyncValue.data(_filteredCourses);
  }

  void filterByQuery(String query, {String? categoryType}) {
    List<PublishedCourseData> baseList = _courses;

    // First filter by category if provided
    if (categoryType != null && categoryType.isNotEmpty) {
      baseList = _courses.where((course) {
        if (course.category == null) return false;
        return course.category!.type?.toLowerCase() ==
            categoryType.toLowerCase();
      }).toList();
    }

    // Then filter by query
    if (query.isEmpty) {
      _filteredCourses = baseList;
    } else {
      _filteredCourses = baseList
          .where((course) =>
              course.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    state = AsyncValue.data(_filteredCourses);
  }
}
