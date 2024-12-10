import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_resource_by_id.g.dart';

@riverpod
class getResourceById extends _$getResourceById {
  @override
  String build() {
    return "";
  }

  void setResourceId(String id) {
    state = id;
  }
}
