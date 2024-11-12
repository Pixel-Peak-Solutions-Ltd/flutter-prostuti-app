import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_see_more_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class LessonSeeMoreViewmodel extends _$LessonSeeMoreViewmodel {
  @override
  bool build() {
    return false;
  }

  void toggleBtn() {
    state = !state;
  }
}
