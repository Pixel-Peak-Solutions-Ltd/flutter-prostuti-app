import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/auth/login/view/login_view.dart';
import 'package:prostuti/features/course/materials/resources/model/resource_details_model.dart';
import 'package:prostuti/features/course/materials/resources/repository/resources_repo.dart';
import 'package:prostuti/features/course/materials/resources/viewmodel/get_resource_by_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resource_details_viewmodel.g.dart';

@riverpod
class ResourceDetailsViewmodel extends _$ResourceDetailsViewmodel {
  @override
  FutureOr<ResourceDetails> build() async {
    return await getRecordClassById();
  }

  Future<ResourceDetails> getRecordClassById() async {
    final String id = ref.watch(getResourceByIdProvider);
    final response = await ref.read(resourcesRepoProvider).getResourceById(id);

    return response.fold(
      (l) {
        Nav().pushAndRemoveUntil(const LoginView());
        throw Exception(l.message);
      },
      (resource) {
        return resource;
      },
    );
  }
}
