import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/subject_repo.dart';

part 'subject_selector_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class SubjectViewmodel extends _$SubjectViewmodel {
  @override
  Future<List<String>> build(String selectedStandard) async {
    return await ref.read(subjectRepoProvider).fetchSubjects(selectedStandard);
  }
}
