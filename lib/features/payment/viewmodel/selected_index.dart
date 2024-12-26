import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_index.g.dart';

@riverpod
class SelectedIndexNotifier extends _$SelectedIndexNotifier {
  @override
  int build() => 0;

  void updateIndex(int index) {
    state = index;
  }
}
