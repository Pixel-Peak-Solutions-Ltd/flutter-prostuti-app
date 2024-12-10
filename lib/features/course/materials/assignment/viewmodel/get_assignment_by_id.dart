import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_assignment_by_id.g.dart';

@riverpod
class GetAssignmentById extends _$GetAssignmentById {
  @override
  String build() {
    return "";
  }

  void setAssignmentId(String id) {
    state = id;
  }
}
