// __brick__/repository/profile_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'profile_repo.g.dart';

@riverpod
ProfileRepo profileRepo(ProfileRepoRef ref) {
final dioService = ref.watch(dioServiceProvider);
return ProfileRepo(dioService);
}

class ProfileRepo {
final DioService _dioService;

ProfileRepo(this._dioService);
}