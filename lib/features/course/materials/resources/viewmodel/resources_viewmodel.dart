import 'package:prostuti/features/course/materials/resources/model/resources_model.dart';
import 'package:prostuti/features/course/materials/resources/repository/resources_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../course_list/viewmodel/get_course_by_id.dart';

part 'resources_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class ResourceViewmodel extends _$ResourceViewmodel {
  @override
  Future<List<ResourceListData>> build() async {
    return await getCourseDetails();
  }

  Future<List<ResourceListData>> getCourseDetails() async {
    final String id = ref.watch(getCourseByIdProvider);
    final response = await ref.read(resourcesRepoProvider).getResourcesList(id);

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
