import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../enrolled_course_landing/repository/enrolled_course_landing_repo.dart';

part 'get_material_completion.g.dart';

@Riverpod(keepAlive: false)
class CompletedId extends _$CompletedId {
  @override
  Future<List> build(String courseId) async {
    return await ref
        .read(enrolledCourseLandingRepoProvider)
        .getMaterialComplete(courseId);
  }
}
