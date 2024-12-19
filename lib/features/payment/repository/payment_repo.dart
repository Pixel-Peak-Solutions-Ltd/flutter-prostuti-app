// __brick__/repository/payment_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part 'payment_repo.g.dart';

@riverpod
PaymentRepo paymentRepo(PaymentRepoRef ref) {
final dioService = ref.watch(dioServiceProvider);
return PaymentRepo(dioService);
}

class PaymentRepo {
final DioService _dioService;

PaymentRepo(this._dioService);
}