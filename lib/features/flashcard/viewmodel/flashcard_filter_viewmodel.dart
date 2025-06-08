import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/category_model.dart';
import '../repository/flashcard_repo.dart';

part 'flashcard_filter_viewmodel.g.dart';

class FilterState {
  final String? selectedType;

  // Academic specific
  final String? selectedDivision;

  // Job specific
  final String? selectedJobType;
  final String? selectedJobName;

  // Admission specific
  final String? selectedUniversityType;
  final String? selectedUniversityName;
  final String? selectedUnit;

  // Common
  final String? selectedSubject;
  final bool isFilterActive;

  FilterState({
    this.selectedType,
    this.selectedDivision,
    this.selectedJobType,
    this.selectedJobName,
    this.selectedUniversityType,
    this.selectedUniversityName,
    this.selectedUnit,
    this.selectedSubject,
    this.isFilterActive = false,
  });

  FilterState copyWith({
    String? selectedType,
    String? selectedDivision,
    String? selectedJobType,
    String? selectedJobName,
    String? selectedUniversityType,
    String? selectedUniversityName,
    String? selectedUnit,
    String? selectedSubject,
    bool? isFilterActive,
  }) {
    return FilterState(
      selectedType: selectedType ?? this.selectedType,
      selectedDivision: selectedDivision ?? this.selectedDivision,
      selectedJobType: selectedJobType ?? this.selectedJobType,
      selectedJobName: selectedJobName ?? this.selectedJobName,
      selectedUniversityType:
          selectedUniversityType ?? this.selectedUniversityType,
      selectedUniversityName:
          selectedUniversityName ?? this.selectedUniversityName,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      isFilterActive: isFilterActive ?? this.isFilterActive,
    );
  }

  Map<String, String?> toQueryParams() {
    final Map<String, String?> params = {};

    if (selectedType != null && selectedType!.isNotEmpty) {
      params['type'] = selectedType;
    }

    // Handle different types
    switch (selectedType) {
      case 'Academic':
        if (selectedDivision != null && selectedDivision!.isNotEmpty) {
          params['division'] = selectedDivision;
        }
        break;
      case 'Job':
        if (selectedJobType != null && selectedJobType!.isNotEmpty) {
          params['jobType'] = selectedJobType;
        }
        if (selectedJobName != null && selectedJobName!.isNotEmpty) {
          params['jobName'] = selectedJobName;
        }
        break;
      case 'Admission':
        if (selectedUniversityType != null &&
            selectedUniversityType!.isNotEmpty) {
          params['universityType'] = selectedUniversityType;
        }
        if (selectedUniversityName != null &&
            selectedUniversityName!.isNotEmpty) {
          params['universityName'] = selectedUniversityName;
        }
        if (selectedUnit != null && selectedUnit!.isNotEmpty) {
          params['unit'] = selectedUnit;
        }
        break;
    }

    if (selectedSubject != null && selectedSubject!.isNotEmpty) {
      params['subject'] = selectedSubject;
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
      // Reset all dependent filters when type changes
      selectedDivision: null,
      selectedJobType: null,
      selectedJobName: null,
      selectedUniversityType: null,
      selectedUniversityName: null,
      selectedUnit: null,
      selectedSubject: null,
    );
  }

  // Academic specific
  void setDivision(String? division) {
    state = state.copyWith(
      selectedDivision: division,
      selectedSubject: null,
    );
  }

  // Job specific
  void setJobType(String? jobType) {
    state = state.copyWith(
      selectedJobType: jobType,
      selectedJobName: null,
      selectedSubject: null,
    );
  }

  void setJobName(String? jobName) {
    state = state.copyWith(
      selectedJobName: jobName,
      selectedSubject: null,
    );
  }

  // Admission specific
  void setUniversityType(String? universityType) {
    state = state.copyWith(
      selectedUniversityType: universityType,
      selectedUniversityName: null,
      selectedUnit: null,
      selectedSubject: null,
    );
  }

  void setUniversityName(String? universityName) {
    state = state.copyWith(
      selectedUniversityName: universityName,
      selectedUnit: null,
      selectedSubject: null,
    );
  }

  void setUnit(String? unit) {
    state = state.copyWith(
      selectedUnit: unit,
      selectedSubject: null,
    );
  }

  // Common
  void setSubject(String? subject) {
    state = state.copyWith(selectedSubject: subject);
  }

