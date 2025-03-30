// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exploreFlashcardsHash() => r'4168320fdef363ca1d529ea9fef1f3e2663cbe01';

/// See also [ExploreFlashcards].
@ProviderFor(ExploreFlashcards)
final exploreFlashcardsProvider = AutoDisposeAsyncNotifierProvider<
    ExploreFlashcards, List<Flashcard>>.internal(
  ExploreFlashcards.new,
  name: r'exploreFlashcardsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exploreFlashcardsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExploreFlashcards = AutoDisposeAsyncNotifier<List<Flashcard>>;
String _$userFlashcardsHash() => r'ee0d76f7ad49c0ebc4b3b0897a76c4571f1712c4';

/// See also [UserFlashcards].
@ProviderFor(UserFlashcards)
final userFlashcardsProvider =
    AutoDisposeAsyncNotifierProvider<UserFlashcards, List<Flashcard>>.internal(
  UserFlashcards.new,
  name: r'userFlashcardsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userFlashcardsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserFlashcards = AutoDisposeAsyncNotifier<List<Flashcard>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
