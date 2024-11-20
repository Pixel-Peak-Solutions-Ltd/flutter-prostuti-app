// __brick__/repository/course_details_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'course_details_repo.g.dart';

@riverpod
CourseDetailsRepo courseDetailsRepo(CourseDetailsRepoRef ref) {
final dioService = ref.watch(dioServiceProvider);
return CourseDetailsRepo(dioService);
}

class CourseDetailsRepo {
final DioService _dioService;

CourseDetailsRepo(this._dioService);
}