  void applyFilters() {
    state = state.copyWith(isFilterActive: true);
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

  // Academic specific methods
  List<String> getUniqueDivisions(List<Category> categories) {
    final divisions = categories
        .where((e) => e.type == 'Academic')
        .map((e) => e.division)
        .where((division) => division != null && division.isNotEmpty)
        .toSet()
        .map((e) => e!)
        .toList();

    return divisions;
  }

  // Job specific methods
  List<String> getUniqueJobTypes(List<Category> categories) {
    final jobTypes = categories
        .where((e) => e.type == 'Job')
        .map((e) => e.jobType)
        .where((jobType) => jobType != null && jobType.isNotEmpty)
        .toSet()
        .map((e) => e!)
        .toList();

    return jobTypes;
  }

  List<String> getUniqueJobNames(
      List<Category> categories, String? selectedJobType) {
    if (selectedJobType == null) return [];

    final jobNames = categories
        .where((e) => e.type == 'Job' && e.jobType == selectedJobType)
        .map((e) => e.jobName)
        .where((jobName) => jobName != null && jobName.isNotEmpty)
        .toSet()
        .map((e) => e!)
        .toList();

    return jobNames;
  }

  // Admission specific methods
  List<String> getUniqueUniversityTypes(List<Category> categories) {
    final universityTypes = categories
        .where((e) => e.type == 'Admission')
        .map((e) => e.universityType)
        .where((universityType) =>
            universityType != null && universityType.isNotEmpty)
        .toSet()
        .map((e) => e!)
        .toList();

    return universityTypes;
  }

  List<String> getUniqueUniversityNames(
      List<Category> categories, String? selectedUniversityType) {
    if (selectedUniversityType == null ||
        selectedUniversityType != 'University') return [];

    final universityNames = categories
        .where((e) => e.type == 'Admission' && e.universityType == 'University')
        .map((e) => e.universityName)
        .where((universityName) =>
            universityName != null && universityName.isNotEmpty)
        .toSet()
        .map((e) => e!)
        .toList();

    return universityNames;
  }

  List<String> getUniqueUnits(List<Category> categories,
      String? selectedUniversityType, String? selectedUniversityName) {
    if (selectedUniversityType == null ||
        selectedUniversityType != 'University' ||
        selectedUniversityName == null) return [];

    final units = categories
        .where((e) =>
            e.type == 'Admission' &&
            e.universityType == 'University' &&
            e.universityName == selectedUniversityName)
        .map((e) => e.unit)
        .where((unit) => unit != null && unit.isNotEmpty)
        .toSet()
        .map((e) => e!)
        .toList();

    return units;
  }

  // Get subjects based on selected filters
  List<String> getUniqueSubjects(
    List<Category> categories,
    FilterState filterState,
  ) {
    var filtered = categories.where((e) => e.type == filterState.selectedType);

    switch (filterState.selectedType) {
      case 'Academic':
        if (filterState.selectedDivision != null &&
            filterState.selectedDivision!.isNotEmpty) {
          filtered =
              filtered.where((e) => e.division == filterState.selectedDivision);
        }
        break;
      case 'Job':
        if (filterState.selectedJobType != null &&
            filterState.selectedJobType!.isNotEmpty) {
          filtered =
              filtered.where((e) => e.jobType == filterState.selectedJobType);
        }
        if (filterState.selectedJobName != null &&
            filterState.selectedJobName!.isNotEmpty) {
          filtered =
              filtered.where((e) => e.jobName == filterState.selectedJobName);
        }
        break;
      case 'Admission':
        if (filterState.selectedUniversityType != null &&
            filterState.selectedUniversityType!.isNotEmpty) {
          filtered = filtered.where(
              (e) => e.universityType == filterState.selectedUniversityType);
        }
        if (filterState.selectedUniversityName != null &&
            filterState.selectedUniversityName!.isNotEmpty) {
          filtered = filtered.where(
              (e) => e.universityName == filterState.selectedUniversityName);
        }
        if (filterState.selectedUnit != null &&
            filterState.selectedUnit!.isNotEmpty) {
          filtered = filtered.where((e) => e.unit == filterState.selectedUnit);
        }
        break;
    }

    final subjects = filtered
        .map((e) => e.subject)
        .where((subject) => subject != null && subject.isNotEmpty)
        .toSet()
        .map((e) => e!)
        .toList();

    return subjects;
  }
}
