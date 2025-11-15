import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/core/services/localization_service.dart';

import '../model/category_model.dart';
import '../viewmodel/flashcard_filter_viewmodel.dart';
import '../viewmodel/flashcard_viewmodel.dart';

class FlashcardFilterSheet extends ConsumerStatefulWidget {
  const FlashcardFilterSheet({super.key});  

  @override
  FlashcardFilterSheetState createState() => FlashcardFilterSheetState();
}

class FlashcardFilterSheetState extends ConsumerState<FlashcardFilterSheet> {
  bool _isTypeExpanded = true;
  bool _isSecondLevelExpanded = false;
  bool _isThirdLevelExpanded = false;
  bool _isFourthLevelExpanded = false;
  bool _isSubjectExpanded = false;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final filterState = ref.watch(flashcardFilterProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n!.filter,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Gap(16),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Type Filter Section
                  _buildFilterSection(
                    title: context.l10n!.type,
                    isExpanded: _isTypeExpanded,
                    onToggle: () =>
                        setState(() => _isTypeExpanded = !_isTypeExpanded),
                    content: categoriesAsync.when(
                      data: (categories) {
                        final types = ref
                            .read(categoriesProvider.notifier)
                            .getUniqueTypes(categories);

                        return types.isEmpty
                            ? Center(
                                child: Text(context.l10n!.noTypesAvailable))
                            : _buildOptionsList(
                                items: types,
                                selectedValue: filterState.selectedType,
                                onSelected: (value) {
                                  ref
                                      .read(flashcardFilterProvider.notifier)
                                      .setType(value);
                                  setState(() {
                                    _isSecondLevelExpanded = true;
                                    _isTypeExpanded = false;
                                    _isThirdLevelExpanded = false;
                                    _isFourthLevelExpanded = false;
                                    _isSubjectExpanded = false;
                                  });
                                },
                              );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) =>
                          Center(child: Text('${context.l10n!.error}: $error')),
                    ),
                  ),

                  const Gap(16),

                  // Second Level Filter Section (Division/JobType/UniversityType)
                  if (filterState.selectedType != null)
                    _buildFilterSection(
                      title: _getSecondLevelTitle(filterState.selectedType!),
                      isExpanded: _isSecondLevelExpanded,
                      onToggle: () => setState(() =>
                          _isSecondLevelExpanded = !_isSecondLevelExpanded),
                      content: categoriesAsync.when(
                        data: (categories) {
                          final items = _getSecondLevelItems(
                              categories, filterState.selectedType!);

                          return items.isEmpty
                              ? Center(
                                  child: Text(_getNoItemsMessage(
                                      filterState.selectedType!)))
                              : _buildOptionsList(
                                  items: items,
                                  selectedValue:
                                      _getSecondLevelValue(filterState),
                                  onSelected: (value) {
                                    _setSecondLevelValue(
                                        value, filterState.selectedType!);
                                    setState(() {
                                      _isThirdLevelExpanded =
                                          _shouldShowThirdLevel(
                                              filterState.selectedType!, value);
                                      _isSecondLevelExpanded = false;
                                      _isFourthLevelExpanded = false;
                                      _isSubjectExpanded = false;
                                    });
                                  },
                                );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, _) => Center(
                            child: Text('${context.l10n!.error}: $error')),
                      ),
                    ),

                  const Gap(16),

                  // Third Level Filter Section (JobName/UniversityName)
                  if (_shouldShowThirdLevelSection(filterState))
                    _buildFilterSection(
                      title: _getThirdLevelTitle(filterState.selectedType!),
                      isExpanded: _isThirdLevelExpanded,
                      onToggle: () => setState(
                          () => _isThirdLevelExpanded = !_isThirdLevelExpanded),
                      content: categoriesAsync.when(
                        data: (categories) {
                          final items =
                              _getThirdLevelItems(categories, filterState);

                          return items.isEmpty
                              ? Center(child: Text('No items available'))
                              : _buildOptionsList(
                                  items: items,
                                  selectedValue:
                                      _getThirdLevelValue(filterState),
                                  onSelected: (value) {
                                    _setThirdLevelValue(
                                        value, filterState.selectedType!);
                                    setState(() {
                                      _isFourthLevelExpanded =
                                          _shouldShowFourthLevel(
                                              filterState, value);
                                      _isThirdLevelExpanded = false;
                                      _isSubjectExpanded = false;
                                    });
                                  },
                                );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, _) => Center(
                            child: Text('${context.l10n!.error}: $error')),
                      ),
                    ),

                  const Gap(16),

                  // Fourth Level Filter Section (Unit)
                  if (_shouldShowFourthLevelSection(filterState))
                    _buildFilterSection(
                      title: 'Unit',
                      isExpanded: _isFourthLevelExpanded,
                      onToggle: () => setState(() =>
                          _isFourthLevelExpanded = !_isFourthLevelExpanded),
                      content: categoriesAsync.when(
                        data: (categories) {
                          final units = ref
                              .read(categoriesProvider.notifier)
                              .getUniqueUnits(
                                categories,
                                filterState.selectedUniversityType,
                                filterState.selectedUniversityName,
                              );

                          return units.isEmpty
                              ? Center(child: Text('No units available'))
                              : _buildOptionsList(
                                  items: units,
                                  selectedValue: filterState.selectedUnit,
                                  onSelected: (value) {
                                    ref
                                        .read(flashcardFilterProvider.notifier)
                                        .setUnit(value);
                                    setState(() {
                                      _isSubjectExpanded = true;
                                      _isFourthLevelExpanded = false;
                                    });
                                  },
                                );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, _) => Center(
                            child: Text('${context.l10n!.error}: $error')),
                      ),
                    ),

                  const Gap(16),

                  // Subject Filter Section
                  if (filterState.selectedType != null)
                    _buildFilterSection(
                      title: context.l10n!.subject,
                      isExpanded: _isSubjectExpanded,
                      onToggle: () => setState(
                          () => _isSubjectExpanded = !_isSubjectExpanded),
                      content: categoriesAsync.when(
                        data: (categories) {
                          final subjects = ref
                              .read(categoriesProvider.notifier)
                              .getUniqueSubjects(categories, filterState);

                          return subjects.isEmpty
                              ? Center(
                                  child:
                                      Text(context.l10n!.noSubjectsAvailable))
                              : _buildOptionsList(
                                  items: subjects,
                                  selectedValue: filterState.selectedSubject,
                                  onSelected: (value) {
                                    ref
                                        .read(flashcardFilterProvider.notifier)
                                        .setSubject(value);
                                  },
                                );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, _) => Center(
                            child: Text('${context.l10n!.error}: $error')),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Gap(24),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    ref.read(flashcardFilterProvider.notifier).applyFilters();
                    ref.invalidate(exploreFlashcardsProvider);
                    ref.invalidate(userFlashcardsProvider);
                    Navigator.pop(context);
                  },
                  child: Text(
                    context.l10n!.applyFilter,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              if (filterState.isFilterActive) ...[
                const Gap(16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: const BorderSide(color: Color(0xff2970FF)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      ref.read(flashcardFilterProvider.notifier).resetFilters();
                      ref.invalidate(exploreFlashcardsProvider);
                      ref.invalidate(userFlashcardsProvider);
                      Navigator.pop(context);
                    },
                    child: Text(
                      context.l10n!.resetFilter,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: const Color(0xff2970FF),
                          ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _getSecondLevelTitle(String type) {
    switch (type) {
      case 'Academic':
        return context.l10n!.division;
      case 'Job':
        return 'Job Type';
      case 'Admission':
        return 'Institute Type';
      default:
        return '';
    }
  }

  String _getThirdLevelTitle(String type) {
    switch (type) {
      case 'Job':
        return 'Job Name';
      case 'Admission':
        return 'Institute Name';
      default:
        return '';
    }
  }

  String _getNoItemsMessage(String type) {
    switch (type) {
      case 'Academic':
        return context.l10n!.noDivisionsAvailable;
      case 'Job':
        return 'No job types available';
      case 'Admission':
        return 'No university types available';
      default:
        return 'No items available';
    }
  }

  List<String> _getSecondLevelItems(List<Category> categories, String type) {
    final notifier = ref.read(categoriesProvider.notifier);
    switch (type) {
      case 'Academic':
        return notifier.getUniqueDivisions(categories);
      case 'Job':
        return notifier.getUniqueJobTypes(categories);
      case 'Admission':
        return notifier.getUniqueUniversityTypes(categories);
      default:
        return [];
    }
  }

  List<String> _getThirdLevelItems(
      List<Category> categories, FilterState filterState) {
    final notifier = ref.read(categoriesProvider.notifier);
    switch (filterState.selectedType) {
      case 'Job':
        return notifier.getUniqueJobNames(
            categories, filterState.selectedJobType);
      case 'Admission':
        return notifier.getUniqueUniversityNames(
            categories, filterState.selectedUniversityType);
      default:
        return [];
    }
  }

  String? _getSecondLevelValue(FilterState filterState) {
    switch (filterState.selectedType) {
      case 'Academic':
        return filterState.selectedDivision;
      case 'Job':
        return filterState.selectedJobType;
      case 'Admission':
        return filterState.selectedUniversityType;
      default:
        return null;
    }
  }

  String? _getThirdLevelValue(FilterState filterState) {
    switch (filterState.selectedType) {
      case 'Job':
        return filterState.selectedJobName;
      case 'Admission':
        return filterState.selectedUniversityName;
      default:
        return null;
    }
  }

  void _setSecondLevelValue(String value, String type) {
    switch (type) {
      case 'Academic':
        ref.read(flashcardFilterProvider.notifier).setDivision(value);
        break;
      case 'Job':
        ref.read(flashcardFilterProvider.notifier).setJobType(value);
        break;
      case 'Admission':
        ref.read(flashcardFilterProvider.notifier).setUniversityType(value);
        break;
    }
  }

  void _setThirdLevelValue(String value, String type) {
    switch (type) {
      case 'Job':
        ref.read(flashcardFilterProvider.notifier).setJobName(value);
        break;
      case 'Admission':
        ref.read(flashcardFilterProvider.notifier).setUniversityName(value);
        break;
    }
  }

  bool _shouldShowThirdLevel(String type, String? secondLevelValue) {
    switch (type) {
      case 'Job':
        return secondLevelValue != null;
      case 'Admission':
        return secondLevelValue == 'University';
      default:
        return false;
    }
  }

  bool _shouldShowThirdLevelSection(FilterState filterState) {
    switch (filterState.selectedType) {
      case 'Job':
        return filterState.selectedJobType != null;
      case 'Admission':
        return filterState.selectedUniversityType == 'University';
      default:
        return false;
    }
  }

  bool _shouldShowFourthLevel(
      FilterState filterState, String? thirdLevelValue) {
    return filterState.selectedType == 'Admission' &&
        filterState.selectedUniversityType == 'University' &&
        thirdLevelValue != null;
  }

  bool _shouldShowFourthLevelSection(FilterState filterState) {
    return filterState.selectedType == 'Admission' &&
        filterState.selectedUniversityType == 'University' &&
        filterState.selectedUniversityName != null;
  }

  Widget _buildFilterSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: content,
            ),
        ],
      ),
    );
  }

  Widget _buildOptionsList({
    required List<String> items,
    required String? selectedValue,
    required Function(String) onSelected,
  }) {
    return Column(
      children: items.map((item) {
        final isSelected = item == selectedValue;

        return InkWell(
          onTap: () => onSelected(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        )
                      : null,
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w400,
                          color: isSelected
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
