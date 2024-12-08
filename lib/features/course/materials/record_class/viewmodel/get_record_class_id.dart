import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_record_class_id.g.dart';

@riverpod
class GetRecordClassId extends _$GetRecordClassId {
  @override
  String build() {
    return "";
  }

  void setRecordClassId(String id) {
    state = id;
  }
}
