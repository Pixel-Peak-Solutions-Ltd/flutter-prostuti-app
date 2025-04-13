// category_constant.dart
class MainCategory {
  static const String ACADEMIC = "Academic";
  static const String ADMISSION = "Admission";
  static const String JOB = "Job";

  static const List<String> values = [ACADEMIC, ADMISSION, JOB];
}

class AcademicSubCategory {
  static const String SCIENCE = "Science";
  static const String COMMERCE = "Commerce";
  static const String ARTS = "Arts";

  static const List<String> values = [SCIENCE, COMMERCE, ARTS];
}

class AdmissionSubCategory {
  static const String ENGINEERING = "Engineering";
  static const String MEDICAL = "Medical";
  static const String UNIVERSITY = "University";

  static const List<String> values = [ENGINEERING, MEDICAL, UNIVERSITY];
}

// Helper function to get subcategories for a main category
List<String> getSubcategoriesForMainCategory(String mainCategory) {
  switch (mainCategory) {
    case MainCategory.ACADEMIC:
      return AcademicSubCategory.values;
    case MainCategory.ADMISSION:
      return AdmissionSubCategory.values;
    case MainCategory.JOB:
    default:
      return [];
  }
}
