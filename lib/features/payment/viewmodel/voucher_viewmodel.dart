// lib/features/payment/viewmodel/voucher_viewmodel.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/voucher_model.dart';

part 'voucher_viewmodel.g.dart';

@riverpod
class VoucherNotifier extends _$VoucherNotifier {
  @override
  AsyncValue<VoucherModel?> build() {
    return const AsyncValue.data(null);
  }

  // Client-side validation of a voucher
  void selectVoucher(VoucherModel voucher,
      {String? courseId, required double originalPrice}) {
    // Verify the voucher is valid
    if (!voucher.isActive || voucher.isExpired) {
      state = AsyncValue.error(
          "This voucher is not active or has expired", StackTrace.current);
      return;
    }

    // For course-specific vouchers, verify they match the current course
    if (voucher.voucherType == 'Specific_Course' &&
        voucher.courseId != courseId) {
      state = AsyncValue.error(
          "This voucher is not applicable for this course", StackTrace.current);
      return;
    }

    // Ensure the discount makes sense (not negative, not more than 100% for percentage)
    if (voucher.discountValue < 0 ||
        (voucher.discountType == 'Percentage' && voucher.discountValue > 100)) {
      state = AsyncValue.error("Invalid discount value", StackTrace.current);
      return;
    }

    // All validation passed, set the voucher
    state = AsyncValue.data(voucher);
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
