import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/flashcard_details_model.dart';

part 'flashcard_detail_repo.g.dart';

@riverpod
FlashcardDetailRepo flashcardDetailRepo(FlashcardDetailRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return FlashcardDetailRepo(dioService);
}

class FlashcardDetailRepo {
  final DioService _dioService;

  FlashcardDetailRepo(this._dioService);

  Future<Either<ErrorResponse, FlashcardDetailResponse>> getFlashcardDetail(
      String flashcardId) async {
    final response = await _dioService
        .getRequest("/flashcard/single-flashcard/$flashcardId");

    if (response.statusCode == 200) {
      return Right(FlashcardDetailResponse.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
