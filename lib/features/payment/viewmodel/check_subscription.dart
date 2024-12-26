import 'package:prostuti/common/helpers/functions.dart';
import 'package:prostuti/features/payment/repository/payment_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_subscription.g.dart';

@riverpod
class UserSubscribed extends _$UserSubscribed {
  @override
  Future<bool> build() async {
    return await _isUserSubscribed();
  }

  Future<bool> _isUserSubscribed() async {
    final response = await ref.read(paymentRepoProvider).getStudentProfile();

    return response.fold(
      (l) => throw Exception(l.message), // Handle error case
      (r) {
        if (r.data!.subscriptionStartDate == null ||
            r.data!.subscriptionEndDate == null) {
          return false;
        }
        return HelperFunc.isUserSubscribed(
          r.data!.subscriptionStartDate!,
          r.data!.subscriptionEndDate!,
        );
      },
    );
  }
}
