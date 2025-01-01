import 'package:prostuti/features/course/my_course/repository/my_course_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/course_progress_model.dart';

part 'course_progress.g.dart';

@Riverpod(keepAlive: false)
class CourseProgressNotifier extends _$CourseProgressNotifier {
  @override
  Future<List<CourseProgress>> build() async {
    return getCourseProgress();
  }

  Future<List<CourseProgress>> getCourseProgress() async {
    final response = await ref.read(myCourseRepoProvider).courseProgress();
    return response;
  }
}
