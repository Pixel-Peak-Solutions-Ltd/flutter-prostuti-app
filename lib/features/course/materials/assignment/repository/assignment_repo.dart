// __brick__/repository/assignment_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'assignment_repo.g.dart';

@riverpod
AssignmentRepo assignmentRepo(AssignmentRepoRef ref) {
final dioService = ref.watch(dioServiceProvider);
return AssignmentRepo(dioService);
}

class AssignmentRepo {
final DioService _dioService;

AssignmentRepo(this._dioService);
}