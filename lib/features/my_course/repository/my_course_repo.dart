// __brick__/repository/my_course_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'my_course_repo.g.dart';

@riverpod
MyCourseRepo myCourseRepo(MyCourseRepoRef ref) {
final dioService = ref.watch(dioServiceProvider);
return MyCourseRepo(dioService);
}

class MyCourseRepo {
final DioService _dioService;

MyCourseRepo(this._dioService);
}