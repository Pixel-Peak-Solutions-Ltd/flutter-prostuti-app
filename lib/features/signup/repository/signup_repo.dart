import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/view_model/auth_notifier.dart';

part 'signup_repo.g.dart';

@riverpod
SignupRepo signupRepo(SignupRepoRef ref) {
  final accessToken = ref.watch(authNotifierProvider);

  if (accessToken == null) {
    throw Exception('Access token is null. Cannot create SignupRepo.');
  }
  final dioService = ref.watch(dioServiceProvider(accessToken: accessToken));
  return SignupRepo(dioService);
}

class SignupRepo {
  final DioService _dioService;

  SignupRepo(this._dioService);
}
