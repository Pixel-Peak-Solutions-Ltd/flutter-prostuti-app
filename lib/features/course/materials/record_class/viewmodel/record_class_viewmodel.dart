import 'package:prostuti/features/course/materials/record_class/model/record_class_model.dart';
import 'package:prostuti/features/course/materials/record_class/repository/record_class_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'record_class_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class RecordClassViewmodel extends _$RecordClassViewmodel {
  @override
  Future<List<RecordedClassData>> build() async {
    return await getCourseDetails();
  }

  Future<List<RecordedClassData>> getCourseDetails() async {
    // final String id = ref.watch(getCourseByIdProvider);
    final response = await ref
        .read(recordClassRepoProvider)
        .getRecordedClassList("67548199740a4834eef7d49c");

    return response.fold(
      (l) {
        throw Exception(l.message);
      },
      (course) {
        return course.data ?? [];
      },
    );
  }
}
