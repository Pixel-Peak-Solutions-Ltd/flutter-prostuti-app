import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'name_viewmodel.g.dart';

@riverpod
class NameViewmodel extends _$NameViewmodel {
  @override
  String build() {
    return "";
  }

  void setName(String name) {
    state = name;
  }
}
