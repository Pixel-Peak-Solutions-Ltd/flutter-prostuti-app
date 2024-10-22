
// __brick__/repository/home_screen_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'home_screen_repo.g.dart';

@riverpod
HomeScreenRepo homeScreenRepo(HomeScreenRepoRef ref) {
final accessToken = ref.watch(authNotifierProvider);

if (accessToken == null) {
throw Exception('Access token is null. Cannot create HomeScreenRepo.');
}
final dioService = ref.watch(dioServiceProvider(accessToken: accessToken));
return HomeScreenRepo(dioService);
}

class HomeScreenRepo {
final DioService _dioService;

HomeScreenRepo(this._dioService);
}