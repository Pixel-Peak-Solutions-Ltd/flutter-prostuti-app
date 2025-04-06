// __brick__/repository/routine_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routine_repo.g.dart';

@riverpod
RoutineRepo routineRepo(RoutineRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return RoutineRepo(dioService);
}

class RoutineRepo {
  final DioService _dioService;

  RoutineRepo(this._dioService);
}
