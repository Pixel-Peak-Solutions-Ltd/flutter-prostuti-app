import 'package:prostuti/features/course/materials/record_class/model/record_class_details.dart';
import 'package:prostuti/features/course/materials/record_class/repository/record_class_repo.dart';
import 'package:prostuti/features/course/materials/record_class/viewmodel/get_record_class_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'record_class_details_viewmodel.g.dart';

@riverpod
class RecordClassDetailsViewmodel extends _$RecordClassDetailsViewmodel {
  @override
  FutureOr<RecordClassDetails> build() async {
    return await getRecordClassById();
  }

  Future<RecordClassDetails> getRecordClassById() async {
    final String id = ref.watch(getRecordClassIdProvider);
    final response =
        await ref.read(recordClassRepoProvider).getRecordClassById(id);

    return response.fold(
      (l) {
        throw Exception(l.message);
      },
      (recordClass) {
        return recordClass;
      },
    );
  }
}
