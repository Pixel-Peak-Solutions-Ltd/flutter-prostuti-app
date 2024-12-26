// __brick__/repository/category_repo.dart
import 'package:prostuti/core/services/api_response.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:prostuti/features/auth/category/model/category_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_repo.g.dart';

@riverpod
CategoryRepo categoryRepo(CategoryRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return CategoryRepo(dioService);
}

class CategoryRepo {
  final DioService _dioService;

  CategoryRepo(this._dioService);

  Future getCategoryList() async {
    final response = await _dioService.getRequest("/category/type");

    if (response.statusCode == 200) {
      print(response.data);
      return Category.fromJson(response.data);
    }
    final errorResponse = ErrorResponse.fromJson(response.data);
    ErrorHandler().setErrorMessage(errorResponse.message);
    return ApiResponse.error(errorResponse);
  }
}

final categoryListProvider = FutureProvider<Category>((ref) async {
  return await ref.read(categoryRepoProvider).getCategoryList();
});
