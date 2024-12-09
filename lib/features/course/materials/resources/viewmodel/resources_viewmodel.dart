import 'package:prostuti/features/course/materials/resources/model/resource_details_model.dart';
import 'package:prostuti/features/course/materials/resources/model/resources_model.dart';

import 'package:prostuti/features/course/materials/resources/repository/resources_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/services/nav.dart';
import '../../../../auth/login/view/login_view.dart';

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
        .getResourcesList("675556f0740a4834eef7d563");

    return response.fold(
      (l) {
        Nav().pushAndRemoveUntil(const LoginView());
        throw Exception(l.message);
      },
      (course) {
        return course.data ?? [];
      },
    );
  }
}
