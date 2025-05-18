// __brick__/repository/test_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'test_repo.g.dart';

@riverpod
TestRepo testRepo(TestRepoRef ref) {
final dioService = ref.watch(dioServiceProvider);
return TestRepo(dioService);
}

class TestRepo {
final DioService _dioService;

TestRepo(this._dioService);
}