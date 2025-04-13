// lib/features/payment/viewmodel/voucher_viewmodel.dart
import 'package:prostuti/features/payment/repository/payment_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/voucher_model.dart';

part 'voucher_viewmodel.g.dart';

@riverpod
class VoucherNotifier extends _$VoucherNotifier {
  @override
  AsyncValue<VoucherModel?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> validateVoucher(String code,
      {String? courseId, required double originalPrice}) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(paymentRepoProvider)
        .validateVoucher(code, courseId: courseId);

    state = await result.fold(
      (error) => AsyncValue.error(error.message, StackTrace.current),
      (response) {
        if (response.success && response.data != null) {
          // Check if voucher is valid for this context
          if (!response.data!.isActive || response.data!.isExpired) {
            return AsyncValue.error("This voucher is not active or has expired",
                StackTrace.current);
          }

          // Verify voucher is applicable (e.g., for specific course or student)
          if (response.data!.voucherType == 'Specific_Course' &&
              response.data!.courseId != courseId) {
            return AsyncValue.error(
                "This voucher is not applicable for this course",
                StackTrace.current);
          }

          // Everything is valid, return the voucher
          return AsyncValue.data(response.data);
        } else {
          return AsyncValue.error(response.message, StackTrace.current);
        }
      },
    );
  }

  void clearVoucher() {
    state = const AsyncValue.data(null);
  }

  double getDiscountAmount(double originalPrice) {
    if (state.hasValue && state.value != null) {
      return state.value!.calculateDiscount(originalPrice);
    }
    return 0.0;
  }

  double getFinalPrice(double originalPrice) {
    final discount = getDiscountAmount(originalPrice);
    return originalPrice - discount;
  }
}
