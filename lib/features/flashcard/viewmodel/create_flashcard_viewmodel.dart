import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/create_flash_card.dart';
import '../repository/flashcard_repo.dart';

part 'create_flashcard_viewmodel.g.dart';

@Riverpod(keepAlive: false)
class CreateFlashcardNotifier extends _$CreateFlashcardNotifier {
  @override
  AsyncValue<bool> build() {
    return const AsyncValue.data(false);
  }

  Future<bool> createFlashcard(CreateFlashcardRequest request) async {
    state = const AsyncValue.loading();

    final response =
        await ref.read(flashcardRepoProvider).createFlashcard(request);

    return response.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
        return false;
      },
      (responseData) {
        state = const AsyncValue.data(true);
        return true;
      },
    );
  }
}
