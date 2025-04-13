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

  Future<Category> getCategoryList() async {
    final response = await _dioService.getRequest("/category/type");

    if (response.statusCode == 200) {
      return Category.fromJson(response.data);
    }
    final errorResponse = ErrorResponse.fromJson(response.data);
    ErrorHandler().setErrorMessage(errorResponse.message);
    throw ApiResponse.error(errorResponse);
  }

  Future<SubCategory> getSubCategoryList(String mainCategory) async {
    final response =
        await _dioService.getRequest("/category/subtype/$mainCategory");

    if (response.statusCode == 200) {
      return SubCategory.fromJson(response.data);
    }

    // If API doesn't yet support subcategories, use the local constants
    // This is for backward compatibility during transition
    final subcategories = CategoryConstants.getSubcategoriesFor(mainCategory);
    if (subcategories.isNotEmpty) {
      return SubCategory(
        success: true,
        message: "Subcategories retrieved successfully",
        meta: Meta(count: subcategories.length),
        data: subcategories,
      );
    }

    final errorResponse = ErrorResponse.fromJson(response.data);
    ErrorHandler().setErrorMessage(errorResponse.message);
    throw ApiResponse.error(errorResponse);
  }

  Future<ApiResponse> updateStudentCategory(
      String studentId, String mainCategory, String? subCategory) async {
    final payload = {
      "mainCategory": mainCategory,
      if (subCategory != null) "subCategory": subCategory,
    };

    final response = await _dioService
        .patchRequest("/students/category/$studentId", data: payload);

    if (response.statusCode == 200) {
      return ApiResponse.success(response.data);
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return ApiResponse.error(errorResponse);
    }
  }
}

final categoryListProvider = FutureProvider<Category>((ref) async {
  return await ref.read(categoryRepoProvider).getCategoryList();
});

final subcategoryListProvider =
    FutureProvider.family<SubCategory, String>((ref, mainCategory) async {
  return await ref.read(categoryRepoProvider).getSubCategoryList(mainCategory);
});
