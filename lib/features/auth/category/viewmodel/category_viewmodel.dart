// category_viewmodel.dart
import 'package:prostuti/features/auth/category/model/category_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_viewmodel.g.dart';

@riverpod
class CategoryViewModel extends _$CategoryViewModel {
  @override
  StudentCategory? build() {
    return null;
  }

  void setMainCategory(String mainCategory) {
    state = StudentCategory(mainCategory: mainCategory);
  }

  void setSubCategory(String? subCategory) {
    if (state == null) return;
    state = StudentCategory(
        mainCategory: state!.mainCategory, subCategory: subCategory);
  }

  void clearCategory() {
    state = null;
  }

  bool isValidCategory() {
    if (state == null) return false;

    // Job doesn't require a subcategory
    if (state!.mainCategory == 'Job') {
      return true;
    }

    // Academic and Admission require a subcategory
    return state!.subCategory != null && state!.subCategory!.isNotEmpty;
  }
}
