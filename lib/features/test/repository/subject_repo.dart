import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/core/services/dio_service.dart';

part 'subject_repo.g.dart';

@riverpod
SubjectRepo subjectRepo(SubjectRepoRef ref) {
  final dioService = ref.watch(dioServiceProvider);
  return SubjectRepo(dioService);
}

class SubjectRepo {
  final DioService _dioService;

  SubjectRepo(this._dioService);

  Future<List<String>> fetchSubjects(String selectedStandard) async {
    const String endpoint = '/category/subject';
    final Map<String, String> params = {};

    if (selectedStandard == "একাডেমিক") {
      params['type'] = 'Academic';
    } else if (selectedStandard == "ইঞ্জিনিয়ারিং") {
      params['universityType'] = 'Engineering';
    } else if (selectedStandard == "ভার্সিটি") {
      params['universityType'] = 'University';
    } else if (selectedStandard == "মেডিকেল") {
      params['universityType'] = 'Medical';
    }

    final response = await _dioService.getRequest(endpoint, queryParameters: params);

    if (response.statusCode == 200 && response.data['success'] == true) {
      return List<String>.from(response.data['data'] ?? []);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load subjects');
    }
  }
}
