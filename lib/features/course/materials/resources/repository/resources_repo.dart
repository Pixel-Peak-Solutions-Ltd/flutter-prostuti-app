// __brick__/repository/resources_repo.dart
import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/features/course/materials/resources/model/resource_details_model.dart';
import 'package:prostuti/features/course/materials/resources/model/resources_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

import '../../../../../core/services/error_handler.dart';
import '../../../../../core/services/error_response.dart';
import '../../../../../core/services/nav.dart';
import '../../../../auth/login/view/login_view.dart';

part 'resources_repo.g.dart';

@riverpod
ResourcesRepo resourcesRepo(ResourcesRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return ResourcesRepo(dioService);
}

class ResourcesRepo {
  final DioService _dioService;

  ResourcesRepo(this._dioService);

  Future<Either<ErrorResponse, ResourceList>> getResourcesList(
      String userId) async {
    final response = await _dioService.getRequest("/resource/course/$userId");

    if (response.statusCode == 200) {
      return Right(ResourceList.fromJson(response.data));
    } else if (response.statusCode == 401) {
      Nav().pushAndRemoveUntil(const LoginView());
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, ResourceDetails>> getResourceById(
      String id) async {
    final response = await _dioService.getRequest("/resource/$id");

    if (response.statusCode == 200) {
      return Right(ResourceDetails.fromJson(response.data));
    } else if (response.statusCode == 401) {
      Nav().pushAndRemoveUntil(const LoginView());
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
