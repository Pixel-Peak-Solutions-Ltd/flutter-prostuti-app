// __brick__/repository/assignment_repo.dart
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/features/course/materials/assignment/model/assignment_details.dart';
import 'package:prostuti/features/course/materials/assignment/model/assignment_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/services/error_handler.dart';
import '../../../../../core/services/error_response.dart';

part 'assignment_repo.g.dart';

@riverpod
AssignmentRepo assignmentRepo(AssignmentRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return AssignmentRepo(dioService);
}

class AssignmentRepo {
  final DioService _dioService;

  AssignmentRepo(this._dioService);

  Future<Either<ErrorResponse, AssignmentList>> getAssignmentList(
      String userId) async {
    final response = await _dioService.getRequest("/assignment-submission");

    if (response.statusCode == 200) {
      return Right(AssignmentList.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, AssignmentDetails>> getAssignmentById(
      String id) async {
    final response = await _dioService.getRequest("/assignment/$id");

    if (response.statusCode == 200) {
      return Right(AssignmentDetails.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, dynamic>> submitAssignment({
    required String courseId,
    required String assignmentId,
    required String filePath,
  }) async {
    try {
      // Set submission date to 24 hours in the past to avoid any timezone issues
      final DateTime yesterday =
          DateTime.now().subtract(const Duration(days: 1));

      // Format the date according to ISO 8601 in UTC
      final String formattedDate =
          "${yesterday.toUtc().toIso8601String().split('.')[0]}Z";

      print("Using submission date: $formattedDate");

      final file = await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
        contentType: MediaType('application', 'pdf'),
      );

      final formData = FormData.fromMap({
        'file': file,
        'data': jsonEncode({
          'course_id': courseId,
          'assignment_id': assignmentId,
          'status': 'submitted',
          'submissionDate': formattedDate,
        }),
      });

      final response = await _dioService.postMultipartRequest(
        '/assignment-submission',
        formData,
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        final errorResponse = ErrorResponse.fromJson(response.data);
        ErrorHandler().setErrorMessage(errorResponse.message);
        return Left(errorResponse);
      }
    } catch (e) {
      return Left(ErrorResponse(
        success: false,
        message: e.toString(),
      ));
    }
  }
}
