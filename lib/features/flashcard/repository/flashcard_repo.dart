import 'package:dartz/dartz.dart';
import 'package:prostuti/core/services/dio_service.dart';
import 'package:prostuti/core/services/error_handler.dart';
import 'package:prostuti/core/services/error_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/create_flash_card.dart';
import '../model/flashcard_model.dart';

part 'flashcard_repo.g.dart';

@riverpod
FlashcardRepo flashcardRepo(FlashcardRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return FlashcardRepo(dioService);
}

class FlashcardRepo {
  final DioService _dioService;

  FlashcardRepo(this._dioService);

  Future<Either<ErrorResponse, FlashcardResponse>> getAllFlashcards({
    int page = 1,
    int limit = 10,
    required String visibility,
  }) async {
    final response = await _dioService.getRequest(
      "/flashcard/all-flashcard",
      queryParameters: {
        "page": page,
        "limit": limit,
        "visibility": visibility,
      },
    );

    if (response.statusCode == 200) {
      return Right(FlashcardResponse.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, FlashcardResponse>> getUserFlashcards({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dioService.getRequest(
      "/flashcard/user-flashcards",
      queryParameters: {
        "page": page,
        "limit": limit,
        "visibility": "ONLY_ME",
      },
    );

    if (response.statusCode == 200) {
      return Right(FlashcardResponse.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  Future<Either<ErrorResponse, FlashcardResponse>> searchFlashcards(
      String query, String visibility, String categoryType) async {
    final response = await _dioService.getRequest(
      "/flashcard/all-flashcard",
      queryParameters: {
        "searchTerm": query,
        "visibility": visibility,
        "categoryType": categoryType,
      },
    );

    if (response.statusCode == 200) {
      return Right(FlashcardResponse.fromJson(response.data));
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }

  // New method for creating a flashcard
  Future<Either<ErrorResponse, Map<String, dynamic>>> createFlashcard(
      CreateFlashcardRequest request) async {
    final response = await _dioService.postRequest(
      "/flashcard/create-flashcard",
      request.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(response.data);
    } else {
      final errorResponse = ErrorResponse.fromJson(response.data);
      ErrorHandler().setErrorMessage(errorResponse.message);
      return Left(errorResponse);
    }
  }
}
