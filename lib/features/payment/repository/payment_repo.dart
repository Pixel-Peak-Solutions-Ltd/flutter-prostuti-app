// __brick__/repository/payment_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_repo.g.dart';

@riverpod
PaymentRepo paymentRepo(PaymentRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return PaymentRepo(dioService);
}

class PaymentRepo {
  final DioService _dioService;

  PaymentRepo(this._dioService);

  Future initiatePayment(payload) async {
    final response =
        await _dioService.postRequest("/enroll-course/paid/init", payload);

    if (response.statusCode == 200) {
      return response.data['data'];
    } else if (response.statusCode == 409) {
      return response.data["message"];
    } else {
      response.data;
    }
  }

  Future<bool> enrollFreeCourse(payload) async {
    final response =
        await _dioService.postRequest("/enroll-course/free", payload);

    if (response.statusCode == 200) {
      return response.data['success'];
    } else {
      return response.data['success'];
    }
  }
}
