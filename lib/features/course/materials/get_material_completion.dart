import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enrolled_course_landing/repository/enrolled_course_landing_repo.dart';

final completedIdProvider =
    FutureProvider.family<List, String>((ref, courseId) async {
  return await ref
      .read(enrolledCourseLandingRepoProvider)
      .getMaterialComplete(courseId);
});
