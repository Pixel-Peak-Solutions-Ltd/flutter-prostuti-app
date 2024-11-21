// __brick__/repository/resources_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'resources_repo.g.dart';

@riverpod
ResourcesRepo resourcesRepo(ResourcesRepoRef ref) {
final dioService = ref.watch(dioServiceProvider);
return ResourcesRepo(dioService);
}

class ResourcesRepo {
final DioService _dioService;

ResourcesRepo(this._dioService);
}