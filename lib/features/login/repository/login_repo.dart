
// __brick__/repository/login_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'login_repo.g.dart';

@riverpod
LoginRepo loginRepo(LoginRepoRef ref) {
final accessToken = ref.watch(authNotifierProvider);

if (accessToken == null) {
throw Exception('Access token is null. Cannot create LoginRepo.');
}
final dioService = ref.watch(dioServiceProvider(accessToken: accessToken));
return LoginRepo(dioService);
}

class LoginRepo {
final DioService _dioService;

LoginRepo(this._dioService);
}