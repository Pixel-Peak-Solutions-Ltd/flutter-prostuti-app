import 'package:prostuti/features/payment/repository/payment_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_category.g.dart';

@riverpod
class UserCategory extends _$UserCategory {
  @override
  Future<String> build() async {
    return await _getUserCategory();
  }

  Future<String> _getUserCategory() async {
    final response = await ref.read(paymentRepoProvider).getStudentProfile();

    return response.fold(
      (l) => throw Exception(l.message), // Handle error case
      (r) {
        return r.data!.categoryType.toString();
      },
    );
  }
}
