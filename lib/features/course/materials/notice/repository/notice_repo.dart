import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/notice_model.dart';

part 'notice_repo.g.dart';

@riverpod
NoticeRepo noticeRepo(NoticeRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return NoticeRepo(dioService);
}

class NoticeRepo {
  final DioService _dioService;

  NoticeRepo(this._dioService);

  Future<Either<ErrorResponse, Notice>> getNoticesByCourseId(
      String courseId) async {
    final response = await _dioService.getRequest("/notice/course/$courseId");

    if (response.statusCode == 200) {
      print(response);
      return Right(Notice.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
