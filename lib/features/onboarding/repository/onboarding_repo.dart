// __brick__/repository/onboarding_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_repo.g.dart';

@riverpod
OnboardingRepo onboardingRepo(OnboardingRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return OnboardingRepo(dioService);
}

class OnboardingRepo {
  final DioService _dioService;

  OnboardingRepo(this._dioService);
}
