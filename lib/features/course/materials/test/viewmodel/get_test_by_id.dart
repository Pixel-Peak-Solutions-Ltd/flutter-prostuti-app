import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_test_by_id.g.dart';

@riverpod
class GetTestById extends _$GetTestById {
  @override
  String build() {
    return "";
  }

  void setTestId(String id) {
    state = id;
  }
}
