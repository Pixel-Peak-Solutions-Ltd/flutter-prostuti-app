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

@Riverpod(keepAlive: false)
class ChapterViewmodel extends _$ChapterViewmodel {
  @override
  Future<List<String>> build(String subject) async {
    final chapters = await ref.read(subjectRepoProvider).fetchChapters(subject);

    if (chapters.isEmpty) {
      return ['All'];
    }

    final uniqueChapters = chapters.toSet().toList();
    uniqueChapters.remove('All');
    return ['All', ...uniqueChapters];
  }
}
