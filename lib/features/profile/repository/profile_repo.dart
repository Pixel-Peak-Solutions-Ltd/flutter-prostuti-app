// Update profile_repo.dart
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repo.g.dart';

@riverpod
ProfileRepo profileRepo(ProfileRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return ProfileRepo(dioService);
}

class ProfileRepo {
  final DioService _dioService;

  ProfileRepo(this._dioService);

  Future<Either<ErrorResponse, bool>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final payload = {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      final response =
          await _dioService.postRequest("/auth/change-password", payload);

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        final errorResponse = ErrorResponse.fromJson(response.data);
        ErrorHandler().setErrorMessage(errorResponse.message);
        return Left(errorResponse);
      }
    } catch (e) {
      final errorResponse = ErrorResponse(
        message: e.toString(),
        success: e.toString() == 'true',
      );
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, bool>> updateProfile({
    String? name,
    XFile? image,
    required String studentId,
  }) async {
    try {
      // Debug values
      debugPrint("Updating profile for student ID: $studentId");
      debugPrint("Name to update: $name");
      debugPrint("Image to update: ${image?.name}");

      // Create form data
      FormData formData = FormData();

      // Add profile data as JSON string
      final Map<String, dynamic> profileData = {};
      if (name != null) {
        profileData['name'] = name;
      }

      // Debug the profile data
      debugPrint("Profile data to send: $profileData");

      // Only add profileData if we have something to update
      if (profileData.isNotEmpty) {
        // Note: The API expects 'profileData' as a JSON string
        final jsonString = jsonEncode(profileData);
        debugPrint("JSON string to send: $jsonString");

        formData.fields.add(
          MapEntry('profileData', jsonString),
        );
      }

      // Add image if provided
      if (image != null) {
        final bytes = await image.readAsBytes();
        final multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: image.name,
        );
        formData.files.add(MapEntry('avatar', multipartFile));
        debugPrint("Added image to form data: ${image.name}");
      }

      // Return early if nothing to update
      if (profileData.isEmpty && image == null) {
        debugPrint("No changes to update");
        return const Right(false);
      }

      // Make the request - Note that the API expects a PATCH request according to your route
      debugPrint("Sending PATCH request to /student/profile/$studentId");
      final response = await _dioService.patchRequest(
        "/student/profile/$studentId",
        data: formData,
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        final errorResponse = ErrorResponse.fromJson(response.data);
        ErrorHandler().setErrorMessage(errorResponse.message);
        return Left(errorResponse);
      }
    } catch (e) {
      final errorResponse = ErrorResponse(
        message: e.toString(),
        success: e.toString() == 'true',
      );
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
