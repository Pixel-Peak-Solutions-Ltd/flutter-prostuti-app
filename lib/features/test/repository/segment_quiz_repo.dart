import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/core/services/dio_service.dart';

part 'segment_quiz_repo.g.dart';

@riverpod
SegmentQuizRepo segmentQuizRepo(SegmentQuizRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return SegmentQuizRepo(dioService);
}

class SegmentQuizRepo {
  final DioService _dioService;

  SegmentQuizRepo(this._dioService);

  Future<Map<String, dynamic>> createSegmentQuiz(Map<String, dynamic> payload) async {
    const endpoint = '/quiz/create-segment-quiz';
    final response = await _dioService.postRequest(endpoint, payload);

    if (response.statusCode != 200 || response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to create segment quiz');
    }

    return response.data;
  }
}
