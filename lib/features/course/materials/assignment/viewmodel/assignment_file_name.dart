import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'assignment_file_name.g.dart';

@riverpod
class AssignmentFileName extends _$AssignmentFileName {
  @override
  String build() {
    return "";
  }

  void setFileName(String name) {
    state = name;
  }
}
