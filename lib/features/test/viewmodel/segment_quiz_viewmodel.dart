import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/mock_quiz_model.dart';
import '../model/mock_written_quiz_model.dart';
import '../model/question_pattern_model.dart';
import '../repository/segment_quiz_repo.dart';

part 'segment_quiz_viewmodel.g.dart';

@riverpod
class SegmentQuizViewmodel extends _$SegmentQuizViewmodel {
  @override
  FutureOr<void> build() {}

  Future<dynamic> startTest({
    required QuestionPattern pattern,
    required List<Subject> selectedOptionalSubjects,
    required int time,
    required BuildContext context,
  }) async {
    state = const AsyncLoading();

    try {
      final usedSubjects = [
        ...?pattern.mainSubjects?.map((e) => e.subject),
        ...selectedOptionalSubjects.map((e) => e.subject),
      ];

      final List<String> categoryIds = pattern.categoryId
          ?.where((cat) => usedSubjects.contains(cat.subject))
          .map((e) => e.id ?? '')
          .where((id) => id.isNotEmpty)
          .toList() ??
          [];

      final payload = {
        "questionType": pattern.questionType,
        "mainSubjects": pattern.mainSubjects
            ?.map((e) => {
          "subject": e.subject,
          "questionCount": e.questionCount,
        })
            .toList() ??
            [],
        "optionalSubjects": selectedOptionalSubjects
            .map((e) => {
          "subject": e.subject,
          "questionCount": e.questionCount,
        })
            .toList(),
        "category_id": categoryIds,
        "isNegativeMarking": false,
        "time": time,
      };

      final responseJson =
      await ref.read(segmentQuizRepoProvider).createSegmentQuiz(payload);

      dynamic parsedData;
      if (pattern.questionType == 'Written') {
        parsedData = MockWrittenQuizResponse.fromJson(responseJson);
      } else if (pattern.questionType == 'MCQ') {
        parsedData = MockQuizResponse.fromJson(responseJson);
      } else {
        throw Exception('Unsupported questionType: ${pattern.questionType}');
      }

      state = AsyncData(parsedData);

      return parsedData;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
