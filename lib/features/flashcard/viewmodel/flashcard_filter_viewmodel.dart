import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/category_model.dart';
import '../repository/flashcard_repo.dart';

part 'flashcard_filter_viewmodel.g.dart';

class FilterState {
  final String? selectedType;
  final String? selectedDivision;
  final String? selectedSubject;
  final bool isFilterActive;

  FilterState({
    this.selectedType,
    this.selectedDivision,
    this.selectedSubject,
    this.isFilterActive = false,
  });

  FilterState copyWith({
    String? selectedType,
    String? selectedDivision,
    String? selectedSubject,
    bool? isFilterActive,
  }) {
    return FilterState(
      selectedType: selectedType ?? this.selectedType,
      selectedDivision: selectedDivision ?? this.selectedDivision,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      isFilterActive: isFilterActive ?? this.isFilterActive,
    );
  }

  Map<String, String?> toQueryParams() {
    final Map<String, String?> params = {};

    if (selectedType != null && selectedType!.isNotEmpty) {
      params['categoryType'] = selectedType;
    }

    if (selectedDivision != null && selectedDivision!.isNotEmpty) {
      params['categoryDivision'] = selectedDivision;
    }

    if (selectedSubject != null && selectedSubject!.isNotEmpty) {
      params['categorySubject'] = selectedSubject;
    }

    return params;
  }
}

@Riverpod(keepAlive: true)
class FlashcardFilter extends _$FlashcardFilter {
  @override
  FilterState build() {
    return FilterState();
  }

  void setType(String? type) {
    state = state.copyWith(
      selectedType: type,
      // Reset dependent filters when type changes
      selectedDivision: null,
      selectedSubject: null,
    );
  }

  void setDivision(String? division) {
    state = state.copyWith(
      selectedDivision: division,
      // Reset subject when division changes
      selectedSubject: null,
    );
  }

  void setSubject(String? subject) {
    state = state.copyWith(selectedSubject: subject);
  }

  void applyFilters() {
    state = state.copyWith(isFilterActive: true);

    // We'll invalidate providers in the UI when this is called
  }

  void resetFilters() {
    state = FilterState();
  }
}

@Riverpod(keepAlive: true)
class Categories extends _$Categories {
  @override
  Future<List<Category>> build() async {
    return await _fetchCategories();
  }

  Future<List<Category>> _fetchCategories() async {
    final response = await ref.read(flashcardRepoProvider).getCategories();

    return response.fold(
      (l) {
        throw Exception(l.message);
      },
      (categoryList) {
        return categoryList.data ?? [];
      },
    );
  }

  // Get unique types
  List<String> getUniqueTypes(List<Category> categories) {
    final types = categories
        .map((e) => e.type)
        .where((type) => type != null && type.isNotEmpty)
        .toSet()
        .map((e) => e!)
        .toList();

    return types;
  }

  // Get unique divisions for a selected type
  List<String> getUniqueDivisions(
      List<Category> categories, String? selectedType) {
    if (selectedType == null) return [];

    final divisions = categories
        .where((e) => e.type == selectedType)
        .map((e) => e.division)
        .where((division) => division != null && division.isNotEmpty)
        .toSet()
        .map((e) => e!)
        .toList();

    return divisions;
  }

  // Get unique subjects for selected type and division
  List<String> getUniqueSubjects(
    List<Category> categories,
    String? selectedType,
    String? selectedDivision,
  ) {
    if (selectedType == null) return [];

    // Filter by type
    var filtered = categories.where((e) => e.type == selectedType);

    // If division is selected, further filter by division
    if (selectedDivision != null && selectedDivision.isNotEmpty) {
      filtered = filtered.where((e) => e.division == selectedDivision);
    }

    // Extract unique subjects
    final subjects = filtered
        .map((e) => e.subject)
        .where((subject) => subject != null && subject.isNotEmpty)
        .toSet()
        .map((e) => e!)
        .toList();

    return subjects;
  }
}
