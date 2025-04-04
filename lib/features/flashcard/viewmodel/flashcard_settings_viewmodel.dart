import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'flashcard_settings_viewmodel.g.dart';

// Keys for SharedPreferences
const String kSelectedCategoryId = 'selected_category_id';
const String kSelectedVisibility = 'selected_visibility';
const String kSelectedCategoryType = 'selected_category_type';
const String kSelectedCategoryDivision = 'selected_category_division';
const String kSelectedCategorySubject = 'selected_category_subject';

class FlashcardSettings {
  final String? categoryId;
  final String? visibility;
  final String? categoryType;
  final String? categoryDivision;
  final String? categorySubject;

  FlashcardSettings({
    this.categoryId,
    this.visibility = 'EVERYONE',
    this.categoryType,
    this.categoryDivision,
    this.categorySubject,
  });

  FlashcardSettings copyWith({
    String? categoryId,
    String? visibility,
    String? categoryType,
    String? categoryDivision,
    String? categorySubject,
  }) {
    return FlashcardSettings(
      categoryId: categoryId ?? this.categoryId,
      visibility: visibility ?? this.visibility,
      categoryType: categoryType ?? this.categoryType,
      categoryDivision: categoryDivision ?? this.categoryDivision,
      categorySubject: categorySubject ?? this.categorySubject,
    );
  }

  // Save settings to SharedPreferences
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    if (categoryId != null) {
      await prefs.setString(kSelectedCategoryId, categoryId!);
    }

    if (visibility != null) {
      await prefs.setString(kSelectedVisibility, visibility!);
    }

    if (categoryType != null) {
      await prefs.setString(kSelectedCategoryType, categoryType!);
    }

    if (categoryDivision != null) {
      await prefs.setString(kSelectedCategoryDivision, categoryDivision!);
    }

    if (categorySubject != null) {
      await prefs.setString(kSelectedCategorySubject, categorySubject!);
    }
  }

  // Load settings from SharedPreferences
  static Future<FlashcardSettings> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    return FlashcardSettings(
      categoryId: prefs.getString(kSelectedCategoryId),
      visibility: prefs.getString(kSelectedVisibility) ?? 'EVERYONE',
      categoryType: prefs.getString(kSelectedCategoryType),
      categoryDivision: prefs.getString(kSelectedCategoryDivision),
      categorySubject: prefs.getString(kSelectedCategorySubject),
    );
  }
}

@Riverpod(keepAlive: true)
class FlashcardSettingsNotifier extends _$FlashcardSettingsNotifier {
  @override
  Future<FlashcardSettings> build() async {
    return FlashcardSettings.loadFromPrefs();
  }

  Future<void> setCategoryId(String categoryId) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(categoryId: categoryId);
    await newSettings.saveToPrefs();
    state = AsyncValue.data(newSettings);
  }

  Future<void> setVisibility(String visibility) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(visibility: visibility);
    await newSettings.saveToPrefs();
    state = AsyncValue.data(newSettings);
  }

  Future<void> setCategoryDetails({
    required String? categoryId,
    required String? categoryType,
    required String? categoryDivision,
    required String? categorySubject,
  }) async {
    final currentSettings = await future;
    final newSettings = currentSettings.copyWith(
      categoryId: categoryId,
      categoryType: categoryType,
      categoryDivision: categoryDivision,
      categorySubject: categorySubject,
    );
    await newSettings.saveToPrefs();
    state = AsyncValue.data(newSettings);
  }
}
