// lib/core/services/local_storage_service.dart

import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/models/student_profile.dart'; // <-- Adjust this import path to your student_profile.dart file

part 'local_storage_service.g.dart';

// A provider to access our service
@Riverpod(keepAlive: true)
LocalStorageService localStorageService(LocalStorageServiceRef ref) {
  return LocalStorageService();
}

class LocalStorageService {
  // A key to find our data in shared preferences
  static const String _userProfileKey = 'userProfile';

  /// Saves the StudentProfile object to local storage.
  /// It converts the object to a JSON string before saving.
  Future<void> saveUserProfile(StudentProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = jsonEncode(profile.toJson());
    await prefs.setString(_userProfileKey, profileJson);
  }

  /// Retrieves the StudentProfile from local storage.
  /// It reads the JSON string and converts it back to a StudentProfile object.
  Future<StudentProfile?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_userProfileKey);
    if (profileJson != null) {
      return StudentProfile.fromJson(jsonDecode(profileJson));
    }
    return null; // Return null if no profile is cached
  }

  /// Clears the cached user profile.
  Future<void> clearUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userProfileKey);
  }
}
