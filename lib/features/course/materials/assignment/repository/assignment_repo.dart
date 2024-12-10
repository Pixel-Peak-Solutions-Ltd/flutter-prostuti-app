// __brick__/repository/assignment_repo.dart
import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/features/course/materials/assignment/model/assignment_details.dart';
import 'package:prostuti/features/course/materials/assignment/model/assignment_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

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
    final response = await _dioService.getRequest("/assignment/course/$userId");

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
}
