// __brick__/repository/record_class_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'record_class_repo.g.dart';

@riverpod
RecordClassRepo recordClassRepo(RecordClassRepoRef ref) {
final dioService = ref.watch(dioServiceProvider);
return RecordClassRepo(dioService);
}

class RecordClassRepo {
final DioService _dioService;

RecordClassRepo(this._dioService);
}