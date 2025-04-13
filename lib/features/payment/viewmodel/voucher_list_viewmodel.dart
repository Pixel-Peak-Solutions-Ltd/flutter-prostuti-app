// lib/features/payment/viewmodel/voucher_list_viewmodel.dart
import 'package:prostuti/features/payment/repository/payment_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/voucher_model.dart';

part 'voucher_list_viewmodel.g.dart';

@riverpod
class VoucherListNotifier extends _$VoucherListNotifier {
  @override
  Future<List<VoucherModel>> build({String? courseId}) async {
    return await _fetchVouchers(courseId);
  }

  Future<List<VoucherModel>> _fetchVouchers(String? courseId) async {
    final result =
        await ref.read(paymentRepoProvider).getAllVouchers(courseId: courseId);

    return result.fold(
      (error) => throw Exception(error.message),
      (vouchers) {
        // Sort vouchers: first by student-specific, then by discount value (highest first)
        vouchers.sort((a, b) {
          // First priority: Student-specific vouchers come first
          if (a.voucherType == 'Specific_Student' &&
              b.voucherType != 'Specific_Student') {
            return -1;
          }
          if (a.voucherType != 'Specific_Student' &&
              b.voucherType == 'Specific_Student') {
            return 1;
          }

          // Second priority: Course-specific vouchers
          if (a.voucherType == 'Specific_Course' &&
              b.voucherType != 'Specific_Course') {
            return -1;
          }
          if (a.voucherType != 'Specific_Course' &&
              b.voucherType == 'Specific_Course') {
            return 1;
          }

          // Third priority: Sort by discount value (higher first)
          // For percentage discounts, we prioritize them
          if (a.discountType == 'Percentage' && b.discountType == 'Amount') {
            return -1;
          }
          if (a.discountType == 'Amount' && b.discountType == 'Percentage') {
            return 1;
          }

          // Compare the actual discount values
          return b.discountValue.compareTo(a.discountValue);
        });

        return vouchers;
      },
    );
  }

  Future<void> refreshVouchers(String? courseId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchVouchers(courseId));
  }
}
