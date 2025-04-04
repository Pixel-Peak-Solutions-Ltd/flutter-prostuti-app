// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_filter_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$flashcardFilterHash() => r'06379ab862010af14b545ecc99f472aa395c720d';

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
String _$categoriesHash() => r'cee7f8498cd6ffee618b2ea9c2f0e58283ae23cd';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
