import 'package:prostuti/features/auth/category/model/category_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class SelectedMainCategory extends _$SelectedMainCategory {
  @override
  String? build() {
    return null;
  }

  void setMainCategory(String category) {
    state = category;
  }

  void clear() {
    state = null;
  }
}

@Riverpod(keepAlive: true)
class SelectedSubCategory extends _$SelectedSubCategory {
  @override
  String? build() {
    return null;
  }

  void setSubCategory(String? subcategory) {
    state = subcategory;
  }

  void clear() {
    state = null;
  }
}

@Riverpod(keepAlive: true)
class StudentId extends _$StudentId {
  @override
  String? build() {
    return null;
  }

  void setStudentId(String id) {
    state = id;
  }
}
