// __brick__/repository/record_class_repo.dart
import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:prostuti/features/course/materials/record_class/model/record_class_details.dart';
import 'package:prostuti/features/course/materials/record_class/model/record_class_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/services/error_handler.dart';
import '../../../../../core/services/nav.dart';
import '../../../../auth/login/view/login_view.dart';

part 'record_class_repo.g.dart';

@riverpod
RecordClassRepo recordClassRepo(RecordClassRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return RecordClassRepo(dioService);
}

class RecordClassRepo {
  final DioService _dioService;

  RecordClassRepo(this._dioService);

  Future<Either<ErrorResponse, RecordedClass>> getRecordedClassList(
      String userId) async {
    final response =
        await _dioService.getRequest("/recoded-class/course/$userId");

    if (response.statusCode == 200) {
      return Right(RecordedClass.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, RecordClassDetails>> getRecordClassById(
      String id) async {
    final response = await _dioService.getRequest("/recoded-class/$id");

    if (response.statusCode == 200) {
      return Right(RecordClassDetails.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
