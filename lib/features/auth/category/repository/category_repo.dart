// Updated category_repo.dart
import 'package:prostuti/core/services/api_response.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:prostuti/features/auth/category/model/category_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/category_constant.dart';

part 'category_repo.g.dart';

@riverpod
CategoryRepo categoryRepo(CategoryRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return CategoryRepo(dioService);
}

class CategoryRepo {
  final DioService _dioService;

  CategoryRepo(this._dioService);

  // Original method to get categories
  Future<ApiResponse> getCategoryList() async {
    final response = await _dioService.getRequest("/category/type");

    if (response.statusCode == 200) {
      return ApiResponse.success(response.data);
    }
    final errorResponse = ErrorResponse.fromJson(response.data);
    ErrorHandler().setErrorMessage(errorResponse.message);
    return ApiResponse.error(errorResponse);
  }

  // Get all main categories (Academic, Admission, Job)
  Future<ApiResponse> getMainCategories() async {
    try {
      final response = await _dioService.getRequest("/category/main");

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data['data']);
      }
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return ApiResponse.error(errorResponse);
    } catch (e) {
      ErrorHandler().setErrorMessage(e.toString());
      return ApiResponse.error(
          ErrorResponse(message: e.toString(), success: false));
    }
  }

  // Get subcategories for a main category
  Future<ApiResponse> getSubCategories(String mainCategory) async {
    try {
      final response =
          await _dioService.getRequest("/category/sub/$mainCategory");

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data['data']);
      }
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return ApiResponse.error(errorResponse);
    } catch (e) {
      ErrorHandler().setErrorMessage(e.toString());
      return ApiResponse.error(
          ErrorResponse(message: e.toString(), success: false));
    }
  }

  // Add this method to your CategoryRepo class

// Update student category with explicit payload format
  Future<ApiResponse> updateStudentCategoryDirect(
      String studentId, String mainCategory, String? subCategory) async {
    try {
      // Create a simple map payload
      final Map<String, dynamic> payload = {
        "mainCategory": mainCategory,
      };

      // Only add subCategory if it's not null
      if (subCategory != null && subCategory.isNotEmpty) {
        payload["subCategory"] = subCategory;
      }

      // Log the request for debugging
      print("Sending category update for student $studentId: $payload");

      final response = await _dioService
          .patchRequest("/student/category/$studentId", data: payload);

      // Log the response
      print("Category update response: ${response.data}");

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data);
      }

      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return ApiResponse.error(errorResponse);
    } catch (e) {
      print("Exception in updateStudentCategoryDirect: $e");
      ErrorHandler().setErrorMessage(e.toString());
      return ApiResponse.error(
          ErrorResponse(message: e.toString(), success: false));
    }
  }

  Future<ApiResponse> updateStudentCategory(StudentCategory category) async {
    try {
      // Create a direct format payload (Option 3 that worked)
      final payload = {
        "mainCategory": category.mainCategory,
      };

      // Only add subCategory if it exists
      if (category.subCategory != null && category.subCategory!.isNotEmpty) {
        payload["subCategory"] = category.subCategory!;
      }

      final response = await _dioService.patchRequest(
        "/student/update-category",
        // Update this path to match your new endpoint
        data: payload,
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data);
      }
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return ApiResponse.error(errorResponse);
    } catch (e) {
      ErrorHandler().setErrorMessage(e.toString());
      return ApiResponse.error(
          ErrorResponse(message: e.toString(), success: false));
    }
  }

  // Helper method to determine if a main category requires a subcategory
  bool requiresSubcategory(String mainCategory) {
    return mainCategory == MainCategory.ACADEMIC ||
        mainCategory == MainCategory.ADMISSION;
  }
}

// Provider for category list
final categoryListProvider = FutureProvider<ApiResponse>((ref) async {
  return await ref.read(categoryRepoProvider).getCategoryList();
});

// Providers for the new structured approach
final mainCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final response = await ref.read(categoryRepoProvider).getMainCategories();
  if (response.data != null) {
    return List<String>.from(response.data);
  }
  return [];
});

final subCategoriesProvider =
    FutureProvider.family<List<String>, String>((ref, mainCategory) async {
  // For Job category, return empty list as it doesn't have subcategories
  if (mainCategory == MainCategory.JOB) return [];

  final response =
      await ref.read(categoryRepoProvider).getSubCategories(mainCategory);
  if (response.data != null) {
    return List<String>.from(response.data);
  }
  return [];
});
