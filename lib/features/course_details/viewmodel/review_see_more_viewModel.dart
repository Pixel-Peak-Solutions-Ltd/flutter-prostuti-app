import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_see_more_viewModel.g.dart';

@Riverpod(keepAlive: true)
class ReviewSeeMoreViewmodel extends _$ReviewSeeMoreViewmodel {
  @override
  bool build() {
    return false;
  }

  void toggleBtn() {
    state = !state;
  }
}
