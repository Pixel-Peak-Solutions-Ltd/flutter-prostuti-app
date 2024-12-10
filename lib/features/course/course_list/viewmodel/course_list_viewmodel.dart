import 'dart:developer';

import 'package:prostuti/features/course/course_list/model/course_list_model.dart';
import 'package:prostuti/features/course/course_list/repository/course_list_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_list_viewmodel.g.dart';

@Riverpod(keepAlive: true)
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
}
