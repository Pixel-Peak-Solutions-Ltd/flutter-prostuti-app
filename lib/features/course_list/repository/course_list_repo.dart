// __brick__/repository/course_list_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'course_list_repo.g.dart';

@riverpod
CourseListRepo courseListRepo(CourseListRepoRef ref) {
final dioService = ref.watch(dioServiceProvider);
return CourseListRepo(dioService);
}

class CourseListRepo {
final DioService _dioService;

CourseListRepo(this._dioService);
}