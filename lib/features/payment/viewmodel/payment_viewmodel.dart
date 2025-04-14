// lib/features/payment/viewmodel/payment_viewmodel.dart
import 'package:prostuti/features/payment/repository/payment_repo.dart';
import 'package:prostuti/features/payment/viewmodel/voucher_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_viewmodel.g.dart';

@riverpod
class PaymentNotifier extends _$PaymentNotifier {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<String?> initiatePayment({
    required String courseId,
    required double totalPrice,
    bool applyVoucher = false,
  }) async {
    state = const AsyncValue.loading();

    try {
      // Note: We're only sending courseId since it seems the price fields are rejected
      Map<String, dynamic> payload = {
        "course_id": [courseId]
      };

      // Debug what we're sending
      print("Payment payload with courseId $courseId");
      print("Full payload: $payload");

      // Add voucher if applicable
      final voucherState = ref.read(voucherNotifierProvider);
      if (applyVoucher && voucherState.hasValue && voucherState.value != null) {
        payload["isVoucherAdded"] = true;
        payload["voucher_id"] = voucherState.value!.id;
        print("Adding voucher: ${voucherState.value!.id}");
      }

      final result =
          await ref.read(paymentRepoProvider).initiatePayment(payload);

      return result.fold((error) {
        print("Payment init error: ${error.message}");
        state = AsyncValue.error(error.message, StackTrace.current);
        return null;
      }, (paymentUrl) {
        print("Payment URL result: $paymentUrl");
        state = AsyncValue.data(paymentUrl);
        return paymentUrl;
      });
    } catch (e, stackTrace) {
      print("Payment exception: $e");
      state = AsyncValue.error(e.toString(), stackTrace);
      return null;
    }
  }

  Future<String?> initiateSubscription(String requestedPlan,
      {bool applyVoucher = false}) async {
    state = const AsyncValue.loading();

    try {
      // Create subscription payload with the correct field names
      Map<String, dynamic> payload = {"requestedPlan": requestedPlan};

      // Debug what we're sending
      print("Subscription payload with plan $requestedPlan");
      print("Full payload: $payload");

      // Add voucher if applicable
      final voucherState = ref.read(voucherNotifierProvider);
      if (applyVoucher && voucherState.hasValue && voucherState.value != null) {
        payload["isVoucherAdded"] = true;
        payload["voucher_id"] = voucherState.value!.id;
        print("Adding voucher: ${voucherState.value!.id}");
      }

      final result = await ref.read(paymentRepoProvider).subscribe(payload);

      return result.fold((error) {
        print("Subscription init error: ${error.message}");
        state = AsyncValue.error(error.message, StackTrace.current);
        return null;
      }, (paymentUrl) {
        print("Subscription URL result: $paymentUrl");
        state = AsyncValue.data(paymentUrl);
        return paymentUrl;
      });
    } catch (e, stackTrace) {
      print("Subscription exception: $e");
      state = AsyncValue.error(e.toString(), stackTrace);
      return null;
    }
  }
}
