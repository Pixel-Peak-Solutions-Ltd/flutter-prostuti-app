// __brick__/repository/user_profile_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'user_profile_repo.g.dart';

@riverpod
UserProfileRepo userProfileRepo(UserProfileRepoRef ref) {
final dioService = ref.watch(dioServiceProvider);
return UserProfileRepo(dioService);
}

class UserProfileRepo {
final DioService _dioService;

UserProfileRepo(this._dioService);
}