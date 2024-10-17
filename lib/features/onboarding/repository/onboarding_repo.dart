
// __brick__/repository/onboarding_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'onboarding_repo.g.dart';

@riverpod
OnboardingRepo onboardingRepo(OnboardingRepoRef ref) {
final accessToken = ref.watch(authNotifierProvider);

if (accessToken == null) {
throw Exception('Access token is null. Cannot create OnboardingRepo.');
}
final dioService = ref.watch(dioServiceProvider(accessToken: accessToken));
return OnboardingRepo(dioService);
}

class OnboardingRepo {
final DioService _dioService;

OnboardingRepo(this._dioService);
}