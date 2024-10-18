
// __brick__/repository/forget_password_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'forget_password_repo.g.dart';

@riverpod
ForgetPasswordRepo forgetPasswordRepo(ForgetPasswordRepoRef ref) {
final accessToken = ref.watch(authNotifierProvider);

if (accessToken == null) {
throw Exception('Access token is null. Cannot create ForgetPasswordRepo.');
}
final dioService = ref.watch(dioServiceProvider(accessToken: accessToken));
return ForgetPasswordRepo(dioService);
}

class ForgetPasswordRepo {
final DioService _dioService;

ForgetPasswordRepo(this._dioService);
}