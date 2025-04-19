// lib/features/payment/viewmodel/voucher_list_viewmodel.dart
import 'package:prostuti/features/payment/repository/payment_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/voucher_model.dart';

part 'voucher_list_viewmodel.g.dart';

@riverpod
class VoucherListNotifier extends _$VoucherListNotifier {
  @override
  Future<List<VoucherModel>> build({String? courseId}) async {
    return await _fetchAndFilterVouchers(courseId);
  }

  Future<List<VoucherModel>> _fetchAndFilterVouchers(String? courseId) async {
    final result = await ref.read(paymentRepoProvider).getAllVouchers();

    return result.fold(
      (error) => throw Exception(error.message),
      (vouchers) {
        // Client-side filtering for active and non-expired vouchers
        vouchers = vouchers.where((v) => v.isActive && !v.isExpired).toList();

        // If courseId is provided, filter vouchers that are applicable for this course
        if (courseId != null) {
          vouchers = vouchers.where((voucher) {
            // Allow vouchers for all courses
            if (voucher.voucherType == 'All_Course') {
              return true;
            }

            // Allow course-specific vouchers only if they match this course
            if (voucher.voucherType == 'Specific_Course') {
              return voucher.courseId == courseId;
            }

            // Always allow student-specific vouchers (they're already filtered by the API)
            if (voucher.voucherType == 'Specific_Student') {
              return true;
            }

            return false;
          }).toList();
        }

        // Sort vouchers by their effective value (highest discount first)
        vouchers.sort((a, b) {
          // First priority: Student-specific vouchers
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

          // For same type vouchers, sort by discount value
          // Use a reference price of 1000 to compare percentage vs fixed amount discounts
          double getEffectiveDiscount(VoucherModel voucher) {
            const referencePrice = 1000.0;
            if (voucher.discountType == 'Percentage') {
              return (referencePrice * voucher.discountValue) / 100;
            } else {
              return voucher.discountValue;
            }
          }

          // Higher discount first
          return getEffectiveDiscount(b).compareTo(getEffectiveDiscount(a));
        });

        return vouchers;
      },
    );
  }

  Future<void> refreshVouchers(String? courseId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchAndFilterVouchers(courseId));
  }
}
