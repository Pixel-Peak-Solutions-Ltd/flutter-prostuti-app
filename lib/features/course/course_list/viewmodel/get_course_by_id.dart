import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_course_by_id.g.dart';

@riverpod
class GetCourseById extends _$GetCourseById {
  @override
  String build() {
    return "";
  }

  void setId(String id) {
    state = id;
  }
}
