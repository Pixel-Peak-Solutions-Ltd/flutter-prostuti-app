// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_filter_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$flashcardFilterHash() => r'962553642407ab59158fbc3fded3f057bea3bb74';

/// See also [FlashcardFilter].
@ProviderFor(FlashcardFilter)
final flashcardFilterProvider =
    NotifierProvider<FlashcardFilter, FilterState>.internal(
  FlashcardFilter.new,
  name: r'flashcardFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$flashcardFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FlashcardFilter = Notifier<FilterState>;
String _$categoriesHash() => r'3cc549836004e310983a9b9091ee5a98aca47a15';

/// See also [Categories].
@ProviderFor(Categories)
final categoriesProvider =
    AsyncNotifierProvider<Categories, List<Category>>.internal(
  Categories.new,
  name: r'categoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$categoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Categories = AsyncNotifier<List<Category>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
