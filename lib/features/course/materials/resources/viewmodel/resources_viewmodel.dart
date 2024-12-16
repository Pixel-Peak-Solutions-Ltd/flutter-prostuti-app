import 'package:prostuti/features/course/materials/resources/model/resources_model.dart';
import 'package:prostuti/features/course/materials/resources/repository/resources_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resources_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class ResourceViewmodel extends _$ResourceViewmodel {
  @override
  Future<List<ResourceListData>> build() async {
    return await getCourseDetails();
  }

  Future<List<ResourceListData>> getCourseDetails() async {
    // final String id = ref.watch(getCourseByIdProvider);
    final response = await ref
        .read(resourcesRepoProvider)
        .getResourcesList("675ef486113c2a9fdca7887f");

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
